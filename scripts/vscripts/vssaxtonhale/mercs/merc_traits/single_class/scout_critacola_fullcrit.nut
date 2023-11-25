mercTraitsLibrary.push(class extends MercenaryTrait
{
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SCOUT;
    }

    function OnTickAlive(timeDelta)
    {
        if(player.InCond(TF_COND_ENERGY_BUFF))
            player.AddCondEx(TF_COND_CRITBOOSTED_BONUS_TIME, 0.15, null)
    }
});