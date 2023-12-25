menus[MENU.BossSelect] <- class extends Menu
{
    items = {};
    overlay = "boss_selection";
    parent_menu = MENU.Settings
    parent_menuitem = SETTINGS_ITEMS.BossChoose
}();

foreach (i, name in bossList)
{
    menus[MENU.BossSelect].items[i] <- class extends MenuItem
    {
        boss_id = name
        title = bossLibrary[name].name_proper

        function GenerateDesc(player)
        {
            return "\n" + title + "\n";
        }

        function OnSelected(player)
        {
            if(IsBoss(player) && !IsRoundSetup())
            {
                PrintToClient(player, KNA_VSH + "You can't change your boss as a boss!");
                return;
            }

            CookieUtil.Set(player, "boss", boss_id);
            PrintToClient(player, KNA_VSH + "You will now play as " + title + " when chosen as the boss.");
        }
    }();
}