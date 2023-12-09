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

::specificstat_classes <- {
    ["backstabs"] = (class extends MenuItem
    {
        title = "Boss Backstabs"
        class_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've backstabbed the\nboss a total of " + AddCommasToNumber(Cookies.Get(player, TFClass.names_proper[class_id] + "_backstabs")) + " times.\n";
        }
    }),
    ["headshots"] = (class extends MenuItem
    {
        title = "Boss Headshots"
        class_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've headshot the\nboss a total of " + AddCommasToNumber(Cookies.Get(player, TFClass.names_proper[class_id] + "_headshots")) + " times.\n";
        }
    }),
    ["glowtime"] = (class extends MenuItem
    {
        title = "Time Outlined Boss"
        class_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've highlighted the\nboss for " + FormatTime(Cookies.Get(player, TFClass.names_proper[class_id] + "_glowtime")) + "\n";
        }
    }),
    ["moonshots"] = (class extends MenuItem
    {
        title = "Boss Moonshots"
        class_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've moon shot\nthe boss " + AddCommasToNumber(Cookies.Get(player, TFClass.names_proper[class_id] + "_moonshots")) + " times.\n";
        }
    }),
    ["healing"] = (class extends MenuItem
    {
        title = "Healing Granted"
        class_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've healed your\nteam for a total of " + AddCommasToNumber(Cookies.Get(player, TFClass.names_proper[class_id] + "_healing")) + " health.\n";
        }
    })
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

foreach (i, value in merc_stats_enum)
{
    menus[MENU.StatsMerc].items[i] <- (class extends MenuItem
    {
        class_id = i
        title = TFClass.names_proper[i]

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
        overlay = "stats_merc_" + TFClass.names_proper[i];
        parent_menu = MENU.StatsMerc;
        parent_menuitem = i;
    })();

    menus[value].items[menus[value].items.len()] <- (class extends MenuItem
    {
        title = "Time Alive"
        class_id = i

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've been alive for\na total of " + FormatTime(Cookies.Get(player, TFClass.names_proper[class_id] + "_lifetime")) + "\n";
        }
    })();

    menus[value].items[menus[value].items.len()] <- (class extends MenuItem
    {
        title = "Damage Dealt"
        class_id = i

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've dealt a total\nof " + AddCommasToNumber(Cookies.Get(player, TFClass.names_proper[class_id] + "_damage")) + " damage to the boss.\n";
        }
    })();

    //add class specific stats here
    foreach(cookie in specificclass_stats[TFClass.names_proper[i]])
    {
        local insert_index = menus[value].items.len();
        menus[value].items[insert_index] <- specificstat_classes[cookie]();
        menus[value].items[insert_index].class_id = i;
    }

    menus[value].items[menus[value].items.len()] <- (class extends MenuItem
    {
        title = "Boss Killing Blows"
        class_id = i

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've dealt a killing\nblow on the boss " + AddCommasToNumber(Cookies.Get(player, TFClass.names_proper[class_id] + "_bosskills")) + " times.\n";
        }
    })();

    menus[value].items[menus[value].items.len()] <- (class extends MenuItem
    {
        title = "Total Boss Stomps"
        class_id = i

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've stomped the\nboss a total of " + AddCommasToNumber(Cookies.Get(player, TFClass.names_proper[class_id] + "_bossgoomba")) + " times.\n";
        }
    })();

    menus[value].items[menus[value].items.len()] <- (class extends MenuItem
    {
        title = "Total Wall Climbs"
        class_id = i

        function GenerateDesc(player)
        {
            return "As " + TFClass.names_proper[class_id] + ", you've performed a\nwall climb a total of " + AddCommasToNumber(Cookies.Get(player, TFClass.names_proper[class_id] + "_wallclimbs")) + " times.\n";
        }
    })();
}