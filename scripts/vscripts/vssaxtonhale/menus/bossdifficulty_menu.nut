menus[MENU.BossDifficulty] <- class extends Menu
{
    items = {};
    overlay = "boss_difficulty";
    parent_menu = MENU.Settings
    parent_menuitem = SETTINGS_ITEMS.BossDifficulty
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

    local message = "Boss difficulty has been set to: \x07" + DifficultyColor[difficulty];

    PrintToClient(player, KNA_VSH + message + DifficultyName[difficulty]);
    CookieUtil.Set(player, "difficulty", difficulty);
}

//Boss Difficulty - Easy
menus[MENU.BossDifficulty].items[BOSSDIFFICULTY_ITEMS.Easy] <- class extends MenuItem {
    title = DifficultyName[DIFFICULTY.EASY]

    function GenerateDesc(player)
    {
        return title + " Modifiers\nHealth (+20%) | Jump Cooldown (0s)\n";
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
        return title + " Modifiers\nJump Cooldown (2.5s) | Slam Damage (-20%)\n";
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
        return title + " Modifiers\nHealth (-20%) | Jump Cooldown (3s)\nSlam Damage (-40%)";
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
        return title + " Modifiers\nHealth (-40%) | Jump Cooldown (4s)\nSlam Damage (-60%)";
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
        return title + " Modifiers\nHealth (-60%) | No Double Jump\nSlam Damage (-80%)";
    }

    function OnSelected(player)
    {
        SetBossDifficulty(player, DIFFICULTY.IMPOSSIBLE);
    }
}();