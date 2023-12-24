class MenuHUD
{
    DOUBLE_PRESS_MENU_THRESHOLD = 0.25;
    last_press_menu_button = {};
    selected_option = {};
    selected_mainmenu_option = {};
    menu_index = {};
    HUDID = UniqueString();
    HUDPriority = 100;

    cyoaMusic =
    [
        "drunkenpipebomb"
        "fasterthanaspeedingbullet"
        "intruderalert"
        "medic"
        "moregun"
        "moregun2"
        "playingwithdanger"
        "rightbehindyou"
        "teamfortress2"
    ];

    function AddHUD(player)
    {
        HUD.Add(player, CreateIdentifier(), CreateHUDObject());
    }

    function CreateIdentifier()
    {
        return HUDIdentifier(HUDID, HUDPriority);
    }

    function CreateHUDObject()
    {
        return HUDObject(
            [
                class extends HUDChannel
                {
                    function Update()
                    {
                        MenuHUD.UpdateVSHMenuHUD(player, params);
                    }

                    function OnEnabled()
                    {
                        MenuHUD.OpenVSHMenuHUD(player, params);
                        base.OnEnabled();
                    }

                    function OnDisabled()
                    {
                        MenuHUD.CloseVSHMenuHUD(player, params);
                        base.OnDisabled();
                    }
                }(-1, -1, "255 255 255")
            ]
        );
    }

    function OnPlayerChat(player, message)
    {
        if((message == "!vshmenu" || message == "/vshmenu" || message == "vshmenu") && !IsInVSHMenu(player))
        {
            HUD.Get(player, HUDID).Enable();
        }
    }

    function OnFrameTick()
    {
        foreach (player in GetValidClients())
        {
            if (IsPlayerABot(player))
                continue;

            local buttons = player.GetButtons();

            if (buttons & IN_SCORE)
            {
                HUD.Get(player, HUDID).overlay = null;
                continue;
            }

            if (player.WasButtonJustPressed(IN_ATTACK3))
            {
                if (IsInVSHMenu(player))
                {
                    HUD.Get(player, HUDID).Disable();
                }
                else if (Time() - last_press_menu_button[player] < DOUBLE_PRESS_MENU_THRESHOLD)
                {
                    HUD.Get(player, HUDID).Enable();
                }
                else
                {
                    last_press_menu_button[player] <- Time();
                }
            }
        }
    }

    function OpenVSHMenuHUD(player, params)
    {
        MenuHUD.menu_index[player] <- MENU.MainMenu;
        EntFireByHandle(env_hudhint, "HideHudHint", "", 0, player, player);
        EntFireByHandle(env_hudhint_boss, "HideHudHint", "", 0, player, player);
        PlaySoundForPlayer(player, "ui/cyoa_map_open.wav");
        GenerateVSHMenuHUDText(player, params);

        if(!!CookieUtil.Get(player, "menu_music"))
        {
            local music = "ui/cyoa_music" + cyoaMusic[RandomInt(0, cyoaMusic.len() - 1)] + "_tv.mp3";
            PrecacheSound(music);
            EmitSoundEx(
            {
                sound_name = music
                channel = CHAN_MUSIC
                entity = player
                filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
            });
        }

        if(!player.IsAlive())
            player.SetOrigin(player.GetOrigin() + Vector(0,0,64))
    }

    function CloseVSHMenuHUD(player, params)
    {
        selected_option[player] = selected_mainmenu_option[player];

        delete MenuHUD.menu_index[player];

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
        {
            SetPropInt(player, "m_Local.m_iHideHUD", 0);
        }

        PrecacheSound("misc/null.wav");
        EmitSoundEx({
            sound_name = "misc/null.wav"
            channel = CHAN_MUSIC
            entity = player
            filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
        });
    }

    function UpdateVSHMenuHUD(player, params)
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
            local length = menus[MenuHUD.menu_index[player]].items.len() - 1;
            local new_loc = (selected_option[player]) + (player.WasButtonJustPressed(IN_FORWARD) ? -1 : 1);
            if (new_loc < 0)
            {
                new_loc = length;
            }
            else if (new_loc > length)
            {
                new_loc = 0;
            }

            selected_option[player] <- new_loc;

            if(MenuHUD.menu_index[player] == MENU.MainMenu)
                selected_mainmenu_option[player] <- new_loc;

            PlaySoundForPlayer(player, "ui/cyoa_node_absent.wav");
            GenerateVSHMenuHUDText(player, params);
        }

        // Select Menu Item
        if (player.WasButtonJustPressed(IN_ATTACK))
        {
            menus[MenuHUD.menu_index[player]].items[selected_option[player]].OnSelected(player);
            PlaySoundForPlayer(player, "ui/buttonclick.wav");
            GenerateVSHMenuHUDText(player, params);
        }

        // Return To Previous Menu
        if (player.WasButtonJustPressed(IN_ATTACK2))
        {
            GoUpVSHMenuDir(player, params);
        }

        player.AddFlag(FL_ATCONTROLS);
        SetPropFloat(player, "m_flNextAttack", 999999);
        HUD.Get(player, HUDID).overlay = API_GetString("ability_hud_folder") + "vshhud/vsh_menu_" + menus[MenuHUD.menu_index[player]].overlay;
        SetPropInt(player, "m_Local.m_iHideHUD", HIDEHUD_WEAPONSELECTION | HIDEHUD_HEALTH | HIDEHUD_MISCSTATUS | HIDEHUD_CROSSHAIR);
    }

    function GoUpVSHMenuDir(player, params, playsound = true)
    {
        if (MenuHUD.menu_index[player] != MENU.MainMenu)
        {
            if(menus[MenuHUD.menu_index[player]].parent_menuitem != null)
                selected_option[player] <- menus[MenuHUD.menu_index[player]].parent_menuitem;

            if(menus[MenuHUD.menu_index[player]].parent_menu != null)
                MenuHUD.menu_index[player] <- menus[MenuHUD.menu_index[player]].parent_menu;

            if(playsound)
                PlaySoundForPlayer(player, "ui/buttonclick.wav");

            GenerateVSHMenuHUDText(player, params);
        }
    }

    function GenerateVSHMenuHUDText(player, params)
    {
        local message = "\n\n\n\n\n";
        local menu_size = menus[MenuHUD.menu_index[player]].items.len();
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
                message += "\n";
                continue;
            }

            message += menus[MenuHUD.menu_index[player]].items[index].title;
            message += "\n";
        }

        local description = menus[MenuHUD.menu_index[player]].items[selected_option[player]].GenerateDesc(player);

        message += "\n" + description + "\n\n\n\n\n\n";
        params.message = message;
        params.scope.SetGameTextParams();
        params.scope.Display();
    }
}
::MenuHUD <- MenuHUD();

AddListener("chat", 0, function (player, message)
{
    MenuHUD.OnPlayerChat(player, message);
});

AddListener("tick_frame", 2, function ()
{
    MenuHUD.OnFrameTick();
});

::IsInVSHMenu <- function(player)
{
    return player in MenuHUD.menu_index;
}