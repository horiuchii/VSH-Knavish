menus[MENU.StatsMerc] <- (class extends Menu
{
    items = {}
    overlay = "stats_merc"
    parent_menu = MENU.Stats
    parent_menuitem = STATS_ITEMS.Merc
})();

enum STATSMERC_ITEMS {
    Scout
    Soldier
    Pyro
    Demo
    Heavy
    Engi
    Medic
    Sniper
    Spy
}

enum MERCSTATS_STATITEMS {
    AliveTime
    TotalDamage
    TotalHealing
    BossKills
    GoombaCount
    WallclimbCount
}

::merc_stats_enum <-
[
    MENU.StatsMercScout
    MENU.StatsMercSoldier
    MENU.StatsMercPyro
    MENU.StatsMercDemo
    MENU.StatsMercHeavy
    MENU.StatsMercEngi
    MENU.StatsMercMedic
    MENU.StatsMercSniper
    MENU.StatsMercSpy
];

::TF_CLASS_NAMES_PROPER <- [
    "Scout"
    "Soldier"
    "Pyro"
    "Demoman"
    "Heavy"
    "Engineer"
    "Medic"
    "Sniper"
    "Spy"
]

foreach (i, value in merc_stats_enum)
{
    menus[MENU.StatsMerc].items[i] <- (class extends MenuItem
    {
        class_id = i
        title = TF_CLASS_NAMES_PROPER[i]

        function GenerateDesc(player)
        {
            return "\nView your stats for " + title + ".\n";
        }

        function OnSelected(player)
        {
            menu_index[player] <- merc_stats_enum[class_id];
            selected_option[player] <- 0;
        }
    })();

    menus[value] <- (class extends Menu
    {
        items = {};
        overlay = "stats_merc_" + TF_CLASS_NAMES[i + 1];
        parent_menu = MENU.StatsMerc;
        parent_menuitem = i;
    })();

    menus[value].items[MERCSTATS_STATITEMS.AliveTime] <- (class extends MenuItem
    {
        title = "Time Alive"

        function GenerateDesc(player)
        {
            return "\ntodo time alive\n";
        }
    })();
}