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

::isRoundOver <- false;
::isRoundSetup <- true;
hasStalemateTimerBegun <- false;
::isRoundBailout <- false;
::hasRoundStarted <- false;

AddListener("setup_start", 1, function ()
{
    SetConvarValue("mp_bonusroundtime", GetPersistentVar("mp_bonusroundtime"));

    EntFireByHandle(tf_gamerules, "AddRedTeamScore", GetPersistentVar("merc_score", 0).tostring(), -1, null, null);
    EntFireByHandle(tf_gamerules, "AddBlueTeamScore", GetPersistentVar("boss_score", 0).tostring(), -1, null, null);

    RemoveAllRespawnRooms();

    RecachePlayers();
    AssignBoss(ProgressBossQueue());
    RecachePlayers();

    foreach (player in GetValidMercs())
    {
        player.Set(Mercenary);
        player.SwitchTeam(TF_TEAM_MERCS);
        player.ForceRegenerateAndRespawn();
        player.Get().ApplyTrait(player);
    }

    foreach (player in GetBossPlayers())
    {
        player.SwitchTeam(TF_TEAM_BOSS);
        player.ForceRegenerateAndRespawn();
        try
        {
            player.Set(bossLibrary[CookieUtil.Get(player, "boss")]);
        }
        catch (exception)
        {
            CookieUtil.Set(player, "boss", "saxton_hale");
            player.Set(bossLibrary["saxton_hale"]);
        }

        CreatePDHud("knavish_vsh_hud_" + GetBossPlayers()[0].Get().name);
    }
});

AddListener("setup_end", -1, function()
{
    hasRoundStarted <- true;
    //Respawn all Mercs when Setup ends
    foreach (player in GetValidMercs())
        if (!player.IsAlive())
            player.ForceRespawn();

    RemoveAllRespawnRooms();

    SetPropInt(tf_gamerules, "m_iRoundState", GR_STATE_STALEMATE);
    SetPropInt(tf_gamerules, "m_nHudType", 2);

    SetConvarValue("tf_rd_points_per_approach", "10");

    local boss = GetBossPlayers()[0];
    local difficulty = CookieUtil.Get(boss, "difficulty");
    PrintToClient(null, KNA_VSH + boss.NetName() + " became " + "\x07" + boss.Get().GetHexColor() + boss.Get().name_proper + "\x01 on \x07" + DifficultyColor[difficulty] + DifficultyName[difficulty] + "\x01 difficulty.")
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
    // Stop music played in this channel
    PrecacheSound("misc/null.wav")
    EmitSoundEx({
        sound_name = "misc/null.wav"
        channel = CHAN_MUSIC
        entity = player
        filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
    });

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
            isRoundBailout <- true;
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

    RunWithDelay2(this, Convars.GetInt("mp_bonusroundtime"), function()
    {
        SetConvarValue("mp_restartgame_immediate", 1);
    });

    EntFireByHandle(team_round_timer, "Pause", null, -1, null, null);

    local round_end_stun = SpawnEntityFromTable("trigger_stun",
    {
        stun_type = 2,
        stun_effects = false,
        stun_duration = 9999,
        trigger_delay = -1,
        StartDisabled = 0,
        spawnflags = 1,
        solid = 2
    });

    AddListener("tick_always", 8, function(timeDelta)
    {
        foreach(player in GetValidPlayers())
        {
            if(player.GetTeam() == winner)
                player.AddCond(TF_COND_CRITBOOSTED_BONUS_TIME)
            else
            {
                EntFireByHandle(round_end_stun, "EndTouch", "", -1, player, player);
            }

        }
    });

    if(winner == TF_TEAM_MERC)
    {
        EntFireByHandle(tf_gamerules, "AddRedTeamScore", "1", -1, null, null);
        SetPersistentVar("merc_score", GetPersistentVar("merc_score", 0) + 1);
    }

    else if(winner == TF_TEAM_BOSS)
    {
        EntFireByHandle(tf_gamerules, "AddBlueTeamScore", "1", -1, null, null);
        SetPersistentVar("boss_score", GetPersistentVar("boss_score", 0) + 1);
    }

    EntFireByHandle(Entities.FindByClassname(null, "team_control_point"), "SetLocked", "1", -1, null, null);

    DoEntFire("vsh_round_end*", "Trigger", "", 0, null, null);
    if (winner == TF_TEAM_MERCS)
        DoEntFire("vsh_mercs_win*", "Trigger", "", 0, null, null);
    else
        DoEntFire("vsh_boss_win*", "Trigger", "", 0, null, null);
    FireListeners("round_end", winner);
    isRoundOver = true;
    SetPersistentVar("last_round_winner", winner)

    local winpanelname = "knavish_vsh_hud_winpanel_"
    if(isRoundBailout)
        winpanelname += "bailout"
    else if(winner == TF_TEAM_UNASSIGNED)
        winpanelname += "stalemate"
    else if(winner == TF_TEAM_MERC)
        winpanelname += "merc"
    else if(winner == TF_TEAM_BOSS)
        winpanelname += GetBossPlayers()[0].Get().name

    CreatePDHud(winpanelname);

    RunWithDelay2(this, 0.15, function()
    {
        RoundEndHUD.GenerateRoundEndPanel(winner);

        foreach(player in GetValidClients())
        {
            RoundEndHUD.AddHUD(player, true);
        }
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

::IsRoundOver <- function()
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