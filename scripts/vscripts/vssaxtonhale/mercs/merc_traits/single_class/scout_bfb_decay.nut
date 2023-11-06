characterTraitsLibrary.push(class extends CharacterTrait
{
    //time it takes to decay at 100%
    DECAY_TIME = 8;

    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SCOUT
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "baby_face_blaster");
    }

    function OnApply()
    {
        local primary = player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY);
        if (primary != null)
            primary.AddAttribute("hype decays over time", CalculateDecay(), -1);
    }

    function CalculateDecay()
    {
        return (100.0 / 66.0) * (1.0 / DECAY_TIME);
    }
});