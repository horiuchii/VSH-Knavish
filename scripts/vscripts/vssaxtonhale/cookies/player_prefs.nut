PlayerCookies <- {}

enum COOKIE {
    BecomeBoss
    Boss
    Difficulty
    CustomVO
}

DefaultPrefs <- {
    [COOKIE.BecomeBoss] = 1,
    [COOKIE.Boss] = "saxton_hale",
    [COOKIE.Difficulty] = 0,
    [COOKIE.CustomVO] = 1
};

function GetPref(player, cookie)
{
    return PlayerCookies[player.entindex()][cookie];
}

function SetPref(player, cookie, value)
{
    PlayerCookies[player.entindex()][cookie] <- value;
    SetPersistentVar("player_preferences", PlayerCookies);
    SavePlayerData(player);
    return PlayerCookies[player.entindex()][cookie];
}

function ResetPrefs(player)
{
    PlayerCookies[player.entindex()] <- DefaultPrefs;
    SetPersistentVar("player_preferences", PlayerCookies);
}

AddListener("new_round", -2, function()
{
    local prefrences_to_load = GetPersistentVar("player_preferences", null);
    if(prefrences_to_load)
        PlayerCookies <- prefrences_to_load;

    foreach(player in GetValidPlayers())
    {
        if(!(player.entindex() in PlayerCookies))
        {
            ResetPrefs(player);
        }

        if(!IsPlayerABot(player))
        {
            LoadPlayerData(player);
        }
    }
});

AddListener("connect", -1, function(player, params)
{
    ResetPrefs(player);
    if(!IsPlayerABot(player))
    {
        LoadPlayerData(player);
    }
});

function SavePlayerData(player)
{
    local save = "";

	save += "become_boss," + GetPref(player, COOKIE.BecomeBoss).tointeger() + ";"
    save += "boss," + GetPref(player, COOKIE.Boss).tostring() + ";"
    save += "difficulty," + GetPref(player, COOKIE.Difficulty).tointeger() + ";"
    save += "custom_vo," + GetPref(player, COOKIE.CustomVO).tointeger() + ";"

	StringToFile("knavish_vsh_save/" + GetPlayerAccountID(player) + ".sav", save);
}

function LoadPlayerData(player)
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

            if(save[i] == ';') //we've gotten to the end of the value
            {
                switch(key_buffer)
                {
                    case "become_boss":
                    {
                        SetPref(player, COOKIE.BecomeBoss, value_buffer.tointeger());
                        break;
                    }
                    case "boss":
                    {
                        SetPref(player, COOKIE.Boss, value_buffer.tostring());
                        break;
                    }
                    case "difficulty":
                    {
                        SetPref(player, COOKIE.Difficulty, value_buffer.tointeger());
                        break;
                    }
                    case "custom_vo":
                    {
                        SetPref(player, COOKIE.CustomVO, value_buffer.tointeger());
                        break;
                    }
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
        PrintToClient(player, "\x07" + "FF0000" + "Your preferences failed to load. Please alert a server admin and give them the text below.");
        PrintToClient(player, "\x07" + "FFA500" + "Save: " + "tf/scriptdata/knavish_vsh_save/" + GetPlayerAccountID(player) + ".sav");
        PrintToClient(player, "\x07" + "FFA500" + "Error: " + exception + "\nIndex: " + i + "\nReading Key?: " + bReadingKey + "\nKey: " + key_buffer + "\nValue: " + value_buffer);
    }
}