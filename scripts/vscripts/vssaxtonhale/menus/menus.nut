::menus <- {}

enum MENU {
    MainMenu
    Settings
    BossDifficulty
    BossSelect
    Changes
    ChangesScout
    ChangesSoldier
    ChangesPyro
    ChangesDemo
    ChangesHeavy
    ChangesEngi
    ChangesMedic
    ChangesSniper
    ChangesSpy
    Stats
    StatsGeneral
    StatsMerc
    StatsMercScout
    StatsMercSoldier
    StatsMercPyro
    StatsMercDemo
    StatsMercHeavy
    StatsMercEngi
    StatsMercMedic
    StatsMercSniper
    StatsMercSpy
    StatsBoss
}

class Menu
{
    items = {}
    parent_menu = null
    parent_menuitem = null
}

class MenuItem
{
    title = ""
    overlay = ""

    function GenerateDesc(player){}

    function OnSelected(player){}
}

Include("/menus/main_menu.nut");

Include("/menus/settings_menu.nut");
Include("/menus/bossdifficulty_menu.nut");
Include("/menus/boss_select_menu.nut");

Include("/menus/changes_menu.nut");

Include("/menus/stats/stats_menu.nut");
Include("/menus/stats/stats_menu_general.nut");
Include("/menus/stats/stats_menu_merc.nut");
Include("/menus/stats/stats_menu_boss.nut");