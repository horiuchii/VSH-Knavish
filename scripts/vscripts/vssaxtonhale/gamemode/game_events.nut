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

::isRoundPostSpawn <- false;

function OnPostSpawn()
{
    for (local i = 1; i <= MAX_PLAYERS; i++)
    {
        local player = PlayerInstanceFromIndex(i);
        if (player != null)
        {
            InitPlayerVariables(player);
        }
    }

    RecachePlayers();
    PrecacheGenericSoundScripts();
    PrecacheVoiceLineSoundScripts();

    FireListeners("new_round");

    if (IsValidRoundPreStart())
        FireListeners("setup_start");
    isRoundPostSpawn = true;
}

function Tick()
{
    try { TF_TEAM_MERCS; } catch(e) { return; }

    if (IsValidRound())
        FireListeners("tick_only_valid", 0.1);
    FireListeners("tick_always", 0.1);

    return 0.1;
}

function OnScriptHook_OnTakeDamage(params)
{
    if (params.const_entity == worldspawn) //wall climb off of the static world
    {
        if (params.damage_type & DMG_CLUB)
            MeleeWallClimb_Hit(params);
        return;
    }
    if (params.damage_type & DMG_CLUB) // Wall climb off of the rest of the world. worldspawn handled separately for performance reasons
    {
        if (MeleeWallClimb_Check(params))
        {
            MeleeWallClimb_Hit(params);
            return;
        }
    }
    if (IsNotValidRound() || !IsValidPlayerOrBuilding(params.const_entity))
        return;
    FireListeners("damage_hook", params.attacker, params.const_entity, params);
}

function OnGameEvent_player_hurt(params)
{
    if (IsNotValidRound())
        return;
    local victim = GetPlayerFromParams(params);
    if (!IsValidPlayer(victim))
        return;
    local attacker = GetPlayerFromParams(params, "attacker");
    if (!IsValidPlayer(attacker))
        return;
    FireListeners("player_hurt", attacker, victim, params);
}

function OnGameEvent_player_healed(params)
{
    if (IsNotValidRound())
        return;
    local patient = GetPlayerFromParams(params, "patient");
    if (!IsValidPlayer(patient))
        return;
    local healer = GetPlayerFromParams(params, "healer");
    if (!IsValidPlayer(healer))
        return;
    local amount = params.amount;
    FireListeners("player_healed", patient, healer, amount);
}

function OnGameEvent_player_team(params)
{
    if (IsNotValidRound())
        return;
    local player = GetPlayerFromUserID(params["userid"]);
    if (player == null || !player.IsValid() || !player.IsPlayer())
        return;
    FireListeners("team_change", player, params);
}

function OnGameEvent_player_say(params)
{
	local player = GetPlayerFromUserID(params.userid);
    if (player == null || !player.IsValid() || !player.IsPlayer())
    return;
    FireListeners("chat", player, params.text);
}

function OnGameEvent_player_changeclass(params)
{
    if (IsNotValidRound())
        return;
    local player = GetPlayerFromParams(params);
    if (!IsValidPlayer(player))
        return;
    FireListeners("class_change", player, params);
}

function OnGameEvent_player_spawn(params)
{
    if (IsInWaitingForPlayers() || IsNotValidRound())
        return;
    local player = GetPlayerFromParams(params);
    if (!IsValidPlayer(player))
        return;
    FireListeners("spawn", player, params);
}

function OnGameEvent_player_death(params)
{
    if (params.death_flags & TF_DEATHFLAG.DEAD_RINGER || IsNotValidRound())
        return;
    local player = GetPlayerFromParams(params);
    if (!IsValidPlayer(player))
        return;
    local attacker = GetPlayerFromParams(params, "attacker");
    FireListeners("death", attacker, player, params);
}

function OnGameEvent_object_destroyed(params)
{
    if (IsNotValidRound())
        return;
    local attacker = GetPlayerFromParams(params, "attacker");
    if (!IsValidPlayer(attacker))
        return;
    FireListeners("builing_destroyed", attacker, params);
}

function OnGameEvent_rps_taunt_event(params)
{
    local winner = PlayerInstanceFromIndex(params.winner);
    local loser = PlayerInstanceFromIndex(params.loser);
    if (!IsValidBoss(winner) && !IsValidBoss(loser))
        return;
    FireListeners("rps_with_boss", winner, loser, params);
}

function FinishSetup()
{
    // TODO: I don't know why we should bother allowing duels.
    // Just end the round if hale is force respawned, which will happen once
    // a duel is accepted if the class locked duel isn't the boss's class ~ Brad
    // TODO: Hale-specific check to fix Class-Restricted Duels bug.
    local boss = GetRandomBossPlayer();
    if (boss != null && boss.GetPlayerClass() != TF_CLASS_HEAVY && !IsRoundOver())
    {
        boss.RemoveCond(TF_COND_STUNNED);
        boss.RemoveCond(TF_COND_TAUNTING);
        DiscardTraits(boss);
        characterTraits[boss] <- [];
        characterTraitsTable[boss] <- {};
        boss.ForceRespawn();
        RefreshBossSetup(boss);
        boss.Get().ApplyTrait(boss);

        RunWithDelay2(this, 1, function (boss)
        {
            if (boss.GetPlayerClass() == TF_CLASS_HEAVY)
                return;
            boss.TakeDamage(999999, 0, null);
            EndRound(TF_TEAM_UNASSIGNED);
        }, boss)
    }

    FireListeners("setup_end");
    isRoundSetup = false;
}

function OnGameEvent_post_inventory_application(params)
{
    local player = GetPlayerFromParams(params);
    if (!IsValidClient(player))
        return;
    player.GTFW_Cleanup();
    FireListeners("post_inventory", player, params);
}

function OnGameEvent_player_disconnect(params)
{
    local player = GetPlayerFromParams(params);
    if (!IsValidClient(player))
        return;
    FireListeners("disconnect", player, params);
}

function OnGameEvent_player_activate(params)
{
    FireListeners("connect", GetPlayerFromParams(params));
}

function OnGameEvent_player_stunned(params)
{
    local attacker = GetPlayerFromParams(params, "stunner");
    if (!IsValidClient(attacker))
        return;
    local victim = GetPlayerFromParams(params, "victim");
    if (!IsValidClient(victim))
        return;
    FireListeners("player_stunned", attacker, victim, params.big_stun);
}

function OnGameEvent_player_chargedeployed(params)
{
    local player = GetPlayerFromParams(params);
    if (!IsValidClient(player))
        return;

    FireListeners("player_uber", player);
}

function OnGameEvent_object_deflected(params)
{
    local airblaster = GetPlayerFromParams(params);
    if (!IsValidClient(airblaster))
        return;
    local victim = GetPlayerFromParams(params, "ownerid");
    if (!IsValidClient(victim))
        return;

    FireListeners("player_airblast", airblaster, victim);
}