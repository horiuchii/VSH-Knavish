menus[MENU.MainMenu] <- class extends Menu
{
    items = {};
    overlay = "main_menu";
}();

enum MAINMENU_ITEMS
{
    BecomeBoss
    ResetQueue
    BossDifficulty
    BossChoose
    Stats
    Achievement
}

//Toggle Boss
menus[MENU.MainMenu].items[MAINMENU_ITEMS.BecomeBoss] <- class extends MenuItem
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

//Reset Queue
menus[MENU.MainMenu].items[MAINMENU_ITEMS.ResetQueue] <- class extends MenuItem
{
    title = "Reset Queue Points"

    function GenerateDesc(player)
    {
        return "\nResets your position in\nthe queue to become boss.";
    }

    function OnSelected(player)
    {
        if(IsBoss(player))
        {
            PrintToClient(player, KNA_VSH + "You can't reset your queue points as a boss!");
            return;
        }

        ResetQueuePoints(player);
        PrintToClient(player, KNA_VSH + "Your queue points have been reset.");
    }
}();

//Open Difficulty Menu
menus[MENU.MainMenu].items[MAINMENU_ITEMS.BossDifficulty] <- class extends MenuItem
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
menus[MENU.MainMenu].items[MAINMENU_ITEMS.BossChoose] <- class extends MenuItem
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

//View VSH Stats
menus[MENU.MainMenu].items[MAINMENU_ITEMS.Stats] <- class extends MenuItem
{
    title = "View Performance Report"

    function GenerateDesc(player)
    {
        return "\nView your lifetime Boss and Mercenary stats.\n";
    }

    function OnSelected(player)
    {
        menu_index[player] <- MENU.Stats;
        selected_option[player] <- 0;
    }
}();

//View VSH Achievements
menus[MENU.MainMenu].items[MAINMENU_ITEMS.Achievement] <- class extends MenuItem
{
    title = "View Achievements"

    function GenerateDesc(player)
    {
        return "\nComing Soon!\n";
    }

    function OnSelected(player)
    {
        PrintToClient(player, KNA_VSH + "Coming Soon!");
    }
}();