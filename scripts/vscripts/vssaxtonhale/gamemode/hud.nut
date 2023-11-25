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

game_text_merc_hud <- SpawnEntityFromTable("game_text",
{
    color = "236 227 203",
    channel = 1,
    fadein = 0,
    fadeout = 0,
    holdtime = 250,
    message = "This is a test",
    x = 0.481,
    y = 0.788
});
env_hudhint <- SpawnEntityFromTable("env_hudhint", {message = "PRESS <SPECIAL ATTACK / +ATTACK3> TO VIEW WEAPON STATS\nDOUBLE TAP TO OPEN VSH MENU"});
bossBarTicker <- 0;

player_last_buttons <- {};
function WasButtonDownLastFrame (player, button_query, current_buttons)
{
    if(!(player in player_last_buttons))
        player_last_buttons[player] <- 0;

    return !(player_last_buttons[player] & button_query) && current_buttons & button_query;
}

DOUBLE_PRESS_MENU_THRESHOLD <- 0.25;
last_press_menu_button <- {};
selected_option <- {};
menu_index <- {};

menu_option_names <- [
    menu_0 <- [
        ["Toggle Becoming Boss", "[ON]\nToggle the ability to gain queue points.\nTurning off will remove any existing points."],
        ["Reset Queue Points", "\nResets your position in\nthe queue to become boss."],
        ["Set Boss Difficulty", "[NORMAL]\nSet the difficulty for a more\nengaging experience as the boss."],
        ["Set Preferred Boss", "[SAXTON]\nChoose who you would like to play\nas when chosen as the boss."],
        ["Toggle Merc Voicelines", "[ON]\nToggle the ability to hear voicelines the mercs speak.\nWill not prevent others from hearing yours."]
    ]
]

AddListener("spawn", 0, function (player, params)
{
    RunWithDelay2(this, 0.1, function () {
        if (IsRoundSetup() && !IsBoss(player))
        {
            EntFireByHandle(env_hudhint, "ShowHudHint", "", 0, player, player);
        }
    })
});

AddListener("tick_only_valid", 2, function (deltaTime) {
    TickBossBar(GetBossPlayers()[0]); //todo not built for duo-bosses
})

AddListener("tick_frame", 2, function ()
{
    foreach (player in GetValidPlayers())
    {
        if(IsBoss(player))
            return;

        local buttons = GetPropInt(player, "m_nButtons");
        if (!(player in last_press_menu_button))
            last_press_menu_button[player] <- 0;

        if (buttons & IN_SCORE)
        {
            player.SetScriptOverlayMaterial(null);
            continue;
        }

        if (!(player in menu_index) && (WasButtonDownLastFrame(player, IN_ATTACK3, buttons) || WasButtonDownLastFrame(player, IN_RELOAD, buttons)))
        {
            if (Time() - last_press_menu_button[player] < DOUBLE_PRESS_MENU_THRESHOLD)
            {
                selected_option[player] <- 0;
                menu_index[player] <- 0;
                SetPropString(env_hudhint, "m_iszMessage", "");
                EntFireByHandle(env_hudhint, "HideHudHint", "", 0, player, player);
                PlaySoundForPlayer(player, "ui/cyoa_map_open.wav");
            }
            else
                last_press_menu_button[player] <- Time();
        }

        if (player in menu_index)
        {
            UpdateVSHMenuHUD(player);
        }
        else if ((buttons & IN_ATTACK3 || buttons & IN_RELOAD) && last_press_menu_button[player] + 0.125 < Time())
        {
            UpdateWeaponStatHUD(player);
        }
        else
        {
            EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "AddOutput", "message ", 0, player, player);
            EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
            player.SetScriptOverlayMaterial(null);
            UpdateDamageHUD(player);
        }

        player_last_buttons[player] <- buttons;
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

function UpdateDamageHUD(player)
{
    local number = floor(player in damage ? damage[player] : 0);
    local offset = number < 10 ? 0.498 : number < 100 ? 0.493 : number < 1000 ? 0.491 : 0.487;

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 0", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + number, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "y 0.788", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "x " + offset, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
}

function UpdateVSHMenuHUD(player)
{
    local buttons = GetPropInt(player, "m_nButtons");
    if (WasButtonDownLastFrame(player, IN_FORWARD, buttons))
    {
        local length = menu_option_names[menu_index[player]].len() - 1;
        local new_loc = (selected_option[player]) - 1;
        if (new_loc < 0)
            new_loc = length;
        else if (new_loc > length)
            new_loc = 0;

        selected_option[player] <- new_loc;
        PlaySoundForPlayer(player, "ui/buttonrollover.wav");
    }
    if (WasButtonDownLastFrame(player, IN_BACK, buttons))
    {
        local length = menu_option_names[menu_index[player]].len() - 1;
        local new_loc = (selected_option[player]) + 1;
        if (new_loc < 0)
            new_loc = length;
        else if (new_loc > length)
            new_loc = 0;

        selected_option[player] <- new_loc;
        PlaySoundForPlayer(player, "ui/buttonrollover.wav");
    }

    if (WasButtonDownLastFrame(player, IN_ATTACK, buttons))
    {
        PlaySoundForPlayer(player, "ui/buttonclick.wav");
    }

    if (buttons & IN_ATTACK2)
    {
        if (menu_index[player] != 0)
        {
            local option_to_select = 0;
            switch(menu_index[player])
            {
                default: break;
            }
            selected_option[player] <- option_to_select;
            menu_index[player] <- 0;
            return;
        }

        delete menu_index[player];
        player.RemoveFlag(FL_ATCONTROLS);
        player.SetScriptOverlayMaterial(null);
        SetPropInt(player, "m_Local.m_iHideHUD", 0);
        SetPropFloat(player, "m_flNextAttack", Time() + 0.5);
        PlaySoundForPlayer(player, "ui/cyoa_map_close.wav");

        EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
        EntFireByHandle(game_text_merc_hud, "AddOutput", "message ", 0, player, player);
        EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
        return;
    }

    local message = "\n\n\n\n\n";
    local menu_size = menu_option_names[menu_index[player]].len();
    local option_count = 2;
    for(local i = selected_option[player] - option_count; i < selected_option[player] + (option_count + 1); i++)
    {
        local index = i;

        if(index < 0)
            index = menu_size + index;

        if(index > menu_size - 1)
            index = index - menu_size;

        message += menu_option_names[menu_index[player]][index][0]
        message += "\n"
    }
    local description = menu_option_names[menu_index[player]][selected_option[player]][1]

    message += "\n" + description + "\n\n\n\n\n\n";

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "y -1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "x -1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + message, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", -1, player, player);

    player.AddFlag(FL_ATCONTROLS);
    SetPropFloat(player, "m_flNextAttack", 999999);
    player.SetScriptOverlayMaterial(API_GetString("ability_hud_folder") + "/" + "vsh_menu");
    SetPropInt(player, "m_Local.m_iHideHUD", HIDEHUD_WEAPONSELECTION | HIDEHUD_HEALTH | HIDEHUD_MISCSTATUS | HIDEHUD_CROSSHAIR);
}

function UpdateWeaponStatHUD(player)
{
    //display weapon stats
    local weapon_primary = "";
    if (player.GetPlayerClass() == TF_CLASS_DEMOMAN && player.HasWearable("any_demo_boots"))
        weapon_primary = GetWeaponDescription("booties");
    else
        weapon_primary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY)))

    local weapon_secondary = "";
    if (player.GetPlayerClass() == TF_CLASS_SNIPER && player.HasWearable("any_sniper_backpack"))
    {
        local wearable = player.GetWearable("any_sniper_backpack");
        weapon_secondary = GetWeaponDescription(GetWeaponName(wearable));
    }
    else if (player.GetPlayerClass() == TF_CLASS_DEMOMAN && player.HasWearable("any_demo_shield"))
    {
        local wearable = player.GetWearable("any_demo_shield");
        weapon_secondary = GetWeaponDescription(GetWeaponName(wearable));
    }
    else if (player.GetPlayerClass() == TF_CLASS_SPY)
        weapon_secondary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.INVIS_WATCH)));
    else
        weapon_secondary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY)));

    local weapon_melee = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE)));

    player.SetScriptOverlayMaterial(API_GetString("ability_hud_folder") + "/weapon_info");

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + weapon_primary + weapon_secondary + weapon_melee, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "y 0.295", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "x 0.71", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
}