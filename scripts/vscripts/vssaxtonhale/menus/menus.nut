::menus <- {}

enum MENU {
    MainMenu
    BossDifficulty
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
    StatsBossSaxton
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
Include("/menus/bossdifficulty_menu.nut");
Include("/menus/stats/stats_menu.nut");
Include("/menus/stats/stats_menu_merc.nut");