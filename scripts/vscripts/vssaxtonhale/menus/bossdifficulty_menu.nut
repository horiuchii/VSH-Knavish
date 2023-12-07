menus[MENU.BossDifficulty] <- (class extends Menu
{
    parent_menu = MENU.MainMenu
})();

enum BOSSDIFFICULTY_ITEMS {
    Easy
    Normal
    Hard
    Extreme
    Impossible
}

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
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Easy] <- (class extends MenuItem {
    title = "Easy"
    menu = MENU.BossDifficulty
    description = "+25% More Health\nNo Jump Cooldown\nRegular Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, -1);
    }
})();

//Boss Difficulty - Normal
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Normal] <- (class extends MenuItem {
    title = "Normal"
    menu = MENU.BossDifficulty
    description = "Standard Health\n2.5s Jump Cooldown\n-20% Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 0);
    }
})();

//Boss Difficulty - Hard
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Hard] <- (class extends MenuItem {
    title = "Hard"
    menu = MENU.BossDifficulty
    description = "-20% Less Health\n3s Jump Cooldown\n-40% Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 1);
    }
})();

//Boss Difficulty - Extreme
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Extreme] <- (class extends MenuItem {
    title = "Extreme"
    menu = MENU.BossDifficulty
    description = "-40% Less Health\n4s Jump Cooldown\n-60% Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 2);
    }
})();

//Boss Difficulty - Impossible
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Impossible] <- (class extends MenuItem {
    title = "Impossible"
    menu = MENU.BossDifficulty
    description = "-60% Less Health\nNo Double Jump\n-80% Slam Damage"

    function OnSelected(player)
    {
        SetBossDifficulty(player, 3);
    }
})();