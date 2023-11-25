mercTraitsLibrary.push(class extends MercenaryTrait
{
    wasDestroyed = false;
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SNIPER
            && player.HasWearable("darwins_danger_shield");
    }

    function OnApply()
    {
        player.GetWearable("darwins_danger_shield").AddAttribute("patient overheal penalty", 1.325, -1);
    }
});