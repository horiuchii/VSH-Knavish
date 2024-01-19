
int bPlayMercVO[MAXPLAYERS] = { true, ...};

public Action HookSound(int clients[MAXPLAYERS], int& numClients, char sample[PLATFORM_MAX_PATH], int& entity, int& channel, float& volume, int& level, int& pitch, int& flags, char soundEntry[PLATFORM_MAX_PATH], int& seed)
{

    if (strncmp(sample, "vo/mercs_by_james", 17) != 0)
        return Plugin_Continue;

    PrintToServer("\nChecking\n");
    for (int i = 0; i < numClients; i++)
    {
        if (!bPlayMercVO[clients[i]])
        {
            PrintToServer("Sound Blocked For %N", clients[i]);
            for (int j = i; j < numClients - 1; j++)
            {
                clients[j] = clients[j+1];
            }

            numClients--;
            i--;
        }
    }

    return (numClients > 0) ? Plugin_Changed : Plugin_Stop;
}

public void CacheMercVOPreference(EventScript event)
{
    PrintToServer("Set %i to %i", event.GetInt("player_index"), event.GetBool("play_merc_vo"));
    bPlayMercVO[event.GetInt("player_index")] = event.GetBool("play_merc_vo");
}