::TrackedStats <- {
    ["wallclimb"] = {},
    ["goomba"] = {},
    ["bosskills"] = {},
    ["backstabs"] = {},
    ["headshots"] = {},
    ["glowtime"] = {},
    ["moonshots"] = {}
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

    TrackedStats[stat][player] <- TrackedStats[stat][player] + amount;
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
    if(!IsBoss(victim))
        return;

    AddToTrackedStat(attacker, "bosskills");
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
    printl("adding " + length.tointeger() + " glow")
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

AddListener("round_end", 100, function (winner)
{
    if(Convars.GetInt("sv_cheats") == 1 && IsDedicatedServer())
        return;

    foreach (player in GetValidPlayers())
    {
        if(!IsBoss(player))
        {
            local class_cookieid = TFClass.GetProperClassName(player.GetPlayerClass());

            if(class_cookieid == null)
                continue;

            Cookies.Add(player, class_cookieid + "_lifetime", GetLifetime(player).tointeger(), false)
            Cookies.Add(player, class_cookieid + "_damage", GetRoundDamage(player), false)
            Cookies.Add(player, class_cookieid + "_bosskills", GetTrackedStat(player, "bosskills"), false)
            Cookies.Add(player, class_cookieid + "_wallclimbs", GetTrackedStat(player, "wallclimb"), false)
            Cookies.Add(player, class_cookieid + "_bossgoomba", GetTrackedStat(player, "goomba"), false)

            //todo save only for specific classes
            foreach(cookie in specificclass_stats[class_cookieid])
            {
                switch(cookie)
                {
                    case "healing": Cookies.Add(player, class_cookieid + "_healing", GetRoundHealing(player), false); break;
                    case "backstabs": Cookies.Add(player, class_cookieid + "_backstabs", GetTrackedStat(player, "backstabs"), false); break;
                    case "headshots": Cookies.Add(player, class_cookieid + "_headshots", GetTrackedStat(player, "headshots"), false); break;
                    case "glowtime": Cookies.Add(player, class_cookieid + "_glowtime", GetTrackedStat(player, "glowtime"), false); break;
                    case "moonshots": Cookies.Add(player, class_cookieid + "_moonshots", GetTrackedStat(player, "moonshots"), false); break;
                }
            }

            Cookies.Add(player, "total_lifetime", GetLifetime(player).tointeger(), false)
            Cookies.Add(player, "total_damage", GetRoundDamage(player), false)
            Cookies.Add(player, "total_healing", GetRoundHealing(player), false)
            Cookies.Add(player, "total_bosskills", GetTrackedStat(player, "bosskills"), false)
            Cookies.Add(player, "total_wallclimbs", GetTrackedStat(player, "wallclimb"), false)
            Cookies.Add(player, "total_bossgoomba", GetTrackedStat(player, "goomba"), false)
            Cookies.Add(player, "total_backstabs", GetTrackedStat(player, "backstabs"), false)
            Cookies.Add(player, "total_headshots", GetTrackedStat(player, "headshots"), false)
            Cookies.Add(player, "total_glowtime", GetTrackedStat(player, "glowtime"), false)
            Cookies.Add(player, "total_moonshots", GetTrackedStat(player, "moonshots"), false)


            Cookies.SavePlayerData(player);
        }
    }
});