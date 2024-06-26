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

AddVoiceLineScriptSoundToQueue("point_enabled")
hasControlPointBeenUnlocked <- false;

function SetConvarValue(cvar, value, do_warning = true)
{
    if(!Convars.IsConVarOnAllowList(cvar))
    {
        ClientPrint(null, HUD_PRINTCONSOLE, "VSCRIPTVSH WARNING --- Tried to change convar " + cvar + " to " + value + " but it isn't on the convar allow list.")
        return;
    }

    Convars.SetValue(cvar, value);
}

function SetConvars()
{
    SetConvarValue("tf_weapon_criticals", 0);
	SetConvarValue("tf_fall_damage_disablespread", 1);
	SetConvarValue("tf_use_fixed_weaponspreads", 1);

    SetConvarValue("mp_autoteambalance", 0);
    SetConvarValue("mp_teams_unbalance_limit", 0);
    SetConvarValue("mp_disable_respawn_times", 0);
    SetConvarValue("mp_respawnwavetime", 999999);
    SetConvarValue("tf_classlimit", 0);
    SetConvarValue("mp_forcecamera", 0);
    SetConvarValue("sv_alltalk", 1);
    SetConvarValue("tf_dropped_weapon_lifetime", 0);
    //SetConvarValue("mp_idledealmethod", 0);
    //SetConvarValue("mp_idlemaxtime", 9999);
    SetConvarValue("mp_scrambleteams_auto", 0);
    SetConvarValue("mp_stalemate_timelimit", 9999999);
    SetConvarValue("mp_scrambleteams_auto_windifference", 0);
    SetConvarValue("mp_humans_must_join_team", "red");
    SetConvarValue("tf_rd_points_per_approach", "500");
    SetConvarValue("sv_vote_issue_autobalance_allowed", "0");
    SetConvarValue("sv_vote_issue_scramble_teams_allowed", "0");
    SetConvarValue("tf_stalematechangeclasstime", casti2f(0x7fa00000)); //NaN.
    if (GetPersistentVar("mp_bonusroundtime") == null)
        SetPersistentVar("mp_bonusroundtime", Convars.GetInt("mp_bonusroundtime"));
}
SetConvars();

function SpawnHelperEntities()
{
    SetPropString(tf_gamerules, "SetBlueTeamGoalString", "Kill all Mercenaries");
    SetPropString(tf_gamerules, "SetRedTeamGoalString", "Kill Saxton Hale");

    SpawnEntityFromTable("filter_activator_tfteam", {
        Negated = 0,
        TeamNum = 3,
        targetname = "filter_team_boss",
    })

    SpawnEntityFromTable("filter_activator_tfteam", {
        Negated = 0,
        TeamNum = 2,
        targetname = "filter_team_mercs",
    })

    local controlPoint = Entities.FindByClassname(null, "team_control_point");
    if (controlPoint != null)
    {
        controlPoint.KeyValueFromInt("point_index", 0);
        controlPoint.KeyValueFromInt("point_start_locked", 1);
        EntFireByHandle(controlPoint, "SetLocked", "1", 0, null, null);
        EntityOutputs.AddOutput(controlPoint,
            "OnUnlocked",
            "!self",
            "ShowModel",
            "",
            0, -1);
        EntityOutputs.AddOutput(controlPoint,
            "OnCapReset",
            "!self",
            "HideModel",
            "",
            0, -1);
        EntityOutputs.AddOutput(controlPoint,
            "OnCapTeam"+(TF_TEAM_MERCS-1),
            vsh_vscript_name,
            "RunScriptCode",
            "EndRound("+TF_TEAM_MERCS+")",
            0, -1);
        EntityOutputs.AddOutput(controlPoint,
            "OnCapTeam"+(TF_TEAM_BOSS-1),
            vsh_vscript_name,
            "RunScriptCode",
            "EndRound("+TF_TEAM_BOSS+")",
            0, -1);
    }

    local pointMaster = Entities.FindByClassname(null, "team_control_point_master");
    if (pointMaster == null)
        SpawnEntityFromTable("team_control_point_master", {
            caplayout = 0,
            cpm_restrict_team_cap_win = 1,
            custom_position_x = -1,
            custom_position_x = -1,
            partial_cap_points_rate = 0
        });

    local auto = SpawnEntityFromTable("logic_auto", {
        spawnflags = 1,
        "OnMultiNewRound#1": "pd_logic,SetPointsOnPlayerDeath,0,0,-1",
        "OnMultiNewRound#2": "pd_logic,EnableMaxScoreUpdating,,0,-1",
        "OnMultiNewRound#3": "pd_logic,DisableMaxScoreUpdating,,5,-1",
    });

    CreatePDHud("knavish_vsh_hud");

    team_round_timer = SpawnEntityFromTable("team_round_timer", {
        targetname = "team_round_timer",
        auto_countdown = 1,
        max_length = 0,
        reset_time = 1,
        setup_length = API_GetFloat("setup_length"),
        show_in_hud = 1,
        show_time_remaining = 1,
        start_paused = 0,
        timer_length = API_GetFloat("round_time"),
        StartDisabled = 0,
        "OnSetupFinished#1": vsh_vscript_name+",RunScriptCode,FinishSetup(),0,-1",
        "OnSetupFinished#2": "vsh_setup*,Trigger,,0,-1",
        "OnSetupFinished#3": "vsh_setup*,Open,,0,-1",
        "On1MinRemain": "vsh_1min*,Trigger,,0,-1",
        "OnFinished#1": vsh_vscript_name+",RunScriptCode,UnlockControlPoint(),0,-1"
        "OnFinished#2": vsh_vscript_name+",RunScriptCode,PrepareStalemate(),0,-1"
    });
    team_round_timer.ValidateScriptScope();
    team_round_timer.GetScriptScope().Tick <- function()
    {
        if (isRoundPostSpawn)
            vsh_vscript.FireListeners("tick_frame");
        return -1;
    }
    AddThinkToEnt(team_round_timer, "Tick")
}
SpawnHelperEntities();

function UnlockControlPoint()
{
    if(hasControlPointBeenUnlocked)
        return;

    hasControlPointBeenUnlocked <- true;

    local controlPoint = Entities.FindByClassname(null, "team_control_point");
    if (controlPoint != null)
        EntFireByHandle(controlPoint, "SetUnlockTime", "0", 0, null, null);
    PlayAnnouncerVO(GetRandomBossPlayer(), "point_enabled");
}

function PrepareStalemate()
{
    if(hasStalemateTimerBegun)
        return;

    hasStalemateTimerBegun <- true;

    local boss = GetRandomBossPlayer();
    local delay = clampFloor(60, API_GetFloat("stalemate_time"));

    EntFireByHandle(team_round_timer, "SetTime", delay.tostring(), 0, null, null);

    PlayAnnouncerVODelayed(boss, "count5", delay - 6, true);
    PlayAnnouncerVODelayed(boss, "count4", delay - 5, true);
    PlayAnnouncerVODelayed(boss, "count3", delay - 4, true);
    PlayAnnouncerVODelayed(boss, "count2", delay - 3, true);
    PlayAnnouncerVODelayed(boss, "count1", delay - 2, true);

    RunWithDelay("EndRound(TF_TEAM_UNASSIGNED)", null, delay);
}