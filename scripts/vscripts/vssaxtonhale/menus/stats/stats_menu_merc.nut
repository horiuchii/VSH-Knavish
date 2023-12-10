menus[MENU.StatsMerc] <- class extends Menu
{
    items = {}
    overlay = "stats_merc"
    parent_menu = MENU.Stats
    parent_menuitem = STATS_ITEMS.Merc
}();

::GeneralStatTemplates <-
{
    ["lifetime"] = class extends MenuItem
    {
        title = "Time Alive"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've been alive for\na total of " + FormatTime(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_lifetime")) + "\n";
        }
    },
    ["damage"] = class extends MenuItem
    {
        title = "Damage Dealt"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've dealt a total\nof " + AddCommasToNumber(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_damage")) + " damage to the boss.\n";
        }
    }
};

::SpecificTFClassStatTemplates <-
{
    ["backstabs"] = class extends MenuItem
    {
        title = "Backstabs"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've backstabbed the\nboss a total of " + AddCommasToNumber(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_backstabs")) + " times.\n";
        }
    },
    ["headshots"] = class extends MenuItem
    {
        title = "Headshots"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've headshot the\nboss a total of " + AddCommasToNumber(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_headshots")) + " times.\n";
        }
    },
    ["glowtime"] = class extends MenuItem
    {
        title = "Boss Glow Time"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've highlighted the\nboss for " + FormatTime(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_glowtime")) + "\n";
        }
    },
    ["moonshots"] = class extends MenuItem
    {
        title = "Moonshots"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've moon shot\nthe boss " + AddCommasToNumber(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_moonshots")) + " times.\n";
        }
    },
    ["healing"] = class extends MenuItem
    {
        title = "Healing Granted"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've healed your\nteam for a total of " + AddCommasToNumber(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_healing")) + " health.\n";
        }
    }
};

::MiscStatTemplates <-
{
    ["bosskills"] = class extends MenuItem
    {
        title = "Final Blows"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've dealt a killing\nblow on the boss " + AddCommasToNumber(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_bosskills")) + " times.\n";
        }
    },
    ["bossgoomba"] = class extends MenuItem
    {
        title = "Total Stomps"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've stomped the\nboss a total of " + AddCommasToNumber(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_bossgoomba")) + " times.\n";
        }
    },
    ["wallclimbs"] = class extends MenuItem
    {
        title = "Total Wall Climbs"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've performed a\nwall climb a total of " + AddCommasToNumber(CookieUtil.Get(player, TFClassUtil.ProperNames[tfclass_id] + "_wallclimbs")) + " times.\n";
        }
    }
};

::MercStatMenus <-
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

foreach (i, value in MercStatMenus)
{
    menus[MENU.StatsMerc].items[i] <- class extends MenuItem
    {
        tfclass_id = i
        title = TFClassUtil.ProperNames[i]

        function GenerateDesc(player)
        {
            return "\nView your stats for " + title + ".\n";
        }

        function OnSelected(player)
        {
            menu_index[player] <- MercStatMenus[tfclass_id];
            selected_option[player] <- 0;
        }
    }();

    menus[value] <- class extends Menu
    {
        items = {};
        overlay = "stats_merc_" + TFClassUtil.ProperNames[i];
        parent_menu = MENU.StatsMerc;
        parent_menuitem = i;
    }();

    foreach(stat in Cookies.GeneralStats)
    {
        local insert_index = menus[value].items.len();
        menus[value].items[insert_index] <- GeneralStatTemplates[stat]();
        menus[value].items[insert_index].tfclass_id = i;
    }

    foreach(stat in Cookies.SpecificTFClassStats[TFClassUtil.ProperNames[i]])
    {
        local insert_index = menus[value].items.len();
        menus[value].items[insert_index] <- SpecificTFClassStatTemplates[stat]();
        menus[value].items[insert_index].tfclass_id = i;
    }

    foreach(stat in Cookies.MiscStats)
    {
        local insert_index = menus[value].items.len();
        menus[value].items[insert_index] <- MiscStatTemplates[stat]();
        menus[value].items[insert_index].tfclass_id = i;
    }
}