mercTraitsLibrary.push(class extends MercenaryTrait
{
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SCOUT
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY), "pbpp");
    }

    function OnDamageTaken(attacker, params)
    {
        if (attacker == worldspawn
            && params.damage_type & DMG_FALL
            && player.GetActiveWeapon() == player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY))
        {
            params.damage = 0.0;
        }
    }
});