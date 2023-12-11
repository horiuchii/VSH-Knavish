menus[MENU.StatsGeneral] <- class extends Menu
{
    items = {}
    overlay = "stats_general"
    parent_menu = MENU.Stats
    parent_menuitem = STATS_ITEMS.General
}();

enum STATSGENERAL_ITEMS {
    Playtime
    Damage
    Healing
    BossKills
    BossGoomba
    Wallclimbs
    BossPlaytime
    MercKills
}

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.Playtime] <- (class extends MenuItem {
    title = "Merc Time Alive"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've been alive for\na total of " + FormatTime(CookieUtil.Get(player, "total_lifetime")) + "\n";
    }
})();

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.Damage] <- (class extends MenuItem {
    title = "Merc Damage"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've dealt a total\nof " + AddCommasToNumber(CookieUtil.Get(player, "total_damage")) + " damage to the boss.\n";
    }
})();

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.Healing] <- (class extends MenuItem {
    title = "Merc Healing"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've healed your\nteam for a total of " + AddCommasToNumber(CookieUtil.Get(player, "total_healing")) + " health.\n";
    }
})();

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.BossKills] <- (class extends MenuItem {
    title = "Merc Boss Killing Blows"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've dealt a killing\nblow on the boss " + AddCommasToNumber(CookieUtil.Get(player, "total_bosskills")) + " times.\n";
    }
})();

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.BossGoomba] <- (class extends MenuItem {
    title = "Merc Boss Stomps"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've stomped the\nboss a total of " + AddCommasToNumber(CookieUtil.Get(player, "total_bossgoomba")) + " times.\n";
    }
})();

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.Wallclimbs] <- (class extends MenuItem {
    title = "Merc Wall Climbs"

    function GenerateDesc(player)
    {
        return "As a Mercenary, you've performed a\nwall climb a total of " + AddCommasToNumber(CookieUtil.Get(player, "total_wallclimbs")) + " times.\n";
    }
})();

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.BossPlaytime] <- (class extends MenuItem {
    title = "Boss Time Alive"

    function GenerateDesc(player)
    {
        return "As a Boss, you've been alive for\na total of " + FormatTime(CookieUtil.Get(player, "total_bosslifetime")) + "\n";
    }
})();

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.MercKills] <- (class extends MenuItem {
    title = "Merc Kills"

    function GenerateDesc(player)
    {
        return "As a Boss, you've killed \na total of " + AddCommasToNumber(CookieUtil.Get(player, "total_merckills")) + " mercenaries.\n";
    }
})();

menus[MENU.StatsGeneral].items[STATSGENERAL_ITEMS.MercKills] <- (class extends MenuItem {
    title = "Merc Head Stomps"

    function GenerateDesc(player)
    {
        return "As a Boss, you've killed \na total of " + AddCommasToNumber(CookieUtil.Get(player, "total_merckills")) + " mercenaries with a head stomp.\n";
    }
})();