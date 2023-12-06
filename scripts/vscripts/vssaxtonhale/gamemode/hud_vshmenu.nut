::MenuItems <- {}

::menu_options <- {}

enum MENU {
    Main
    BossDifficulty
    Stats
}

class MenuItem
{
    title = ""
    menu = MENU.Main
    pref = null
    description = ""

    function constructor()
    {
        if(!(menu in menu_options))
            menu_options[menu] <- []

        menu_options[menu].push(this);
    }

    function OnSelected(player)
    {
    }
}

enum MENU_ITEMS {
    BecomeBoss
    ResetQueue
    BossDifficulty
    BossChoose
    MercVO
    Stats
    Achievement
    Cosmetic

    Easy
    Normal
    Hard
    Extreme
    Impossible
}

//Toggle Boss
MenuItems[MENU_ITEMS.BecomeBoss] <- (class extends MenuItem {
    title = "Toggle Become Boss"
    pref = "become_boss"
    description = "Toggle the ability to gain queue points.\nTurning off will remove any existing points."

    function OnSelected(player)
    {
        local can_be_boss = Cookies.Set(player, "become_boss", !!!Cookies.Get(player, "become_boss").tointeger());
        local message = "";

        if(can_be_boss)
            message = "You can now be the boss."
        else
            message = "You can no longer be the boss. Queue points have been reset."

        PrintToClient(player, KNA_VSH + message);
    }
})();

//Reset Queue
MenuItems[MENU_ITEMS.ResetQueue] <- (class extends MenuItem {
    title = "Reset Queue Points"
    description = "\nResets your position in\nthe queue to become boss."

    function OnSelected(player)
    {
        if(IsBoss(player))
        {
            PrintToClient(player, KNA_VSH + "You can't reset your queue points as a boss!");
            return;
        }

        ResetQueuePoints(player);
        PrintToClient(player, KNA_VSH + "Your queue points have been reset.");
    }
})();

//Open Difficulty Menu
MenuItems[MENU_ITEMS.BossDifficulty] <- (class extends MenuItem {
    title = "Set Boss Difficulty"
    pref = "difficulty"
    description = "Set the difficulty for a more\nengaging experience as the boss."

    function OnSelected(player)
    {
        menu_index[player] <- MENU.BossDifficulty;
        selected_option[player] <- Cookies.Get(player, "difficulty") + 1;
    }
})();

//Open Boss Menu
MenuItems[MENU_ITEMS.BossChoose] <- (class extends MenuItem {
    title = "Set Preferred Boss"
    pref = "boss"
    description = "Choose who you would like to play as when\nchosen as the boss. (More coming soon)"

    function OnSelected(player)
    {
        PrintToClient(player, KNA_VSH + "Coming Soon!");
    }
})();

//Toggle Merc VO
/*
MenuItems[MENU_ITEMS.MercVO] <- (class extends MenuItem {
    title = "Toggle Merc Voicelines"
    pref = "custom_vo"
    description = "Toggle hearing merc voicelines by James McGuinn.\nWill not prevent others from hearing yours."

    function OnSelected(player)
    {
        local can_hear_vo = Cookies.Set(player, "custom_vo", !!!Cookies.Get(player, "custom_vo").tointeger());
        local message = "";

        if(can_hear_vo)
            message = "You can now hear James McGuinn merc VO."
        else
            message = "You can no longer hear James McGuinn merc VO."

        PrintToClient(player, KNA_VSH + message);
    }
})();
*/

//View VSH Stats
MenuItems[MENU_ITEMS.Stats] <- (class extends MenuItem {
    title = "View Performance Report"
    description = "\nView your lifetime Boss and Mercenary stats.\n"

    function OnSelected(player)
    {
        PrintToClient(player, VSH_MESSAGE_PREFIX + "Coming Soon!");
        return;
        menu_index[player] <- MENU.Stats;
        selected_option[player] <- 0;
    }
})();

//View VSH Achievements
MenuItems[MENU_ITEMS.Achievement] <- (class extends MenuItem {
    title = "View Achievements"
    description = "\nComing Soon!\n"

    function OnSelected(player)
    {
        PrintToClient(player, VSH_MESSAGE_PREFIX + "Coming Soon!");
        return;
    }
})();

//Equip Boss Cosmetics
/*
MenuItems[MENU_ITEMS.Cosmetic] <- (class extends MenuItem {
    title = "Equip Boss Cosmetics"
    description = "\nChoose which cosmetic trail you would\nlike have equipped on your boss."

    function OnSelected(player)
    {
        PrintToClient(player, VSH_MESSAGE_PREFIX + "Coming Soon!");
    }
})();
*/

function SetBossDifficulty(player, difficulty)
{
    if(IsBoss(player) && !IsRoundSetup())
    {
        PrintToClient(player, KNA_VSH + "You can't change boss difficulty as a boss mid-round!");
        return;
    }

    local message = "Boss difficulty has been set to: ";

    switch(difficulty)
    {
        case -1: message += "\x075885A2" + "Easy"; break;
        case 0: message += "\x07729E42" + "Normal"; break;
        case 1: message += "\x07B8383B" + "Hard"; break;
        case 2: message += "\x07B71111" + "Extreme"; break;
        case 3: message += "\x077D4071" + "Impossible"; break;
    }

    PrintToClient(player, KNA_VSH + message);
    Cookies.Set(player, "difficulty", difficulty);
    menu_index[player] <- MENU.Main;
    selected_option[player] <- 2;
}

//Boss Difficulty - Easy
MenuItems[MENU_ITEMS.Easy] <- (class extends MenuItem {
    title = "Easy"
    menu = MENU.BossDifficulty
    description = "+25% More Health\nNo Jump Cooldown\nRegular Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, -1);
    }
})();

//Boss Difficulty - Normal
MenuItems[MENU_ITEMS.Normal] <- (class extends MenuItem {
    title = "Normal"
    menu = MENU.BossDifficulty
    description = "Standard Health\n2.5s Jump Cooldown\n-20% Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 0);
    }
})();

//Boss Difficulty - Hard
MenuItems[MENU_ITEMS.Hard] <- (class extends MenuItem {
    title = "Hard"
    menu = MENU.BossDifficulty
    description = "-20% Less Health\n3s Jump Cooldown\n-40% Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 1);
    }
})();

//Boss Difficulty - Extreme
MenuItems[MENU_ITEMS.Extreme] <- (class extends MenuItem {
    title = "Extreme"
    menu = MENU.BossDifficulty
    description = "-40% Less Health\n4s Jump Cooldown\n-60% Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 2);
    }
})();

//Boss Difficulty - Impossible
MenuItems[MENU_ITEMS.Impossible] <- (class extends MenuItem {
    title = "Impossible"
    menu = MENU.BossDifficulty
    description = "-60% Less Health\nNo Double Jump\n-80% Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 3);
    }
})();