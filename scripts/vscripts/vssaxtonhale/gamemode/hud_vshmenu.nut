::MenuItems <- {}

enum MENU {
    Main
    BossDifficulty
}

class MenuItem
{
    title = ""
    pref = null
    description = ""

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

    Easy
    Normal
    Hard
    Extreme
    Impossible
}

//Toggle Boss
MenuItems[MENU_ITEMS.BecomeBoss] <- (class extends MenuItem {
    title = "Toggle Become Boss"
    pref = COOKIE.BecomeBoss
    description = "Toggle the ability to gain queue points.\nTurning off will remove any existing points."

    function OnSelected(player)
    {
        local can_be_boss = Cookies.Set(player, COOKIE.BecomeBoss, !!!Cookies.Get(player, COOKIE.BecomeBoss).tointeger());
        local message = "";

        if(can_be_boss)
            message = "You can now be the boss."
        else
            message = "You can no longer be the boss. Queue points have been reset."

        PrintToClient(player, VSH_MESSAGE_PREFIX + message);
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
            PrintToClient(player, VSH_MESSAGE_PREFIX + "You can't reset your queue points as a boss!");
            return;
        }

        ResetQueuePoints(player);
        PrintToClient(player, VSH_MESSAGE_PREFIX + "Your queue points have been reset.");
    }
})();

//Open Difficulty Menu
MenuItems[MENU_ITEMS.BossDifficulty] <- (class extends MenuItem {
    title = "Set Boss Difficulty"
    pref = COOKIE.Difficulty
    description = "Set the difficulty for a more\nengaging experience as the boss."

    function OnSelected(player)
    {
        menu_index[player] <- MENU.BossDifficulty;
        selected_option[player] <- Cookies.Get(player, COOKIE.Difficulty) + 1;
    }
})();

//Open Boss Menu
MenuItems[MENU_ITEMS.BossChoose] <- (class extends MenuItem {
    title = "Set Preferred Boss"
    pref = COOKIE.Boss
    description = "Choose who you would like to play as when\nchosen as the boss. (More coming soon)"

    function OnSelected(player)
    {
        PrintToClient(player, VSH_MESSAGE_PREFIX + "Coming Soon!");
    }
})();

//Toggle Merc VO
MenuItems[MENU_ITEMS.MercVO] <- (class extends MenuItem {
    title = "Toggle Merc Voicelines"
    pref = COOKIE.CustomVO
    description = "Toggle hearing merc voicelines by James McGuinn.\nWill not prevent others from hearing yours."

    function OnSelected(player)
    {
        local can_hear_vo = Cookies.Set(player, COOKIE.CustomVO, !!!Cookies.Get(player, COOKIE.CustomVO).tointeger());
        local message = "";

        if(can_hear_vo)
            message = "You can now hear James McGuinn merc VO."
        else
            message = "You can no longer hear James McGuinn merc VO."

        PrintToClient(player, VSH_MESSAGE_PREFIX + message);
    }
})();

function SetBossDifficulty(player, difficulty)
{
    if(IsBoss(player) && !IsRoundSetup())
    {
        PrintToClient(player, VSH_MESSAGE_PREFIX + "You can't change boss difficulty as a boss mid-round!");
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

    PrintToClient(player, VSH_MESSAGE_PREFIX + message);
    Cookies.Set(player, COOKIE.Difficulty, difficulty);
    menu_index[player] <- MENU.Main;
    selected_option[player] <- 2;
}

//Boss Difficulty - Easy
MenuItems[MENU_ITEMS.Easy] <- (class extends MenuItem {
    title = "Easy"
    description = "+25% More Health\nNo Jump Cooldown\nRegular Slam Radius"

    function OnSelected(player)
    {
        SetBossDifficulty(player, -1);
    }
})();

//Boss Difficulty - Normal
MenuItems[MENU_ITEMS.Normal] <- (class extends MenuItem {
    title = "Normal"
    description = "Standard Health\n2s Jump Cooldown\n-20% Slam Radius"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 0);
    }
})();

//Boss Difficulty - Hard
MenuItems[MENU_ITEMS.Hard] <- (class extends MenuItem {
    title = "Hard"
    description = "-20% Less Health\n3s Jump Cooldown\n-40% Slam Radius"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 1);
    }
})();

//Boss Difficulty - Extreme
MenuItems[MENU_ITEMS.Extreme] <- (class extends MenuItem {
    title = "Extreme"
    description = "-40% Less Health\n4s Jump Cooldown\n-60% Slam Radius"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 2);
    }
})();

//Boss Difficulty - Impossible
MenuItems[MENU_ITEMS.Impossible] <- (class extends MenuItem {
    title = "Impossible"
    description = "-60% Less Health\nNo Double Jump\n-80% Slam Radius"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 3);
    }
})();

::menu_options <- [
    menu_0 <- [
        MenuItems[MENU_ITEMS.BecomeBoss]
        MenuItems[MENU_ITEMS.ResetQueue]
        MenuItems[MENU_ITEMS.BossDifficulty]
        MenuItems[MENU_ITEMS.BossChoose]
        MenuItems[MENU_ITEMS.MercVO]
    ]
    menu_1 <- [
        MenuItems[MENU_ITEMS.Easy]
        MenuItems[MENU_ITEMS.Normal]
        MenuItems[MENU_ITEMS.Hard]
        MenuItems[MENU_ITEMS.Extreme]
        MenuItems[MENU_ITEMS.Impossible]
    ]
]