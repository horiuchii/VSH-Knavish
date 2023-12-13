menus[MENU.MainMenu] <- class extends Menu
{
    items = {};
    overlay = "main_menu";
}();

enum MAINMENU_ITEMS
{
    ResetQueue
    Settings
    Stats
    Achievement
}

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

//View VSH Settings
menus[MENU.MainMenu].items[MAINMENU_ITEMS.Settings] <- class extends MenuItem
{
    title = "Toggle Settings"

    function GenerateDesc(player)
    {
        return "\nToggle various settings to fine tune your expierence.\n";
    }

    function OnSelected(player)
    {
        menu_index[player] <- MENU.Settings;
        selected_option[player] <- 0;
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