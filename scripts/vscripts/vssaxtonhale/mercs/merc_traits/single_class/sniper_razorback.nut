characterTraitsLibrary.push(class extends CharacterTrait
{
    wasDestroyed = false;
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SNIPER && player.HasWearable("razorback");
    }

    function OnDamageTaken(attacker, params)
    {
        if (wasDestroyed || !IsValidBoss(attacker) || player.InCond(TF_COND_INVULNERABLE))
            return;

        if ((params.damage_type == 1 || params.damage_type == DMG_BLAST) && params.damage < player.GetHealth())
            return;

        wasDestroyed = true;
        params.damage = 0;

        local wearable = player.GetWearable("razorback");
        if (wearable != null)
            wearable.Kill();

        local deltaVector = player.GetCenter() - attacker.GetCenter();
        deltaVector.z = 0;
        deltaVector.Norm();
        player.Yeet(deltaVector * 900 + Vector(0, 0, 300));

        EmitSoundOn("vsh_sfx.shield_break", player);
    }
});