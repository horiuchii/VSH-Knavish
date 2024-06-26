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
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've been alive for\na total of " + FormatTime(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_lifetime")) + "\n";
        }
    },
    ["damage"] = class extends MenuItem
    {
        title = "Damage Dealt"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've dealt a total\nof " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_damage")) + " damage to the boss.\n";
        }
    }
};

::SpecificTFClassStatTemplates <-
{
    ["sentrydamage"] = class extends MenuItem
    {
        title = "Sentry Damage"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've dealt a total\nof " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_sentrydamage")) + " damage to the boss with a sentry gun.\n";
        }
    },
    ["backstabs"] = class extends MenuItem
    {
        title = "Backstabs"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've backstabbed the\nboss a total of " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_backstabs")) + " times.\n";
        }
    },
    ["headshots"] = class extends MenuItem
    {
        title = "Headshots"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've headshot the\nboss a total of " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_headshots")) + " times.\n";
        }
    },
    ["glowtime"] = class extends MenuItem
    {
        title = "Boss Glow Time"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've highlighted the\nboss for " + FormatTime(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_glowtime")) + "\n";
        }
    },
    ["moonshots"] = class extends MenuItem
    {
        title = "Moonshots"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've moon shot\nthe boss " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_moonshots")) + " times.\n";
        }
    },
    ["airblast"] = class extends MenuItem
    {
        title = "Airblasts"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've airblasted\nthe boss " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_airblast")) + " times.\n";
        }
    },
    ["healing"] = class extends MenuItem
    {
        title = "Healing Granted"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've healed your\nteam for a total of " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_healing")) + " health.\n";
        }
    },
    ["ubers_stock"] = class extends MenuItem
    {
        title = "Stock Übers Popped"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've popped a total\nof " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_ubers_stock")) + " Übercharges.\n";
        }
    },
    ["ubers_kritz"] = class extends MenuItem
    {
        title = "Kritz Übers Popped"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've popped a total\nof " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_ubers_kritz")) + " Kritzkrieg Übercharges.\n";
        }
    },
    ["ubers_quickfix"] = class extends MenuItem
    {
        title = "Quick-Fix Übers Popped"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've popped a total\nof " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_ubers_quickfix")) + " Quick-Fix Übercharges.\n";
        }
    },
    ["ubers_vacc"] = class extends MenuItem
    {
        title = "Vaccinator Übers Popped"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've popped a total\nof " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_ubers_vacc")) + " Vaccinator Übercharges.\n";
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
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've dealt a killing\nblow on the boss " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_bosskills")) + " times.\n";
        }
    },
    ["bossgoomba"] = class extends MenuItem
    {
        title = "Total Stomps"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've stomped the\nboss a total of " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_bossgoomba")) + " times.\n";
        }
    },
    ["wallclimbs"] = class extends MenuItem
    {
        title = "Total Wall Climbs"
        tfclass_id = null

        function GenerateDesc(player)
        {
            return "As " + TFClassUtil.ProperNames[tfclass_id] + ", you've performed a\nwall climb a total of " + AddCommaSeperator(CookieUtil.Get(player, TFClassUtil.CacheNames[tfclass_id] + "_wallclimbs")) + " times.\n";
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
            MenuHUD.menu_index[player] <- MercStatMenus[tfclass_id];
            MenuHUD.selected_option[player] <- 0;
        }
    }();

    menus[value] <- class extends Menu
    {
        items = {};
        overlay = "stats_merc_" + TFClassUtil.CacheNames[i];
        parent_menu = MENU.StatsMerc;
        parent_menuitem = i;
    }();

    foreach(stat in Cookies.GeneralStats)
    {
        local insert_index = menus[value].items.len();
        menus[value].items[insert_index] <- GeneralStatTemplates[stat]();
        menus[value].items[insert_index].tfclass_id = i;
    }

    foreach(stat in Cookies.SpecificTFClassStats[TFClassUtil.CacheNames[i]])
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