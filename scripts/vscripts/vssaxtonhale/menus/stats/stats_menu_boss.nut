menus[MENU.StatsBoss] <- class extends Menu
{
    items = {}
    overlay = "stats_boss"
    parent_menu = MENU.Stats
    parent_menuitem = STATS_ITEMS.Boss
}();

::GeneralBossStatTemplates <-
{
    ["bosslifetime"] = class extends MenuItem
    {
        title = "Time Alive"
        boss_id = null

        function GenerateDesc(player)
        {
            return "As " + bossLibrary[boss_id].name_proper + ", you've been alive for\na total of " + FormatTime(CookieUtil.Get(player, boss_id + "_bosslifetime")) + "\n";
        }
    },
    ["merckills"] = class extends MenuItem
    {
        title = "Merc Kills"
        boss_id = null

        function GenerateDesc(player)
        {
            return "As " + bossLibrary[boss_id].name_proper + ", you've killed a total\nof " + AddCommasToNumber(CookieUtil.Get(player, boss_id + "_merckills")) + " mercenaries.\n";
        }
    },
    ["headstomps"] = class extends MenuItem
    {
        title = "Head Stomp Kills"
        boss_id = null

        function GenerateDesc(player)
        {
            return "As " + bossLibrary[boss_id].name_proper + ", you've killed a total\nof " + AddCommasToNumber(CookieUtil.Get(player, boss_id + "_headstomps")) + " mercenaries with a head stomp.\n";
        }
    }
};

::SpecificBossStatTemplates <-
{
    ["slamkills"] = class extends MenuItem
    {
        title = "Slam Kills"
        boss_id = null

        function GenerateDesc(player)
        {
            return "As " + bossLibrary[boss_id].name_proper + ", you've killed a total\nof " + AddCommasToNumber(CookieUtil.Get(player, boss_id + "_slamkills")) + " mercenaries with slam.\n";
        }
    },
    ["chargekills"] = class extends MenuItem
    {
        title = "Charge Kills"
        boss_id = null

        function GenerateDesc(player)
        {
            return "As " + bossLibrary[boss_id].name_proper + ", you've killed a total\nof " + AddCommasToNumber(CookieUtil.Get(player, boss_id + "_chargekills")) + " mercenaries with sweeping charge.\n";
        }
    },
    ["bravejumpcount"] = class extends MenuItem
    {
        title = "Brave Jumps"
        boss_id = null

        function GenerateDesc(player)
        {
            return "As " + bossLibrary[boss_id].name_proper + ", you've brave jumped\na total of " + AddCommasToNumber(CookieUtil.Get(player, boss_id + "_bravejumpcount")) + " times.\n";
        }
    }
};

::BossStatMenus <-
{
    ["saxton_hale"] = MENU.StatsBossSaxton
}

foreach (i, value in BossStatMenus)
{
    local boss_menu_pos = menus[MENU.StatsBoss].items.len();

    menus[MENU.StatsBoss].items[boss_menu_pos] <- class extends MenuItem
    {
        boss_id = i
        title = bossLibrary[i].name_proper

        function GenerateDesc(player)
        {
            return "\nView your stats for " + title + ".\n";
        }

        function OnSelected(player)
        {
            menu_index[player] <- BossStatMenus[boss_id];
            selected_option[player] <- 0;
        }
    }();

    menus[value] <- class extends Menu
    {
        items = {};
        overlay = "stats_boss_" + i;
        parent_menu = MENU.StatsBoss;
        parent_menuitem = boss_menu_pos;
    }();

    foreach(stat in Cookies.BossStats)
    {
        local insert_index = menus[value].items.len();
        menus[value].items[insert_index] <- GeneralBossStatTemplates[stat]();
        menus[value].items[insert_index].boss_id = i;
    }

    foreach(stat in Cookies.SpecificBossStats[i])
    {
        local insert_index = menus[value].items.len();
        menus[value].items[insert_index] <- SpecificBossStatTemplates[stat]();
        menus[value].items[insert_index].boss_id = i;
    }
}