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
::QueuePointThresholds <- [250, 500, 1000, 1500]

function ResetQueuePoints(player)
{
    if (player in QueuePoints)
        delete QueuePoints[player];
}

function GetQueuePoints(player)
{
    return player in QueuePoints ? QueuePoints[player] : 0;
}

function SetQueuePoints(player, amount)
{
    QueuePoints[player] <- amount;
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
            return GetValidPlayers()[RandomInt(0, GetValidPlayers().len() - 1)];
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
        if(player == null
            || !player
            || !player.IsPlayer()
            || (player.GetTeam() != TF_TEAM_MERC && player.GetTeam() != TF_TEAM_BOSS))
                ResetQueuePoints(player);
    }
})

AddListener("round_end", 1, function (winner)
{
    foreach (player in GetValidMercs())
    {
        local damage = GetRoundDamage(player);
        foreach (point in QueuePointThresholds)
        {
            if(point <= damage)
                SetQueuePoints(player, GetQueuePoints(player) + 1);
            else
                break;
        }
    }

    /*
    local queueboard = GetQueuePointsSorted();
    local count = clampCeiling(queueboard.len(), 5);
    local message = "Queue Standings\n";
    for (local i = 0; i < count; i++)
    {
        message += GetPropString(queueboard[i][0], "m_szNetname") + " - " + queueboard[i][1] + "\n";
    }
    ClientPrint(null, HUD_PRINTCENTER, message); */

    SetPersistentVar("queue_points", QueuePoints);
})

AddListener("disconnect", 0, function(player, params)
{
    ResetQueuePoints(player);
});