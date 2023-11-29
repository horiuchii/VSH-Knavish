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
    message = "",
    x = 0.481,
    y = 0.788
});
env_hudhint <- SpawnEntityFromTable("env_hudhint", {message = "HOLD <INSPECT> TO VIEW WEAPON STATS\nDOUBLE TAP <MOUSE 3> OR CHAT /vshmenu TO OPEN VSH MENU"});
env_hudhint_boss <- SpawnEntityFromTable("env_hudhint", {message = "DOUBLE TAP <MOUSE 3> OR CHAT /vshmenu TO OPEN VSH MENU"});
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
::menu_index <- {};

AddListener("spawn", 0, function (player, params)
{
    RunWithDelay2(this, 1.0, function () {
        if(IsBoss(player))
            EntFireByHandle(env_hudhint_boss, "ShowHudHint", "", 0, player, player);
        else
            EntFireByHandle(env_hudhint, "ShowHudHint", "", 0, player, player);
    })
});

AddListener("chat", 0, function (player, message)
{
    if(message == "!vshmenu" || message == "/vshmenu" || message == "vshmenu")
    {
        OpenVSHMenuHUD(player);
    }
});

AddListener("tick_only_valid", 2, function (deltaTime) {
    TickBossBar(GetBossPlayers()[0]); //todo not built for duo-bosses
})

AddListener("tick_frame", 2, function ()
{
    foreach (player in GetValidPlayers())
    {
        if (IsPlayerABot(player))
            continue;

        local buttons = GetPropInt(player, "m_nButtons");

        if (buttons & IN_SCORE)
        {
            player.SetScriptOverlayMaterial(null);
            continue;
        }

        if (!(player in last_press_menu_button))
            last_press_menu_button[player] <- 0;

        if (WasButtonDownLastFrame(player, IN_ATTACK3, buttons))
        {
            if (IsInVSHMenu(player))
                CloseVSHMenuHUD(player);
            else if (Time() - last_press_menu_button[player] < DOUBLE_PRESS_MENU_THRESHOLD)
                OpenVSHMenuHUD(player);
            else
                last_press_menu_button[player] <- Time();
        }

        if (IsInVSHMenu(player))
            UpdateVSHMenuHUD(player);
        else if (player.IsInspecting() && !IsBoss(player))
            UpdateWeaponStatHUD(player);
        else if (!IsBoss(player))
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

::IsInVSHMenu <- function(player)
{
    return player in menu_index;
}

function OpenVSHMenuHUD(player)
{
    if(IsInVSHMenu(player))
        return;

    if(!(player in selected_option))
        selected_option[player] <- 0;

    menu_index[player] <- MENU.Main;
    EntFireByHandle(env_hudhint, "HideHudHint", "", 0, player, player);
    EntFireByHandle(env_hudhint_boss, "HideHudHint", "", 0, player, player);
    PlaySoundForPlayer(player, "ui/cyoa_map_open.wav");

    if(!player.IsAlive())
        player.SetOrigin(player.GetOrigin() + Vector(0,0,64))
}

function CloseVSHMenuHUD(player)
{
    if(!IsInVSHMenu(player))
        return;

    delete menu_index[player];
    player.RemoveFlag(FL_ATCONTROLS);
    player.SetScriptOverlayMaterial(null);
    SetPropFloat(player, "m_flNextAttack", Time() + 0.5);
    PlaySoundForPlayer(player, "ui/cyoa_map_close.wav");
    if(!player.IsAlive())
    {
        SetPropInt(player, "m_iObserverMode", OBS_MODE_CHASE)
        SetPropInt(player, "m_Local.m_iHideHUD", HIDEHUD_HEALTH);
    }
    else
        SetPropInt(player, "m_Local.m_iHideHUD", 0);

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message ", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
}

function UpdateVSHMenuHUD(player)
{
    if(!player.IsAlive())
    {
        SetPropInt(player, "m_iObserverMode", OBS_MODE_DEATHCAM);
        SetPropEntity(player, "m_hObserverTarget", player);
    }

    local buttons = GetPropInt(player, "m_nButtons");
    if (WasButtonDownLastFrame(player, IN_FORWARD, buttons) || WasButtonDownLastFrame(player, IN_BACK, buttons))
    {
        local length = menu_options[menu_index[player]].len() - 1;
        local new_loc = (selected_option[player]) + (WasButtonDownLastFrame(player, IN_FORWARD, buttons) ? -1 : 1);
        if (new_loc < 0)
            new_loc = length;
        else if (new_loc > length)
            new_loc = 0;

        selected_option[player] <- new_loc;
        PlaySoundForPlayer(player, "ui/cyoa_node_absent.wav");
    }

    if (WasButtonDownLastFrame(player, IN_ATTACK, buttons))
    {
        menu_options[menu_index[player]][selected_option[player]].OnSelected.acall([this, player]);
        PlaySoundForPlayer(player, "ui/buttonclick.wav");
    }

    if (WasButtonDownLastFrame(player, IN_ATTACK2, buttons))
    {
        if (menu_index[player] != MENU.Main)
        {
            local option_to_select = 0;
            switch(menu_index[player])
            {
                case MENU.BossDifficulty: option_to_select = MENU_ITEMS.BossDifficulty; break;
                default: break;
            }
            selected_option[player] <- option_to_select;
            menu_index[player] <- MENU.Main;
            PlaySoundForPlayer(player, "ui/buttonclick.wav");
            return;
        }

        CloseVSHMenuHUD(player);
        return;
    }

    //display menu options
    local message = "\n\n\n\n\n";
    local menu_size = menu_options[menu_index[player]].len();
    local option_count = 2;
    for(local i = selected_option[player] - option_count; i < selected_option[player] + (option_count + 1); i++)
    {
        local index = i;

        if(index < 0)
            index = menu_size + index;

        if(index > menu_size - 1)
            index = index - menu_size;

        message += menu_options[menu_index[player]][index].title
        message += "\n"
    }

    //display current setting if not null, this code fucking reeks
    local option_setting = menu_options[menu_index[player]][selected_option[player]].pref

    if(option_setting != null)
    {
        if(option_setting == COOKIE.Difficulty)
        {
            option_setting = Cookies.Get(player, COOKIE.Difficulty);
            switch(option_setting)
            {
                case DIFFICULTY.EASY: option_setting = "[EASY]\n"; break;
                case DIFFICULTY.NORMAL: option_setting = "[NORMAL]\n"; break;
                case DIFFICULTY.HARD: option_setting = "[HARD]\n"; break;
                case DIFFICULTY.EXTREME: option_setting = "[EXTREME]\n"; break;
                case DIFFICULTY.IMPOSSIBLE: option_setting = "[IMPOSSIBLE]\n"; break;
            }
        }
        else
        {
            option_setting = Cookies.Get(player, option_setting);
            if(type(option_setting) == "integer" || type(option_setting) == "bool")
                option_setting = option_setting ? "[ON]\n" : "[OFF]\n";
            else
                option_setting = "[" + option_setting + "]\n";
        }
    }
    else
        option_setting = ""

    local description = menu_options[menu_index[player]][selected_option[player]].description

    message += "\n" + option_setting + description + "\n\n\n\n\n\n";

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "y -1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "x -1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + message, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", -1, player, player);

    player.AddFlag(FL_ATCONTROLS);
    SetPropFloat(player, "m_flNextAttack", 999999);
    player.SetScriptOverlayMaterial(API_GetString("ability_hud_folder") + "/" + "vsh_menu" + menu_index[player].tostring());
    SetPropInt(player, "m_Local.m_iHideHUD", HIDEHUD_WEAPONSELECTION | HIDEHUD_HEALTH | HIDEHUD_MISCSTATUS | HIDEHUD_CROSSHAIR);
}

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

function UpdateWeaponStatHUD(player)
{
    EntFireByHandle(env_hudhint, "HideHudHint", "", 0, player, player);
    //display weapon stats
    local weapon_primary = "";
    if (player.GetPlayerClass() == TF_CLASS_DEMOMAN && player.HasWearable("any_demo_boots"))
        weapon_primary = GetWeaponDescription("booties");
    else
        weapon_primary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY)))

    local weapon_secondary = "";
    if (player.GetPlayerClass() == TF_CLASS_SNIPER
        && player.HasWearable("any_sniper_backpack"))
    {
        local wearable = player.GetWearable("any_sniper_backpack");
        weapon_secondary = GetWeaponDescription(GetWeaponName(wearable));
    }
    else if (player.GetPlayerClass() == TF_CLASS_DEMOMAN
        && player.HasWearable("any_demo_shield"))
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