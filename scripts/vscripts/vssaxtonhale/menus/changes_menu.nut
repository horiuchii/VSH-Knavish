menus[MENU.Changes] <- class extends Menu
{
    items = {}
    overlay = "changes"
    parent_menu = MENU.MainMenu
    parent_menuitem = MAINMENU_ITEMS.Changes
}();

::MercChangesMenus <-
[
    MENU.ChangesScout
    MENU.ChangesSoldier
    MENU.ChangesPyro
    MENU.ChangesDemo
    MENU.ChangesHeavy
    MENU.ChangesEngi
    MENU.ChangesMedic
    MENU.ChangesSniper
    MENU.ChangesSpy
];

::WeaponInfoMenuItem <- class extends MenuItem
{
    title = null
    desc = null

    function GenerateDesc(player)
    {
        return desc;
    }
}

::SpecialCases <- {
    ["flamethrower_generic"] =
    {
        name = "All Flamethrowers"
        desc = "-25% vertical airblast scale\n+25% damage bonus\n"
    },
    ["any_demo_boots"] =
    {
        name = "Any Boots"
        desc = "+10% faster move speed\n(no shield required)\n"
    },
    ["any_demo_shield"] =
    {
        name = "Any Shield"
        desc = "Blocks a single hit (can still charge)\n\n"
    },
    ["engie_generic"] =
    {
        name = "Engineer Changes"
        desc = "Buildings construct 15% faster\n\n"
    },
    ["medic_generic"] =
    {
        name = "Medic Changes"
        desc = "Takes full punch damage\n+100% Übercharge rate\n"
    },
    ["sniper_generic"] =
    {
        name = "Sniper Changes"
        desc = "+25% Stronger Wallclimb\n\n"
    }
}

::ClassWeapons <- [
    ["force_a_nature", "shortstop", "baby_face_blaster", "backscatter", "crit_a_cola", "pbpp", "atomizer", "candy_cane", "sunonastick", "fan_o_war"],
    ["direct_hit", "rocket_jumper", "cowmangler", "airstrike", "base_jumper", "reserve_shooter", "equalizer", "market_gardener", "escape_plan", "half_zatoichi"],
    ["flamethrower_generic", "degreaser", "detonator", "manmelter", "reserve_shooter", "axtinguisher", "powerjack", "back_scratcher"],
    ["any_demo_boots", "base_jumper", "scottish_resistance", "any_demo_shield", "eyelander", "claidheamhmor", "half_zatoichi"],
    ["natascha", "kgb", "gru", "warriors_spirit"],
    ["engie_generic"],
    ["medic_generic", "syringegun", "blutsauger", "xbow", "overdose", "kritzkreig", "quick_fix", "vitasaw", "solemnvow"],
    ["sniper_generic", "hitmans_heatmaker", "classic", "smg", "razorback", "darwins_danger_shield", "cleaners_carbine", "bushwaka"],
    ["ambassador", "letranger", "diamondback", "your_eternal_reward", "kunai", "big_earner", "cloak_and_dagger"]
]

foreach (i, value in MercChangesMenus)
{
    menus[MENU.Changes].items[i] <- class extends MenuItem
    {
        tfclass_id = i
        title = TFClassUtil.ProperNames[i]

        function GenerateDesc(player)
        {
            return "\nView all the changes made to " + title + ".\n";
        }

        function OnSelected(player)
        {
            menu_index[player] <- MercChangesMenus[tfclass_id];
            selected_option[player] <- 0;
        }
    }();

    menus[value] <- class extends Menu
    {
        items = {};
        overlay = "changes_" + TFClassUtil.CacheNames[i];
        parent_menu = MENU.Changes;
        parent_menuitem = i;
    }();

    foreach(weapon in ClassWeapons[i])
    {
        local insert_index = menus[value].items.len();
        menus[value].items[insert_index] <- WeaponInfoMenuItem();

        if(weapon in SpecialCases)
        {
            menus[value].items[insert_index].title = SpecialCases[weapon].name;
            menus[value].items[insert_index].desc = SpecialCases[weapon].desc;
        }
        else if(weapon in WeaponTable)
        {
            menus[value].items[insert_index].title = WeaponTable[weapon].name;
            menus[value].items[insert_index].desc = WeaponTable[weapon].desc;
        }
    }
}