::TrackedStats <-
{
    //merc
    ["wallclimb"] = {},
    ["goomba"] = {},
    ["bosskills"] = {},
    ["backstabs"] = {},
    ["headshots"] = {},
    ["glowtime"] = {},
    ["moonshots"] = {},
    //boss
    ["bravejump"] = {},
    ["merckills"] = {},
    ["chargekills"] = {},
    ["slamkills"] = {},
    ["stompkills"] = {}
};

::GetTrackedStat <- function(player, stat)
{
    if(!(player in TrackedStats[stat]))
        return 0;

    return TrackedStats[stat][player];
}

::AddToTrackedStat <- function(player, stat, amount = 1)
{
    if(!(player in TrackedStats[stat]))
        TrackedStats[stat][player] <- 0;

    TrackedStats[stat][player] += amount;
}

AddListener("wall_climb", 0, function (player, hits, quickFixLink)
{
    if(IsRoundSetup() || IsRoundOver())
        return;

    AddToTrackedStat(player, "wallclimb");
});

AddListener("goomba", 0, function (player)
{
    if(IsRoundSetup() || IsRoundOver())
        return;

    AddToTrackedStat(player, "goomba");
});

AddListener("death", 0, function (attacker, victim, params)
{
    if(IsBoss(victim) && IsMerc(attacker))
        AddToTrackedStat(attacker, "bosskills");
    else if(IsMerc(victim) && IsBoss(attacker))
        AddToTrackedStat(attacker, "merckills");
});

AddListener("backstab", 0, function (player)
{
    if(IsRoundSetup() || IsRoundOver())
        return;

    AddToTrackedStat(player, "backstabs");
});

AddListener("damage_hook", 0, function (attacker, victim, params)
{
    if(IsRoundSetup() || IsRoundOver())
        return;

    if(!IsValidPlayer(attacker) || !IsValidPlayer(victim))
        return;

    if(attacker.GetPlayerClass() == TF_CLASS_SNIPER && params.damage_custom == TF_DMG_CUSTOM_HEADSHOT)
        AddToTrackedStat(attacker, "headshots");

    //check if special boss ability attack killed here
    if((IsMerc(victim) && IsBoss(attacker)))
    {
        //boss head stomp
        if((params.damage_type & DMG_CRUSH) && params.damage >= victim.GetHealth())
            AddToTrackedStat(attacker, "stompkills");

        //saxton sweeping charge
        if((params.damage_type & DMG_BURN) && params.damage >= victim.GetHealth())
            AddToTrackedStat(attacker, "chargekills");

        //saxton slam
        if((params.damage_type & DMG_BLAST) && params.damage >= victim.GetHealth())
            AddToTrackedStat(attacker, "slamkills");
    }
});

AddListener("hitmans_glow", 0, function (attacker, victim, length)
{
    if(IsRoundSetup() || IsRoundOver())
        return;

    if(!IsValidPlayer(attacker) || !IsValidPlayer(victim))
        return;

    if(!IsBoss(victim))
        return;

    AddToTrackedStat(attacker, "glowtime", length.tointeger());
});

AddListener("player_stunned", 0, function (attacker, victim, big_stun)
{
    if(IsRoundSetup() || IsRoundOver())
        return;

    if(!IsValidPlayer(attacker) || !IsValidPlayer(victim))
        return;

    if(!IsBoss(victim) || !big_stun)
        return;

    AddToTrackedStat(attacker, "moonshots");
});

AddListener("bravejump", 0, function (boss)
{
    if(IsRoundSetup() || IsRoundOver())
        return;

    AddToTrackedStat(boss, "bravejump");
});

AddListener("round_end", 100, function (winner)
{
    if(isRoundBailout)
        return;

    if(Convars.GetInt("sv_cheats") == 1 && IsDedicatedServer())
        return;

    foreach (player in GetValidPlayers())
    {
        if(!IsBoss(player))
        {
            local tfclass_name = TFClassUtil.GetCacheString(player.GetPlayerClass());

            if(tfclass_name == null)
                continue;

            CookieUtil.Add(player, tfclass_name + "_lifetime", GetLifetime(player).tointeger(), false)
            CookieUtil.Add(player, tfclass_name + "_damage", GetRoundDamage(player), false)
            CookieUtil.Add(player, tfclass_name + "_bosskills", GetTrackedStat(player, "bosskills"), false)
            CookieUtil.Add(player, tfclass_name + "_wallclimbs", GetTrackedStat(player, "wallclimb"), false)
            CookieUtil.Add(player, tfclass_name + "_bossgoomba", GetTrackedStat(player, "goomba"), false)

            foreach(stat in Cookies.SpecificTFClassStats[tfclass_name])
            {
                switch(stat)
                {
                    case "healing": CookieUtil.Add(player, tfclass_name + "_healing", GetRoundHealing(player), false); break;
                    case "backstabs": CookieUtil.Add(player, tfclass_name + "_backstabs", GetTrackedStat(player, "backstabs"), false); break;
                    case "headshots": CookieUtil.Add(player, tfclass_name + "_headshots", GetTrackedStat(player, "headshots"), false); break;
                    case "glowtime": CookieUtil.Add(player, tfclass_name + "_glowtime", GetTrackedStat(player, "glowtime"), false); break;
                    case "moonshots": CookieUtil.Add(player, tfclass_name + "_moonshots", GetTrackedStat(player, "moonshots"), false); break;
                }
            }

            CookieUtil.Add(player, "total_lifetime", GetLifetime(player).tointeger(), false)
            CookieUtil.Add(player, "total_damage", GetRoundDamage(player), false)
            CookieUtil.Add(player, "total_healing", GetRoundHealing(player), false)
            CookieUtil.Add(player, "total_bosskills", GetTrackedStat(player, "bosskills"), false)
            CookieUtil.Add(player, "total_wallclimbs", GetTrackedStat(player, "wallclimb"), false)
            CookieUtil.Add(player, "total_bossgoomba", GetTrackedStat(player, "goomba"), false)
            CookieUtil.Add(player, "total_backstabs", GetTrackedStat(player, "backstabs"), false)
            CookieUtil.Add(player, "total_headshots", GetTrackedStat(player, "headshots"), false)
            CookieUtil.Add(player, "total_glowtime", GetTrackedStat(player, "glowtime"), false)
            CookieUtil.Add(player, "total_moonshots", GetTrackedStat(player, "moonshots"), false)

            CookieUtil.SavePlayerData(player);
        }
        else //boss stats
        {
            local boss_name = playerType[player].name
            CookieUtil.Add(player, boss_name + "_bosslifetime", GetLifetime(player).tointeger(), false)
            CookieUtil.Add(player, boss_name + "_merckills", GetTrackedStat(player, "merckills"), false)
            CookieUtil.Add(player, boss_name + "_headstomps", GetTrackedStat(player, "stompkills"), false)

            if(winner == TF_TEAM_BOSS)
            {
                CookieUtil.Add(player, boss_name + "_victory_" + DifficultyInternalName[CookieUtil.Get(player, "difficulty")], 1, false);
                CookieUtil.Add(player, "total_victory_" + DifficultyInternalName[CookieUtil.Get(player, "difficulty")], 1, false);
            }

            foreach(stat in Cookies.SpecificBossStats[boss_name])
            {
                switch(stat)
                {
                    case "slamkills": CookieUtil.Add(player, boss_name + "_slamkills", GetTrackedStat(player, "slamkills"), false); break;
                    case "chargekills": CookieUtil.Add(player, boss_name + "_chargekills", GetTrackedStat(player, "chargekills"), false); break;
                    case "bravejumpcount": CookieUtil.Add(player, boss_name + "_bravejumpcount", GetTrackedStat(player, "bravejump"), false); break;
                }
            }

            CookieUtil.Add(player, "total_bosslifetime", GetLifetime(player).tointeger(), false)
            CookieUtil.Add(player, "total_merckills", GetTrackedStat(player, "merckills"), false)
            CookieUtil.Add(player, "total_headstomps", GetTrackedStat(player, "stompkills"), false)

            CookieUtil.SavePlayerData(player);
        }
    }
});

AddListener("setup_end", 0, function()
{
    foreach (stat in TrackedStats)
    {
        foreach(player in stat)
        {
            delete TrackedStats[stat][player]
        }
    }
});