characterTraitsClasses.push(class extends CharacterTrait
{
    wasDestroyed = false;
    function CanApply()
    {
        if (player.GetPlayerClass() != TF_CLASS_SNIPER)
            return false;

        local wearable = null;
        while (wearable = Entities.FindByClassname(wearable, "tf_wearable_razorback"))
            if (wearable.GetOwner() == player)
                return true;
        return false;
    }

    function OnDamageTaken(attacker, params)
    {
        if (wasDestroyed || !IsValidBoss(attacker) || player.InCond(TF_COND_INVULNERABLE))
            return;

        if ((params.damage_type == 1 || params.damage_type == DMG_BLAST) && params.damage < player.GetHealth())
            return;

        wasDestroyed = true;
        params.damage = 0;

        local wearable = null;
        while (wearable = Entities.FindByClassname(wearable, "tf_wearable_razorback"))
            if (wearable.GetOwner() == player)
            {
                wearable.Kill();
                break;
            }

        local deltaVector = player.GetCenter() - attacker.GetCenter();
        deltaVector.z = 0;
        deltaVector.Norm();
        player.Yeet(deltaVector * 900 + Vector(0, 0, 300));

        EmitSoundOn("vsh_sfx.shield_break", player);
    }
});