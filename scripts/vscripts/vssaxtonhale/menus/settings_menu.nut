menus[MENU.Settings] <- class extends Menu
{
    items = {};
    overlay = "settings";
    parent_menu = MENU.MainMenu
    parent_menuitem = MAINMENU_ITEMS.Settings
}();

enum SETTINGS_ITEMS
{
    BecomeBoss
    BossDifficulty
    BossChoose
    MercVO
    PDAMusic
}

//Open Difficulty Menu
menus[MENU.Settings].items[SETTINGS_ITEMS.BossDifficulty] <- class extends MenuItem
{
    title = "Set Boss Difficulty"

    function GenerateDesc(player)
    {
        local option_setting = DifficultyName[CookieUtil.Get(player, "difficulty")];
        return "[" + option_setting + "]\nSet the difficulty for a more\nengaging experience as the boss.";
    }

    function OnSelected(player)
    {
        menu_index[player] <- MENU.BossDifficulty;
        selected_option[player] <- CookieUtil.Get(player, "difficulty");
    }
}();

//Open Boss Menu
menus[MENU.Settings].items[SETTINGS_ITEMS.BossChoose] <- class extends MenuItem
{
    title = "Set Preferred Boss"

    function GenerateDesc(player)
    {
        return "[" + bossLibrary[CookieUtil.Get(player, "boss")].name_proper + "]\nChoose who you would like to play as when\nchosen as the boss. (More coming soon)";
    }

    function OnSelected(player)
    {
        PrintToClient(player, KNA_VSH + "Coming Soon!");
    }
}();

//Toggle Boss
menus[MENU.Settings].items[SETTINGS_ITEMS.BecomeBoss] <- class extends MenuItem
{
    title = "Toggle Become Boss"

    function GenerateDesc(player)
    {
        return CookieUtil.MakeGenericCookieString(player, "become_boss") + "Toggle the ability to gain queue points.\nTurning off will remove any existing points.";
    }

    function OnSelected(player)
    {
        local can_be_boss = CookieUtil.Set(player, "become_boss", !!!CookieUtil.Get(player, "become_boss").tointeger());
        local message = "";

        if(can_be_boss)
            message = "You can now be the boss."
        else
            message = "You can no longer be the boss. Queue points have been reset."

        PrintToClient(player, KNA_VSH + message);
    }
}();

//Toggle Custom Merc VO
menus[MENU.Settings].items[SETTINGS_ITEMS.MercVO] <- class extends MenuItem {
    title = "Toggle Merc Voicelines"

    function GenerateDesc(player)
    {
        return CookieUtil.MakeGenericCookieString(player, "custom_vo") + "Toggle hearing merc voicelines by James McGuinn.\nWill not prevent others from hearing yours."
    }

    function OnSelected(player)
    {
        local can_hear_vo = CookieUtil.Set(player, "custom_vo", !!!CookieUtil.Get(player, "custom_vo").tointeger());
        local message = "";

        if(can_hear_vo)
            message = "You can now hear James McGuinn merc VO."
        else
            message = "You can no longer hear James McGuinn merc VO."

        PrintToClient(player, KNA_VSH + message);
    }
}();

//Toggle PDA Music
menus[MENU.Settings].items[SETTINGS_ITEMS.PDAMusic] <- class extends MenuItem
{
    title = "Toggle PDA Music"

    function GenerateDesc(player)
    {
        return CookieUtil.MakeGenericCookieString(player, "menu_music") + "Toggle music playing in the VSH Menu.\n";
    }

    function OnSelected(player)
    {
        local is_music_on = CookieUtil.Set(player, "menu_music", !!!CookieUtil.Get(player, "menu_music").tointeger());
        local message = "";

        if(is_music_on)
        {
            message = "Turned menu music on.";
            local music = "ui/cyoa_music" + cyoaMusic[RandomInt(0, cyoaMusic.len() - 1)] + "_tv.mp3";
            PrecacheSound(music);
            EmitSoundEx({
                sound_name = music
                channel = -1
                entity = player
                filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
            });
        }
        else
        {
            message = "Turned menu music off.";
            PrecacheSound("misc/null.wav")
            EmitSoundEx({
                sound_name = "misc/null.wav"
                channel = -1
                entity = player
                filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
            })
        }

        PrintToClient(player, KNA_VSH + message);
    }
}();