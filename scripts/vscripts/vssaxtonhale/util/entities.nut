::vsh_vscript <- this;
if(self.GetName() == "")
    self.KeyValueFromString("targetname", "logic_script_vsh");
::vsh_vscript_name <- self.GetName();
::vsh_vscript_entity <- self;

//This hack allows to detect when a melee weapon hits the world
::worldspawn <- Entities.FindByClassname(null, "worldspawn");
SetPropInt(worldspawn, "m_takedamage", 1);

::tf_gamerules <- Entities.FindByClassname(null, "tf_gamerules");
tf_gamerules.ValidateScriptScope();
::tf_player_manager <- Entities.FindByClassname(null,"tf_player_manager");
::team_round_timer <- null;
::pd_logic <- null;

::CreatePDLogicEntity <- function(res_file_path, red_score, blue_score)
{
    printl("CREATING LOGIC FOR: " + res_file_path)

    pd_logic = SpawnEntityFromTable("tf_logic_player_destruction", {
        blue_respawn_time = 9999,
        finale_length = 999999,
        flag_reset_delay = 60,
        heal_distance = 0,
        min_points = 255,
        points_per_player = 0,
        red_respawn_time = 0,
        targetname = "pd_logic",
        res_file = res_file_path
    });

    SetPropInt(pd_logic, "m_nRedScore", red_score);
    SetPropInt(pd_logic, "m_nBlueScore", blue_score);
}

::CreatePDHud <- function(res_file_name)
{
    local res_file_path = "resource/ui/" + res_file_name + ".res";

    local delay = true;
    local red_score = 0;
    local blue_score = 0;
    if(pd_logic)
    {
        red_score = GetPropInt(pd_logic, "m_nRedScore");
        blue_score = GetPropInt(pd_logic, "m_nBlueScore");
        pd_logic.Destroy();
    }
    else
        delay = false;

    if(!delay)
        CreatePDLogicEntity(res_file_path, red_score, blue_score);
    else
        RunWithDelay2(this, 1.0, function(){CreatePDLogicEntity(res_file_path, red_score, blue_score);});
}