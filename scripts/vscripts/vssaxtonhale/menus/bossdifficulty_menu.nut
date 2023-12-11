menus[MENU.BossDifficulty] <- class extends Menu
{
    items = {};
    overlay = "boss_difficulty";
    parent_menu = MENU.MainMenu
    parent_menuitem = MAINMENU_ITEMS.BossDifficulty
}();

enum BOSSDIFFICULTY_ITEMS
{
    Easy
    Normal
    Hard
    Extreme
    Impossible
}

::SetBossDifficulty <- function(player, difficulty)
{
    if(IsBoss(player) && !IsRoundSetup())
    {
        PrintToClient(player, KNA_VSH + "You can't change boss difficulty as a boss mid-round!");
        return;
    }

    local message = "Boss difficulty has been set to: " + DifficultyColor[difficulty];

    PrintToClient(player, KNA_VSH + message + DifficultyName[difficulty]);
    CookieUtil.Set(player, "difficulty", difficulty);
}

//Boss Difficulty - Easy
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Easy] <- class extends MenuItem {
    title = DifficultyName[DIFFICULTY.EASY]

    function GenerateDesc(player)
    {
        return "+25% More Health\nNo Jump Cooldown\nRegular Slam Damage";
    }

    function OnSelected(player)
    {
        SetBossDifficulty(player, DIFFICULTY.EASY);
    }
}();

//Boss Difficulty - Normal
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Normal] <- class extends MenuItem {
    title = DifficultyName[DIFFICULTY.NORMAL]

    function GenerateDesc(player)
    {
        return "Standard Health\n2.5s Jump Cooldown\n-20% Slam Damage";
    }

    function OnSelected(player)
    {
        SetBossDifficulty(player, DIFFICULTY.NORMAL);
    }
}();

//Boss Difficulty - Hard
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Hard] <- class extends MenuItem {
    title = DifficultyName[DIFFICULTY.HARD]

    function GenerateDesc(player)
    {
        return "-20% Less Health\n3s Jump Cooldown\n-40% Slam Damage";
    }

    function OnSelected(player)
    {
        SetBossDifficulty(player, DIFFICULTY.HARD);
    }
}();

//Boss Difficulty - Extreme
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Extreme] <- class extends MenuItem {
    title = DifficultyName[DIFFICULTY.EXTREME]

    function GenerateDesc(player)
    {
        return "-40% Less Health\n4s Jump Cooldown\n-60% Slam Damage";
    }

    function OnSelected(player)
    {
        SetBossDifficulty(player, DIFFICULTY.EXTREME);
    }
}();

//Boss Difficulty - Impossible
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Impossible] <- class extends MenuItem {
    title = DifficultyName[DIFFICULTY.IMPOSSIBLE]

    function GenerateDesc(player)
    {
        return "-60% Less Health\nNo Double Jump\n-80% Slam Damage";
    }

    function OnSelected(player)
    {
        SetBossDifficulty(player, DIFFICULTY.IMPOSSIBLE);
    }
}();