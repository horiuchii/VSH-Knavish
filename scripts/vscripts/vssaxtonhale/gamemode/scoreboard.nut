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

//
// DAMAGE
//
damage <- {};
boss_damage <- 0; //set up for duo-boss in future

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
    if (IsRoundOver())
        return;

    local damage = params.damageamount;
    if (victim.GetHealth() < 0)
        damage -= params.health - victim.GetHealth();

    if (IsValidBoss(attacker))
    {
        boss_damage += damage;
        return;
    }

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

//
// LIFETIME
//
round_start_time <- 0;

AddListener("setup_end", 5, function ()
{
    round_start_time = Time();
});

player_death_time <- {};

function GetTimeSinceRoundStarted()
{
    return Time() - round_start_time;
}

function GetPlayerDeathTime(player)
{
    return player in player_death_time ? player_death_time[player] : 0;
}

function SetPlayerDeathTime(player)
{
    player_death_time[player] <- Time();
}

AddListener("death", 5, function (attacker, player, params)
{
    SetPlayerDeathTime(player);
})

function GetDeathTime(player)
{
    if (player.IsAlive())
    {
        return GetTimeSinceRoundStarted();
    }
    else
    {
        return GetPlayerDeathTime(player) - round_start_time;
    }
}

//
// HEALING
//
healing <- {};

function GetRoundHealing(player)
{
    return player in healing ? healing[player] : 0;
}

function SetRoundHealing(player, healingValue)
{
    healing[player] <- healingValue;
}

AddListener("player_healed", 5, function (patient, healer, amount)
{
    if (IsRoundOver())
        return;

    if (patient.GetTeam() != healer.GetTeam())
        return;

        SetRoundHealing(healer, GetRoundHealing(healer) + amount);
})

//
// KILLS
//
kills <- {};

function GetRoundKills(player)
{
    return player in kills ? kills[player] : 0;
}

function SetRoundKills(player, amount)
{
    kills[player] <- amount;
}

AddListener("death", 0, function (attacker, player, params)
{
    if(!IsValidRound())
        return;

    if(!attacker || !attacker.IsValid())
        return;

    if(attacker == player)
        return;

    SetRoundKills(attacker, GetRoundKills(attacker) + 1);
})