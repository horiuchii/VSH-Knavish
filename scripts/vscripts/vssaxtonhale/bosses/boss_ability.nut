
enum AbilityMode
{
    COOLDOWN
    LIMITED_USE
}

class BossAbility extends BossTrait
{
    meter = null;
    cooldown = null;
    uses_left = null;
    max_uses = null;
    voiceRNG = null;
    mode = null;

    function Perform() { return; }

    function OnTickAlive(timeDelta)
    {
        if (meter < 0)
        {
            meter += timeDelta;
            if (meter >= 0)
            {
				EmitSoundOnClient("TFPlayer.ReCharged", boss);
                meter = 0;
			}
		}
    }

    function SetCooldown(override = null)
    {
        if (override == null)
            meter = -cooldown;
        else
            meter = -override;
    }
}