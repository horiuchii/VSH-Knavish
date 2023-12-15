class Cookies
{
    PlayerData = {}
    PlayerBannedSaving = {}
    loaded_cookies = false

    Table =
    {
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
            default_value = DIFFICULTY.NORMAL
        },
        ["custom_vo"] =
        {
            default_value = 1
        },
        ["menu_music"] =
        {
            default_value = 1
        }
    }

    GeneralStats =
    [
        "lifetime"
        "damage"
    ]

    SpecificTFClassStats =
    {
        ["scout"] =
        [
            "healing"
            "moonshots"
        ],
        ["soldier"] =
        [
            "healing"
        ],
        ["pyro"] =
        [
            "airblast"
        ],
        ["demo"] = [],
        ["heavy"] =
        [
            "healing"
        ],
        ["engineer"] =
        [
            "healing"
            //"sentrydamage"
        ],
        ["medic"] =
        [
            "healing"
            "ubers_stock"
            "ubers_kritz"
            "ubers_quickfix"
            "ubers_vacc"
        ],
        ["sniper"] =
        [
            "headshots"
            "glowtime"
        ],
        ["spy"] =
        [
            "backstabs"
        ]
    }

    MiscStats =
    [
        "bosskills"
        "wallclimbs"
        "bossgoomba"
    ]

    BossStats =
    [
        "bosslifetime"
        "merckills"
        "headstomps"
    ]

    SpecificBossStats =
    {
        ["saxton_hale"] =
        [
            "slamkills"
            "chargekills"
            "bravejumpcount"
        ]
    }

    function constructor()
    {
        // Create Total and Per Class Cookies for General and Misc Stats
        foreach (tfclass_name in TFClassUtil.CacheNames)
        {
            foreach(stat_name in GeneralStats)
            {
                Table[tfclass_name + "_" + stat_name] <- {default_value = 0};
                Table["total_" + stat_name] <- {default_value = 0};
            }

            foreach(stat_name in MiscStats)
            {
                Table[tfclass_name + "_" + stat_name] <- {default_value = 0};
                Table["total_" + stat_name] <- {default_value = 0};
            }
        }

        // Create Total and Per Class Cookies for Specific Stats
        foreach(tfclass_name, cookie_array in SpecificTFClassStats)
        {
            foreach(cookie in cookie_array)
            {
                Table[tfclass_name + "_" + cookie] <- {default_value = 0};
                Table["total_" + cookie] <- {default_value = 0};
            }
        }

        // Create Total and Per Boss Cookies for General Boss Stats
        foreach(bossname, bossclass in bossLibrary)
        {
            foreach(stat_name in BossStats)
            {
                Table[bossname + "_" + stat_name] <- {default_value = 0};
                Table["total_" + stat_name] <- {default_value = 0};
            }
        }

        // Create Total and Per Boss Cookies for Specific Stats
        foreach(bossname, cookie_array in SpecificBossStats)
        {
            foreach(cookie in cookie_array)
            {
                Table[bossname + "_" + cookie] <- {default_value = 0};
                Table["total_" + cookie] <- {default_value = 0};
            }
        }

        // Create Difficulty Win Cookies for each boss and total
        foreach(i, difficulty in DifficultyInternalName)
        {
            if(i == DIFFICULTY.EASY)
                continue;

            Table["total_victory_" + difficulty] <- {default_value = 0};
            foreach(bossname, bossclass in bossLibrary)
            {
                Table[bossname + "_victory_" + difficulty] <- {default_value = 0};
            }
        }
    }
}
::Cookies <- Cookies();

class CookieUtil
{
    function Get(player, cookie)
    {
        return Cookies.PlayerData[player.entindex()][cookie];
    }

    function Set(player, cookie, value, save = true)
    {
        Cookies.PlayerData[player.entindex()][cookie] <- value;

        if(save)
        {
            SetPersistentVar("player_cookies", Cookies.PlayerData);
            SavePlayerData(player);
        }

        return Cookies.PlayerData[player.entindex()][cookie];
    }

    function Add(player, cookie, value, save = true)
    {
        Cookies.PlayerData[player.entindex()][cookie] <- Cookies.PlayerData[player.entindex()][cookie] + value;

        if(save)
        {
            SetPersistentVar("player_cookies", Cookies.PlayerData);
            SavePlayerData(player);
        }

        return Cookies.PlayerData[player.entindex()][cookie];
    }

    function Reset(player)
    {
        local default_cookies = {};
        foreach (name, cookie in Cookies.Table)
        {
            default_cookies[name] <- cookie.default_value;
        }

        Cookies.PlayerData[player.entindex()] <- default_cookies;

        SetPersistentVar("player_cookies", Cookies.PlayerData);
    }

    function CreateCache(player)
    {
        Reset(player);

        if(!GetPlayerAccountID(player))
        {
            Cookies.PlayerBannedSaving[GetPlayerUserID(player)] <- true;
            PrintToClient(player, KNA_VSH + "Something went wrong when trying to get your cookies. Rejoining may fix.");
            return;
        }

        if(!Cookies.loaded_cookies)
        {
            LoadPersistentCookies();
        }

        LoadPlayerData(player)
    }

    function LoadPersistentCookies()
    {
        local cookies_to_load = GetPersistentVar("player_cookies", null);
        if(cookies_to_load)
            Cookies.PlayerData = cookies_to_load;

        Cookies.loaded_cookies = true;
    }

    function SavePlayerData(player)
    {
        if(GetPlayerUserID(player) in Cookies.PlayerBannedSaving)
        {
            PrintToClient(player, KNA_VSH + "Refusing to save your cookies due to a previous error. Rejoining may fix.");
            return;
        }

        local save = "";

        foreach (name, cookie in Cookies.Table)
        {
            local cookie_value = CookieUtil.Get(player, name);

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
        if(GetPlayerUserID(player) in Cookies.PlayerBannedSaving)
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
                if(key_buffer in Cookies.Table)
                {
                    switch(type(Cookies.Table[key_buffer].default_value))
                    {
                        case "string": value_buffer = value_buffer.tostring(); break;
                        case "integer": value_buffer = value_buffer.tointeger(); break;
                    }
                    CookieUtil.Set(player, key_buffer, value_buffer, false);
                }
            }

            SetPersistentVar("player_cookies", Cookies.PlayerData);
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
            option_setting = option_setting ? "[On]" : "[Off]";
        else
            option_setting = "[" + option_setting + "]";

        return option_setting + "\n";
    }
}
::CookieUtil <- CookieUtil();
