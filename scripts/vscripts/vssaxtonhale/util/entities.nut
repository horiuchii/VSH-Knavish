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

::CreatePDHud <- function(resfile)
{
    resfile = "resource/ui/" + resfile + ".res";

    CreatePDLogicEntity(resfile)
    RunWithDelay2(this, 0.1, function()
    {
        CreatePDLogicEntity(resfile)
    })
}

::CreatePDLogicEntity <- function(resfile)
{
    if(pd_logic != null)
        pd_logic.Destroy()

    pd_logic = SpawnEntityFromTable("tf_logic_player_destruction", {
        blue_respawn_time = 9999,
        finale_length = 999999,
        flag_reset_delay = 60,
        heal_distance = 0,
        min_points = 255,
        points_per_player = 0,
        red_respawn_time = 0,
        targetname = "pd_logic",
        res_file = resfile
    });
}