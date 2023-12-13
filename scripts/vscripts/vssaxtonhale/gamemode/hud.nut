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

::game_text_merc_hud <- SpawnEntityFromTable("game_text",
{
    color = "236 227 203",
    channel = 1,
    fadein = 0,
    fadeout = 0,
    holdtime = 500,
    message = "",
    x = 0.481,
    y = 0.788
});

env_hudhint <- SpawnEntityFromTable("env_hudhint", {message = "%+inspect% HOLD TO VIEW WEAPON STATS%+attack3% DOUBLE TAP OR CHAT /vshmenu TO OPEN VSH MENU"});
env_hudhint_boss <- SpawnEntityFromTable("env_hudhint", {message = "%+attack3% DOUBLE TAP OR CHAT /vshmenu TO OPEN VSH MENU"});
bossBarTicker <- 0;

DOUBLE_PRESS_MENU_THRESHOLD <- 0.25;
last_press_menu_button <- {};
::selected_option <- {};
::selected_mainmenu_option <- {};
::menu_index <- {};

AddListener("spawn", 0, function (player, params)
{
    PrecacheSound("misc/null.wav")
    EmitSoundEx({
        sound_name = "misc/null.wav"
        channel = -1
        entity = player
        filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
    })

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

        local buttons = player.GetButtons();

        if (buttons & IN_SCORE)
        {
            player.SetScriptOverlayMaterial(null);
            continue;
        }

        if (player.WasButtonJustPressed(IN_ATTACK3))
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
    }
});

::IsInVSHMenu <- function(player)
{
    return player in menu_index;
}

::cyoaMusic <- [
    "drunkenpipebomb"
    "fasterthanaspeedingbullet"
    "intruderalert"
    "medic"
    "moregun"
    "moregun2"
    "playingwithdanger"
    "rightbehindyou"
    "teamfortress2"
]

function OpenVSHMenuHUD(player)
{
    if(IsInVSHMenu(player))
        return;

    menu_index[player] <- MENU.MainMenu;
    EntFireByHandle(env_hudhint, "HideHudHint", "", 0, player, player);
    EntFireByHandle(env_hudhint_boss, "HideHudHint", "", 0, player, player);
    PlaySoundForPlayer(player, "ui/cyoa_map_open.wav");

    if(!!CookieUtil.Get(player, "menu_music"))
    {
        local music = "ui/cyoa_music" + cyoaMusic[RandomInt(0, cyoaMusic.len() - 1)] + "_tv.mp3";
        PrecacheSound(music);
        EmitSoundEx({
            sound_name = music
            channel = -1
            entity = player
            filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
        });
    }

    GenerateVSHMenuHUDText(player);

    if(!player.IsAlive())
        player.SetOrigin(player.GetOrigin() + Vector(0,0,64))
}

function CloseVSHMenuHUD(player)
{
    if(!IsInVSHMenu(player))
        return;

    selected_option[player] = selected_mainmenu_option[player];

    delete menu_index[player];

    if(!IsBoss(player) || !(IsRoundSetup() && API_GetBool("freeze_boss_setup")))
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

    PrecacheSound("misc/null.wav")
    EmitSoundEx({
        sound_name = "misc/null.wav"
        channel = -1
        entity = player
        filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
    })

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message ", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
}

::GoUpVSHMenuDir <- function(player, playsound = true)
{
    if (menu_index[player] != MENU.MainMenu)
    {
        if(menus[menu_index[player]].parent_menuitem != null)
            selected_option[player] <- menus[menu_index[player]].parent_menuitem;

        if(menus[menu_index[player]].parent_menu != null)
            menu_index[player] <- menus[menu_index[player]].parent_menu;

        if(playsound)
            PlaySoundForPlayer(player, "ui/buttonclick.wav");

        GenerateVSHMenuHUDText(player);
    }
}

function UpdateVSHMenuHUD(player)
{
    if(!player.IsAlive())
    {
        SetPropInt(player, "m_iObserverMode", OBS_MODE_DEATHCAM);
        SetPropEntity(player, "m_hObserverTarget", player);
    }

    local buttons = player.GetButtons();
    // Navigate Menu
    if (player.WasButtonJustPressed(IN_FORWARD) || player.WasButtonJustPressed(IN_BACK))
    {
        local length = menus[menu_index[player]].items.len() - 1;
        local new_loc = (selected_option[player]) + (player.WasButtonJustPressed(IN_FORWARD) ? -1 : 1);
        if (new_loc < 0)
            new_loc = length;
        else if (new_loc > length)
            new_loc = 0;

        selected_option[player] <- new_loc;

        if(menu_index[player] == MENU.MainMenu)
            selected_mainmenu_option[player] <- new_loc;

        PlaySoundForPlayer(player, "ui/cyoa_node_absent.wav");
        GenerateVSHMenuHUDText(player);
    }

    // Select Menu Item
    if (player.WasButtonJustPressed(IN_ATTACK))
    {
        menus[menu_index[player]].items[selected_option[player]].OnSelected(player);
        PlaySoundForPlayer(player, "ui/buttonclick.wav");
        GenerateVSHMenuHUDText(player);
    }

    // Return To Previous Menu
    if (player.WasButtonJustPressed(IN_ATTACK2))
    {
        GoUpVSHMenuDir(player);
    }

    player.AddFlag(FL_ATCONTROLS);
    SetPropFloat(player, "m_flNextAttack", 999999);
    player.SetScriptOverlayMaterial(API_GetString("ability_hud_folder") + "vshhud/vsh_menu_" + menus[menu_index[player]].overlay);
    SetPropInt(player, "m_Local.m_iHideHUD", HIDEHUD_WEAPONSELECTION | HIDEHUD_HEALTH | HIDEHUD_MISCSTATUS | HIDEHUD_CROSSHAIR);
}

::GenerateVSHMenuHUDText <- function(player)
{
    local message = "\n\n\n\n\n";
    local menu_size = menus[menu_index[player]].items.len();
    local option_count = 2;
    for(local i = selected_option[player] - option_count; i < selected_option[player] + (option_count + 1); i++)
    {
        local index = i;

        if(index == -1)
        {
            message += "▲\n";
            continue;
        }
        if(index == menu_size)
        {
            message += "▼\n";
            continue;
        }
        if(index < 0 || index > menu_size - 1)
        {
            message += "\n"
            continue;
        }

        message += menus[menu_index[player]].items[index].title
        message += "\n"
    }

    local description = menus[menu_index[player]].items[selected_option[player]].GenerateDesc(player)

    message += "\n" + description + "\n\n\n\n\n\n";

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "y -1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "x -1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + message, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", -1, player, player);
}

function TickBossBar(boss)
{
    if (boss.IsDead())
        return;

    if(IsRoundSetup())
    {
        SetPropInt(pd_logic, "m_nBlueScore", 0);
        SetPropInt(pd_logic, "m_nBlueTargetPoints", 0);
        SetPropInt(pd_logic, "m_nMaxPoints", 0);
        SetPropInt(pd_logic, "m_nRedScore", GetAliveMercCount());
        return;
    }

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