menus[MENU.StatsMerc] <- (class extends Menu
{
    items = {};
    overlay = "stats_merc";
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

enum STATSMERCSUBCLASS_ITEMS {
    AliveTime
    TotalDamage
    TotalHealing
    BossKills
    GoombaCount
    WallclimbCount
}

::some_arr <-
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

class Test extends MenuItem
{
    index = 0
}

foreach (i, value in some_arr)
{
    menus[MENU.StatsMerc].items[i] <- (class extends Test {
        title = TF_CLASS_NAMES_PROPER[i]

        function GenerateDesc(player)
        {
            return "\nView your stats for " + TF_CLASS_NAMES_PROPER[selected_option[player]] + ".\n";
        }

        function OnSelected(player)
        {
            menu_index[player] <- MENU.StatsMercScout + selected_option[player];
            selected_option[player] <- 0;
        }
    })();

    menus[value] <- (class extends Menu
    {
        items = {};
        overlay = "stats_merc_" + TF_CLASS_NAMES[i + 1];
        parent_menu = MENU.StatsMerc
        parent_menuitem = i
    })();

    menus[value].items[STATSMERCSUBCLASS_ITEMS.AliveTime] <- (class extends MenuItem {
        title = "Time Alive"

        function GenerateDesc(player)
        {
            return "\ntodo time alive\n";
        }
    })();
}