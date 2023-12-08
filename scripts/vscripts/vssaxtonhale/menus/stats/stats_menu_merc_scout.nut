menus[MENU.StatsMercScout] <- (class extends Menu
{
    items = {};
    overlay = "stats_merc_scout";
    parent_menu = MENU.StatsMerc
    parent_menuitem = STATSMERC_ITEMS.Scout
})();

enum STATSMERCSCOUT_ITEMS {
    AliveTime
    TotalDamage
    TotalHealing
    BossKills
    GoombaCount
    WallclimbCount
}

menus[MENU.StatsMercScout].items[STATSMERCSCOUT_ITEMS.AliveTime] <- (class extends MenuItem {
    title = "Time Alive"

    function GenerateDesc(player)
    {
        return "\ntodo time alive\n";
    }
})();