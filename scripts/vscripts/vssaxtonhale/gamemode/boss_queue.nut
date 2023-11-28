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

::SetNextBossByEntity <- function(playerEnt)
{
    SetPersistentVar("next_boss", playerEnt.entindex());
}

::SetNextBossByEntityIndex <- function(playerEntIndex)
{
    SetPersistentVar("next_boss", playerEntIndex);
}

::SetNextBossByUserId <- function(userId)
{
    local playerEnt = GetPlayerFromUserID(userId);
    SetPersistentVar("next_boss", playerEnt.entindex());
}

::QueuePoints <- {}

function ResetQueuePoints(player)
{
    if (player in QueuePoints)
        delete QueuePoints[player];

    SetPersistentVar("queue_points", QueuePoints);
}

function GetQueuePoints(player)
{
    return player in QueuePoints ? QueuePoints[player] : 0;
}

function SetQueuePoints(player, amount)
{
    QueuePoints[player] <- amount;

    SetPersistentVar("queue_points", QueuePoints);
}

function GetQueuePointsSorted()
{
    function sortFunction(a, b)
    {
        if (a[1] < b[1]) return 1;
        if (a[1] > b[1]) return -1;
        return 0;
    }

    local queueAsArray = []
    foreach(player, points in QueuePoints)
        queueAsArray.push([player, points]);
    queueAsArray.sort(sortFunction);
    return queueAsArray;
}

function ProgressBossQueue(iterations = 0)
{
    local nextBossIndex = GetPersistentVar("next_boss", null);
    if (nextBossIndex != null)
    {
        SetPersistentVar("next_boss", null);
        local nextBossPlayer = PlayerInstanceFromIndex(nextBossIndex);
        if (IsValidPlayer(nextBossPlayer))
            return nextBossPlayer;
    }

    if(QueuePoints.len() > 0)
    {
        local queueboard = GetQueuePointsSorted();
        ResetQueuePoints(queueboard[0][0]);
        SetPersistentVar("queue_points", QueuePoints);
        return queueboard[0][0];
    }
    else
    {
        try
        {
            local valid_players = [];
            foreach (i, player in GetValidPlayers())
            {
                if(!!GetPref(player, COOKIE.BecomeBoss))
                {
                    valid_players.append(player)
                }
            }
            return valid_players[RandomInt(0, valid_players.len() - 1)];
        }
        catch(e)
        {
            return GetValidClients()[RandomInt(0, GetValidClients().len() - 1)];
        }
    }
}

AddListener("setup_start", 0, function ()
{
    QueuePoints = GetPersistentVar("queue_points", {});

    foreach (player, amount in QueuePoints)
    {
        if(!IsValidPlayer(player))
            ResetQueuePoints(player);
    }
})

AddListener("disconnect", 0, function(player, params)
{
    ResetQueuePoints(player);
});

::points_added_round <- {};

AddListener("round_end", 1, function (winner)
{
    foreach (player in GetValidMercs())
    {
        if(!!!GetPref(player, COOKIE.BecomeBoss))
            continue;

        SetQueuePoints(player, GetQueuePoints(player) + ConvertRoundPerformanceToPoints(player));
    }

    SetPersistentVar("queue_points", QueuePoints);
})

AddListener("round_end", 100, function (winner)
{
    local queue_pos = 0;
    local queueboard = GetQueuePointsSorted();

    foreach (player in GetValidMercs())
    {
        if(!!!GetPref(player, COOKIE.BecomeBoss))
        {
            PrintToClient(player, VSH_MESSAGE_PREFIX + "You didn't gain any points due your prefrence to not become the boss.");
            continue;
        }

        foreach (i, position in queueboard)
        {
            if (position[0] == player)
            {
                queue_pos = i + 1;
                break;
            }
            queue_pos = queueboard.len() + 1;
        }
        local message = VSH_MESSAGE_PREFIX;
        local points = ConvertRoundPerformanceToPoints(player);
        message += "\x01You gained \x07FFD700" + points + "\x01 ";
        message += (points == 1 ? "point" : "points");
        message += " this round with ";

        local dealt_damage = GetRoundDamage(player) > 0;
        local provided_healing = GetRoundHealing(player) > 0;

        if (dealt_damage)
            message += "\x07FFD700" + GetRoundDamage(player) + "\x01 damage";

        if (provided_healing)
        {
            if(dealt_damage)
                message += " and ";

            message += "\x07FFD700" + GetRoundHealing(player) + "\x01 healing";
        }

        if(!dealt_damage && !provided_healing)
            message += "no damage or healing.";

        message += ".\n";

        message += "\x01You're now \x07FFD700" + addSuffix(queue_pos) + "\x01 in line to become the boss with \x07FFD700" + GetQueuePoints(player) + "\x01 point(s)."
        PrintToClient(player, message);
    }
});


function addSuffix(number)
{
    if (number == 1)
        return "next";

    local lastDigit = number % 10;
    local suffix;

    if (number >= 10 && number <= 20)
        suffix = "th";
    else
    {
        switch (lastDigit)
        {
            case 1: suffix = "st"; break;
            case 2: suffix = "nd"; break;
            case 3: suffix = "rd"; break;
            default: suffix = "th"; break;
        }
    }

    return (number + suffix).tostring();
}

function ConvertRoundPerformanceToPoints(player)
{
    local damage = GetRoundDamage(player);
    local healing = GetRoundHealing(player);
    local points_added = 0;

    if(damage > 1)
        points_added += 5;

    points_added += ((damage + healing) / 250)

    return points_added;
}