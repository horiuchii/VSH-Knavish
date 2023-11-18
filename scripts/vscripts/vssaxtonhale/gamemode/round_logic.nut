//=========================================================================
//Copyright LizardOfOz.

//
//Credits:
//  LizardOfOz - Programming, game design, promotional material and overall development. The original VSH Plugin from 2010.
//  Maxxy - Saxton Hale's model imitating Jungle Inferno SFM; Custom animations and promotional material.
//  Velly - VFX, animations scripting, technical assistance.
//  JPRAS - Saxton model development assistance and feedback.
//  MegapiemanPHD - Saxton Hale and Gray Mann voice acting.
//  James McGuinn - Mercenaries voice acting for custom lines.
//  Yakibomb - give_tf_weapon script bundle (used for Hale's first-person hands model).
//=========================================================================

isRoundOver <- false;
::isRoundSetup <- true;
hasStalemateTimerBegun <- false;

AddListener("setup_start", 1, function ()
{
    SetConvarValue("mp_bonusroundtime", GetPersistentVar("mp_bonusroundtime"));
    RemoveAllRespawnRooms();

    RecachePlayers();
    AssignBoss("saxton_hale", ProgressBossQueue());

    foreach (player in GetValidMercs())
    {
        player.SwitchTeam(TF_TEAM_MERCS);
        player.ForceRegenerateAndRespawn();
    }

    foreach (player in GetBossPlayers())
    {
        player.SwitchTeam(TF_TEAM_BOSS);
        player.ForceRegenerateAndRespawn();
        bosses[player].TryApply(player);
    }
});

AddListener("setup_end", 0, function()
{
    //Respawn all Mercs when Setup ends
    foreach (player in GetValidMercs())
        if (!player.IsAlive())
            player.ForceRespawn();

    RemoveAllRespawnRooms();

    SetPropInt(tf_gamerules, "m_iRoundState", 7);
    SetPropInt(tf_gamerules, "m_nHudType", 2);

    SetConvarValue("tf_rd_points_per_approach", "10");
});

AddListener("death", 2, function (attacker, victim, params)
{
    if (IsRoundSetup() && !IsAnyBossAlive())
    {
        SetConvarValue("mp_bonusroundtime", 5);
        EndRound(TF_TEAM_UNASSIGNED);
    }
});

AddListener("spawn", 10, function(player, params)
{
    if (IsInWaitingForPlayers() || !IsRoundSetup())
        return;

    if (IsBoss(player))
        return;

    local respawn_trigger = SpawnEntityFromTable("func_respawnroom", {
        origin = player.GetCenter(),
        spawnflags = 1,
        IsEnabled = true,
        StartDisabled = 0,
        TeamNum = TF_TEAM_MERC
    });

    respawn_trigger.KeyValueFromInt("solid", 2);
    respawn_trigger.KeyValueFromString("mins", "-16 -16 -16");
    respawn_trigger.KeyValueFromString("maxs", "16 16 16");
    EntFireByHandle(respawn_trigger, "SetParent", "!activator", -1, player, null);
})

AddListener("tick_always", 8, function(timeDelta)
{
    if (IsInWaitingForPlayers())
        return;
    if (IsRoundSetup())
    {
        if (GetValidPlayerCount() <= 1 && !IsAnyBossAlive())
        {
            SetPropInt(team_round_timer, "m_bTimerPaused", 1);
            return;
        }
        //Bailout
        if (!IsAnyBossAlive())
        {
            SetConvarValue("mp_bonusroundtime", 5);
            EndRound(TF_TEAM_UNASSIGNED);
        }
        return;
    }
    if (!hasStalemateTimerBegun && GetAliveMercCount() <= 5 && GetPropFloat(team_round_timer, "m_flTimeRemaining") > 60)
        EntFireByHandle(team_round_timer, "SetTime", "60", 0, null, null);

    local noBossesAlive = !IsAnyBossAlive();
    local noMercsAlive = GetAliveMercCount() <= 0;

    if (noBossesAlive && noMercsAlive)
        EndRound(TF_TEAM_UNASSIGNED);
    else if (noBossesAlive)
        EndRound(TF_TEAM_MERCS);
    else if (noMercsAlive)
        EndRound(TF_TEAM_BOSS);
});

function EndRound(winner)
{
    if (isRoundOver)
        return;
    if (!IsAnyBossAlive() && IsRoundSetup())
        winner = TF_TEAM_UNASSIGNED;

    local roundWin = Entities.FindByClassname(null, "game_round_win");
    if (roundWin == null)
    {
        roundWin = SpawnEntityFromTable("game_round_win",
        {
            win_reason = "0",
            force_map_reset = "1", //not having
            TeamNum = "0",         //these 3 lines
            switch_teams = "0"     //causes the crash when trying to fire game_round_win
        });
    }
    EntFireByHandle(roundWin, "SetTeam", "" + winner, 0, null, null);
    EntFireByHandle(roundWin, "RoundWin", "", 0, null, null);

    DoEntFire("vsh_round_end*", "Trigger", "", 0, null, null);
    if (winner == TF_TEAM_MERCS)
        DoEntFire("vsh_mercs_win*", "Trigger", "", 0, null, null);
    else
        DoEntFire("vsh_boss_win*", "Trigger", "", 0, null, null);
    FireListeners("round_end", winner);
    isRoundOver = true;
    SetPersistentVar("last_round_winner", winner)

    RunWithDelay2(this, -1, function()
    {
        SendGlobalGameEvent("teamplay_game_over", {});

        local leaderboard = GetDamageBoardSorted();

        local merc_score = 0
        local boss_score = 0

        local ent = null
        while( ent = Entities.FindByClassname(ent, "tf_team") )
        {
            local team = GetPropInt(ent, "m_iTeamNum")
            if(team == TF_TEAM_MERC)
                merc_score = GetPropInt(ent, "m_iScore");
            if(team == TF_TEAM_BOSS)
                boss_score = GetPropInt(ent, "m_iScore");
        }

        local event_data = {
            panel_style = 1,
            winning_team = winner,
            winreason = 0,
            cappers = "",
            flagcaplimit = 3,
            blue_score = boss_score,
            red_score = merc_score,
            blue_score_prev = winner == TF_TEAM_BOSS ? boss_score - 1 : boss_score,
            red_score_prev = winner == TF_TEAM_MERC ? merc_score - 1 : merc_score,
            round_complete = 1,
            rounds_remaining = 0,
            game_over = false
        };

        local count = clampCeiling(leaderboard.len(), 3);

        if(count >= 3)
        {
            local ent_index = leaderboard[2][0].entindex()
            local player = leaderboard[2][0]
            event_data.player_3 <- ent_index
            event_data.player_3_damage <- leaderboard[2][1]
            event_data.player_3_lifetime <- GetDeathTime(player)
            event_data.player_3_healing <- GetRoundHealing(player)
            event_data.player_3_kills <- GetRoundKills(player)
        }
        if(count >= 2)
        {
            local ent_index = leaderboard[1][0].entindex()
            local player = leaderboard[1][0]
            event_data.player_2 <- ent_index
            event_data.player_2_damage <- leaderboard[1][1]
            event_data.player_2_lifetime <- GetDeathTime(player)
            event_data.player_2_healing <- GetRoundHealing(player)
            event_data.player_2_kills <- GetRoundKills(player)
        }
        if(count >= 1)
        {
            local ent_index = leaderboard[0][0].entindex()
            local player = leaderboard[0][0]
            event_data.player_1 <- leaderboard[0][0].entindex()
            event_data.player_1_damage <- leaderboard[0][1]
            event_data.player_1_lifetime <- GetDeathTime(player)
            event_data.player_1_healing <- GetRoundHealing(player)
            event_data.player_1_kills <- GetRoundKills(player)
        }

        if(IsAnyBossValid())
        {
            event_data.player_4 <- GetBossPlayers()[0].entindex()
            event_data.player_4_damage <- boss_damage //set up for duo-boss in future
            event_data.player_4_lifetime <- GetTimeSinceRoundStarted() //set up for duo-boss in future
            event_data.player_4_kills <- GetRoundKills(GetBossPlayers()[0])
        }

        SendGlobalGameEvent("arena_win_panel", event_data)
    });
}

function IsNotValidRound()
{
    return IsInWaitingForPlayers() || !IsAnyBossValid() || GetValidPlayerCount() < 2;
}

function IsValidRound()
{
    return !IsInWaitingForPlayers() && IsAnyBossValid() && GetValidPlayerCount() >= 2;
}

function IsValidRoundPreStart()
{
    return !IsInWaitingForPlayers() && GetValidPlayerCount() >= 2;
}

::IsRoundSetup <- function()
{
    return isRoundSetup;
}

function IsRoundOver()
{
    return isRoundOver;
}

function RemoveAllRespawnRooms()
{
    local respawnRoom = null;
    local respawnsToKill = [];
    while (respawnRoom = Entities.FindByClassname(respawnRoom, "func_respawnroom"))
        respawnsToKill.push(respawnRoom);
    foreach (respawnRoom in respawnsToKill)
        respawnRoom.Kill();
}