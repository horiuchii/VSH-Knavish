//=========================================================================
//Copyright LizardOfOz.
//
//Credits:
//  LizardOfOz - Programming, game design, promotional material and overall development. The original VSH Plugin from 2010.
//  Maxxy - Saxton Hale's model imitating Jungle Inferno SFM; Custom animations and promotional material.
//  Velly - VFX, animations scripting, technical assistance.
//  JPRAS - Saxton model development assistance and feedback.
//  MegapiemanPHD - Saxton Hale and Gray Mann voice acting.
//  James McGuinn - Mercenaries voice acting for custom lines.
//  Yakibomb - give_tf_weapon script bundle (used for Hale's first-person hands model).
//=========================================================================

game_text_scoreboard <- null;

game_text_scoreboard = SpawnEntityFromTable("game_text",
{
    color = "255 255 255",
    color2 = "0 0 0",
    channel = 4,
    effect = 0,
    fadein = 0,
    fadeout = 0,
    fxtime = 0,
    holdtime = 250,
    message = "0",
    spawnflags = 0,
    x = 0.025,
    y = 0.35
});

damage <- {};

function ResetRoundDamage()
{
    damage <- {};
}

function GetRoundDamage(player)
{
    return player in damage ? damage[player] : 0;
}

function SetRoundDamage(player, damageValue)
{
    damage[player] <- damageValue;
}

AddListener("player_hurt", 5, function (attacker, victim, params)
{
    local damage = params.damageamount;
    if (victim.GetHealth() < 0)
        damage -= params.health - victim.GetHealth();
    if (!IsValidBoss(victim))
        return;
    SetRoundDamage(attacker, GetRoundDamage(attacker) + damage);
});

function GetDamageBoardSorted()
{
    function sortFunction(it, that)
    {
        return that[1] - it[1];
    }

    local damageAsArray = []
    foreach(player, dmg in damage)
        damageAsArray.push([player, dmg]);
    damageAsArray.sort(@(it, that) that[1] - it[1]);
    return damageAsArray;
}

AddListener("tick_only_valid", 10, function (timeDelta)
{
    return;
    foreach (player in GetValidPlayers())
    {
        if (GetPropInt(player, "m_nButtons") & IN_SCORE)
            continue;

        local damage_data = GetDamageBoardSorted();
        local damage_string = ""
        local count = clampCeiling(damage.len(), 5)

        for (local i = 0; i < 5; i++)
        {
            damage_string += (i + 1) + ". "

            if(i >= count)
                damage_string += "---\n"
            else
                damage_string += GetPropString(damage_data[i][0], "m_szNetname") + " - " + damage_data[i][1] + "\n";
        }

        EntFireByHandle(game_text_scoreboard, "AddOutput", "message " + damage_string, 0, player, player);
        EntFireByHandle(game_text_scoreboard, "Display", "", 0, player, player);
    }
});