menus[MENU.Stats] <- (class extends Menu
{
    items = {};
    overlay = "stats";
    parent_menu = MENU.MainMenu
    parent_menuitem = MAINMENU_ITEMS.Stats
})();

enum STATS_ITEMS {
    General
    Merc
    Boss
}

menus[MENU.Stats].items[STATS_ITEMS.General] <- (class extends MenuItem {
    title = "General"

    function GenerateDesc(player)
    {
        return "\nView General stats like playtime, total damage, etc.\n";
    }

    function OnSelected(player)
    {
        return;
        menu_index[player] <- MENU.StatsGeneral;
        selected_option[player] <- 0;
    }
})();

menus[MENU.Stats].items[STATS_ITEMS.Merc] <- (class extends MenuItem {
    title = "Mercenary"

    function GenerateDesc(player)
    {
        return "\nView stats for specific mercenaries.\n";
    }

    function OnSelected(player)
    {
        menu_index[player] <- MENU.StatsMerc;
        selected_option[player] <- 0;
    }
})();

menus[MENU.Stats].items[STATS_ITEMS.Boss] <- (class extends MenuItem {
    title = "Bosses"

    function GenerateDesc(player)
    {
        return "\nView stats for specific bosses.\n";
    }

    function OnSelected(player)
    {
        return;
        menu_index[player] <- MENU.StatsBoss;
        selected_option[player] <- 0;
    }
})();