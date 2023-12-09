::PlayerBannedSaving <- {}

::CookieTable <- {
    ["become_boss"] =
    {
        default_value = 1
    },
    ["boss"] =
    {
        default_value = "saxton_hale"
    },
    ["difficulty"] =
    {
        default_value = 0
    },
    ["custom_vo"] =
    {
        default_value = 1
    }
}

//stat cookies
::allclass_stats <- [
    "lifetime"
    "damage"
    "bosskills"
    "wallclimbs"
    "bossgoomba"
]

::specificclass_stats <- {
    ["Scout"] = [
        "healing"
        "moonshots"
    ],
    ["Soldier"] = [
        "healing"
    ],
    ["Pyro"] = [],
    ["Demoman"] = [],
    ["Heavy"] = [
        "healing"
    ],
    ["Engineer"] = [
        "healing"
    ],
    ["Medic"] = [
        "healing"
    ],
    ["Sniper"] = [
        "headshots"
        "glowtime"
    ],
    ["Spy"] = [
        "backstabs"
    ]
}

foreach(class_name, cookie_array in specificclass_stats)
{
    foreach(cookie in cookie_array)
    {
        CookieTable[class_name + "_" + cookie] <- {default_value = 0};
        CookieTable["total_" + cookie] <- {default_value = 0};
    }
}

foreach(stat_name in allclass_stats)
{
    CookieTable["total_" + stat_name] <- {default_value = 0};
}

foreach (i, value in TFClass.names_proper)
{
    foreach(stat_name in allclass_stats)
    {
        CookieTable[value + "_" + stat_name] <- {default_value = 0};
    }
}

class CookiesManager
{
    PlayerCookies = {}
    loaded_cookies = false;

    function Get(player, cookie)
    {
        return PlayerCookies[player.entindex()][cookie];
    }

    function Set(player, cookie, value, save = true)
    {
        PlayerCookies[player.entindex()][cookie] <- value;

        if(save)
        {
            SetPersistentVar("player_cookies", PlayerCookies);
            SavePlayerData(player);
        }

        return PlayerCookies[player.entindex()][cookie];
    }

    function Add(player, cookie, value, save = true)
    {
        PlayerCookies[player.entindex()][cookie] <- PlayerCookies[player.entindex()][cookie] + value;

        if(save)
        {
            SetPersistentVar("player_cookies", PlayerCookies);
            SavePlayerData(player);
        }

        return PlayerCookies[player.entindex()][cookie];
    }

    function Reset(player)
    {
        local default_cookies = {};
        foreach (name, cookie in CookieTable)
        {
            default_cookies[name] <- cookie.default_value;
        }

        PlayerCookies[player.entindex()] <- default_cookies;

        SetPersistentVar("player_cookies", PlayerCookies);
    }

    function CreateCache(player)
    {
        Reset(player);

        if(!GetPlayerAccountID(player))
        {
            PlayerBannedSaving[GetPlayerUserID(player)] <- true;
            PrintToClient(player, KNA_VSH + "Something went wrong when trying to get your cookies. Rejoining may fix.");
            return;
        }

        if(!loaded_cookies) LoadPersistentCookies();

        LoadPlayerData(player)
    }

    function LoadPersistentCookies()
    {
        local cookies_to_load = GetPersistentVar("player_cookies", null);
        if(cookies_to_load)
            PlayerCookies = cookies_to_load;

        loaded_cookies = true;
    }

    function SavePlayerData(player)
    {
        if(GetPlayerUserID(player) in PlayerBannedSaving)
        {
            PrintToClient(player, KNA_VSH + "Refusing to save your cookies due to a previous error. Rejoining may fix.");
            return;
        }

        local save = "";

        foreach (name, cookie in CookieTable)
        {
            local cookie_value = Cookies.Get(player, name);

            switch(type(cookie_value))
            {
                case "string": cookie_value = cookie_value.tostring(); break;
                case "bool":
                case "integer": cookie_value = cookie_value.tointeger(); break;
            }

            save += name + "," + cookie_value + "\n"
        }

        StringToFile("knavish_vsh_save/" + GetPlayerAccountID(player) + ".sav", save);
    }

    function LoadPlayerData(player)
    {
        if(GetPlayerUserID(player) in PlayerBannedSaving)
        {
            PrintToClient(player, KNA_VSH + "Refusing to load your cookies due to a previous error. Rejoining may fix.");
            return;
        }

        local save = FileToString("knavish_vsh_save/" + GetPlayerAccountID(player) + ".sav");

        if(save == null)
            return false;

        try
        {
            local split_save = split(save, "\n", true);
            foreach (save_entry in split_save)
            {
                local entry_array = split(save_entry, ",");
                local key_buffer = entry_array[0];
                local value_buffer = entry_array[1];
                if(key_buffer in CookieTable)
                {
                    switch(type(CookieTable[key_buffer].default_value))
                    {
                        case "string": value_buffer = value_buffer.tostring(); break;
                        case "integer": value_buffer = value_buffer.tointeger(); break;
                    }
                    Cookies.Set(player, key_buffer, value_buffer, false);
                }
            }

            SetPersistentVar("player_cookies", PlayerCookies);
            return true;
        }
        catch(exception)
        {
            PrintToClient(player, "\x07" + "FF0000" + "Your cookies failed to load. Please alert a server admin and provide the text below.");
            PrintToClient(player, "\x07" + "FFA500" + "Save: " + "tf/scriptdata/knavish_vsh_save/" + GetPlayerAccountID(player) + ".sav");
            PrintToClient(player, "\x07" + "FFA500" + "Error: " + exception);
        }
    }

    function MakeGenericCookieString(player, cookie)
    {
        local option_setting = Get(player, cookie);
        if(type(option_setting) == "integer" || type(option_setting) == "bool")
            option_setting = option_setting ? "[ON]" : "[OFF]";
        else
            option_setting = "[" + option_setting + "]";

        return option_setting + "\n";
    }
}
::Cookies <- CookiesManager();