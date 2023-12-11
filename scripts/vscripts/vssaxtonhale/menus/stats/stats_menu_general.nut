menus[MENU.StatsGeneral] <- class extends Menu
{
    items = {}
    overlay = "stats_general"
    parent_menu = MENU.Stats
    parent_menuitem = STATS_ITEMS.General
}();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Merc Time Alive"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've been alive for\na total of " + FormatTime(CookieUtil.Get(player, "total_lifetime")) + "\n";
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Merc Damage"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've dealt a total\nof " + AddCommaSeperator(CookieUtil.Get(player, "total_damage")) + " damage to the boss.\n";
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Merc Healing"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've healed your\nteam for a total of " + AddCommaSeperator(CookieUtil.Get(player, "total_healing")) + " health.\n";
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Merc Boss Killing Blows"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've dealt a killing\nblow on the boss " + AddCommaSeperator(CookieUtil.Get(player, "total_bosskills")) + " times.\n";
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Merc Boss Stomps"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've stomped the\nboss a total of " + AddCommaSeperator(CookieUtil.Get(player, "total_bossgoomba")) + " times.\n";
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Merc Wall Climbs"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've performed a\nwall climb a total of " + AddCommaSeperator(CookieUtil.Get(player, "total_wallclimbs")) + " times.\n";
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Boss Time Alive"

    function GenerateDesc(player)
    {
        return "As a Boss, you've been alive for\na total of " + FormatTime(CookieUtil.Get(player, "total_bosslifetime")) + "\n";
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Boss Victories"

    function GenerateDesc(player)
    {
        local message = "Boss Victories\n";
        message += "Easy " + AddCommaSeperator(CookieUtil.Get(player, "total_victory_easy"));
        message += " | Normal " + AddCommaSeperator(CookieUtil.Get(player, "total_victory_normal"));
        message += " | Hard " + AddCommaSeperator(CookieUtil.Get(player, "total_victory_hard") + "\n");
        message += "Extreme " + AddCommaSeperator(CookieUtil.Get(player, "total_victory_extreme"));
        message += " | Impossible " + AddCommaSeperator(CookieUtil.Get(player, "total_victory_impossible"));
        return message;
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Merc Kills"

    function GenerateDesc(player)
    {
        return "As a Boss, you've killed \na total of " + AddCommaSeperator(CookieUtil.Get(player, "total_merckills")) + " mercenaries.\n";
    }
})();

menus[MENU.StatsGeneral].items[menus[MENU.StatsGeneral].items.len()] <- (class extends MenuItem {
    title = "Merc Head Stomps"

    function GenerateDesc(player)
    {
        return "As a Boss, you've killed \na total of " + AddCommaSeperator(CookieUtil.Get(player, "total_merckills")) + " mercenaries with a head stomp.\n";
    }
})();