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

game_text_merc_hud <- null;
env_hudhint <- null;
bossBarTicker <- 0;

function SpawnTextEntities(void)
{
    game_text_merc_hud = SpawnEntityFromTable("game_text",
    {
        color = "236 227 203",
        color2 = "0 0 0",
        channel = 1,
        effect = 0,
        fadein = 0,
        fadeout = 0,
        fxtime = 0,
        holdtime = 250,
        message = "0",
        spawnflags = 0,
        x = 0.481,
        y = 0.788
    });

    env_hudhint = SpawnEntityFromTable("env_hudhint", {message = "HOLD <SPECIAL ATTACK / MOUSE3> TO VIEW WEAPON STAT CHANGES"});
}
SpawnTextEntities(null);

AddListener("tick_only_valid", 2, function (timeDelta)
{
    TickBossBar(GetBossPlayers()[0]); //todo not built for duo-bosses

    foreach (player in GetValidMercs())
    {
        local buttons = GetPropInt(player, "m_nButtons");

        if (buttons & IN_SCORE)
        {
            player.SetScriptOverlayMaterial(null);
            continue;
        }

        local number = floor(player in damage ? damage[player] : 0);
        local offset = number < 10 ? 0.498 : number < 100 ? 0.493 : number < 1000 ? 0.491 : 0.487;

        EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 0", 0, player, player);
        EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + number, 0, player, player);
        EntFireByHandle(game_text_merc_hud, "AddOutput", "y 0.788", 0, player, player);
        EntFireByHandle(game_text_merc_hud, "AddOutput", "x " + offset, 0, player, player);
        EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);

        if (buttons & IN_ATTACK3)
        {
            //display weapon stats
            local weapon_primary = "";
            if (player.GetPlayerClass() == TF_CLASS_DEMOMAN && player.HasWearable("any_demo_boots"))
                weapon_primary = GetWeaponDescription("booties");
            else
                weapon_primary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY)))

            local weapon_secondary = "";
            if (player.GetPlayerClass() == TF_CLASS_SNIPER && player.HasWearable("razorback"))
                weapon_secondary = GetWeaponDescription("razorback");
            else if (player.GetPlayerClass() == TF_CLASS_DEMOMAN && player.HasWearable("any_demo_shield"))
                weapon_secondary = GetWeaponDescription("shield_generic");
            else if (player.GetPlayerClass() == TF_CLASS_SPY)
                weapon_secondary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.INVIS_WATCH)));
            else
                weapon_secondary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY)));

            local weapon_melee = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE)));

            player.SetScriptOverlayMaterial(API_GetString("ability_hud_folder") + "/weapon_info");
            EntFireByHandle(env_hudhint, "HideHudHint", "", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + weapon_primary + weapon_secondary + weapon_melee, 0, player, player);
            EntFireByHandle(game_text_merc_hud, "AddOutput", "y 0.295", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "AddOutput", "x 0.71", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
        }
        else
        {
            player.SetScriptOverlayMaterial(null);
            EntFireByHandle(env_hudhint, IsRoundSetup() ? "ShowHudHint" : "HideHudHint", "", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "AddOutput", "message  ", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
        }
    }
});

function TickBossBar(boss)
{
    if (boss.IsDead())
        return;
    if (bossBarTicker < 2)
    {
        bossBarTicker++;
        SetPropInt(pd_logic, "m_nBlueScore", 0);
        SetPropInt(pd_logic, "m_nBlueTargetPoints", 0);
        return
    }
    local barValue = clampCeiling(boss.GetHealth(), boss.GetMaxHealth());
    SetPropInt(pd_logic, "m_nBlueScore", barValue);
    SetPropInt(pd_logic, "m_nBlueTargetPoints", barValue);
    SetPropInt(pd_logic, "m_nMaxPoints", boss.GetMaxHealth());
    SetPropInt(pd_logic, "m_nRedScore", GetAliveMercCount());
}