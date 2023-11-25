class CustomVoiceLine extends CharacterTrait
{
    tickInverval = 0.1;
    playInterval = 0.1;
    lastTick = 0;
    lastPlay = 0;

    function constructor()
    {
        lastTick = Time();
        lastPlay = 0;
    }

    function DoTick(timeDelta)
    {
        local time = Time();
        while (time - lastTick >= tickInverval)
        {
            local timeDelta = time - lastTick;
            lastTick += tickInverval;
            if (time - lastPlay >= playInterval)
            {
                local wasPlayed = player.IsAlive() ? OnTickAlive(timeDelta) : false;
                local wasPlayed2 = OnTickAliveOrDead(timeDelta);
                if (wasPlayed || wasPlayed2)
                    lastPlay = time;
            }
        }
    }
}

class BossVoiceLine extends CustomVoiceLine
{
    boss = null;
    trait_team = TF_TEAM_BOSS;

    // NEVER override ApplyTrait() past this point
    function ApplyTrait(player)
    {
        boss = player;
        base.ApplyTrait(player);
    }
}