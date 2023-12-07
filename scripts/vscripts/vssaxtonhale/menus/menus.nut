::menus <- []

enum MENU {
    MainMenu
    BossDifficulty
    Stats
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
    menu = MENU.MainMenu
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