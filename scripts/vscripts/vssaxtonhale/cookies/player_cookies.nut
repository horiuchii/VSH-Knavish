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

class CookiesManager
{
    PlayerCookies = {}

    function Get(player, cookie)
    {
        Validate(player);

        return PlayerCookies[player.entindex()][cookie];
    }

    function Set(player, cookie, value)
    {
        Validate(player);

        PlayerCookies[player.entindex()][cookie] <- value;
        SetPersistentVar("player_cookies", PlayerCookies);
        SavePlayerData(player);
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

    function Validate(player)
    {
        //there should NEVER be a case where a player's entindex doesnt exist in PlayerCookies, but my code sucks and im lazy
        //if they dont exist, reset their cookies and attempt to load their save file
        //TOO BAD!
        if(!(player.entindex() in PlayerCookies))
        {
            Reset(player);

            if(!IsPlayerABot(player))
            {
                LoadPlayerData(player);
            }
        }
    }
}
::Cookies <- CookiesManager();

AddListener("new_round", -2, function()
{
    local cookies_to_load = GetPersistentVar("player_cookies", null);
    if(cookies_to_load)
        PlayerCookies <- cookies_to_load;

    foreach(player in GetValidPlayers())
    {
        Cookies.Validate(player);
    }
});

::SavePlayerData <- function(player)
{
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

::LoadPlayerData <- function(player)
{
    local save = FileToString("knavish_vsh_save/" + GetPlayerAccountID(player) + ".sav");

	if(save == null)
        return;

    local save_length = save.len();

    local i = 0;
    local bReadingKey = true;
    local key_buffer = "";
    local value_buffer = "";

    try
    {
        while(i < save_length)
        {
            if(save[i] == ',') //we've got our key
            {
                bReadingKey = false;
                i += 1;
            }

            if(save[i] == '\n') //we've gotten to the end of the value
            {
                if(key_buffer in CookieTable)
                {
                    switch(type(CookieTable[key_buffer].default_value))
                    {
                        case "string": value_buffer = value_buffer.tostring(); break;
                        case "integer": value_buffer = value_buffer.tointeger(); break;
                    }

                    Cookies.Set(player, key_buffer, value_buffer);
                }

                //clear everything and start reading the next key
                key_buffer = "";
                value_buffer = "";
                i += 1;
                bReadingKey = true;
                continue;
            }

            if(bReadingKey)
                key_buffer += save[i].tochar();
            else
                value_buffer += save[i].tochar();

            i += 1;
        }
    }
    catch(exception)
    {
        PrintToClient(player, "\x07" + "FF0000" + "Your cookies failed to load. Please alert a server admin and provide the text below.");
        PrintToClient(player, "\x07" + "FFA500" + "Save: " + "tf/scriptdata/knavish_vsh_save/" + GetPlayerAccountID(player) + ".sav");
        PrintToClient(player, "\x07" + "FFA500" + "Error: " + exception + "\nIndex: " + i + "\nReading Key?: " + bReadingKey + "\nKey: " + key_buffer + "\nValue: " + value_buffer);
    }
}