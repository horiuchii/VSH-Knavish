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

::characterTraits <- {};
::emptyTickAlive <- null;

class CharacterTrait
{
    player = null;
    trait_team = TF_TEAM_ANY;

    function TryApply(player)
    {
        if (!IsValidPlayer(player))
            return null;

        this.player = player;
        if (!CanApply() || !CanReceiveTrait())
            return null;

        return ApplyTrait(player);
    }

    function ApplyTrait(player)
    {
        this.player = player; // For when TryApply is skipped

        characterTraits[player].push(this);

        OnApply();
        return this;
    }

    function CanApply() { return true; }
    function OnApply() { }
    function OnFrameTickAlive() { }
    function OnFrameTickAliveOrDead() { }
    function OnTickAlive(timeDelta) { }
    function OnTickAliveOrDead(timeDelta) { }
    function OnDamageDealt(victim, params) { }
    function OnDamageTaken(attacker, params) { }
    function OnKill(victim, params) { }
    function OnDeath(attacker, params) { }
    function OnHurtDealtEvent(victim, params) { }
    function OnDiscard() { }

    function CanReceiveTrait()
    {
        switch (trait_team)
        {
            case TF_TEAM_ANY: return true;
            case TF_TEAM_MERCS:
                {
                    return !IsBoss(player);
                }
            case TF_TEAM_BOSS:
                {
                    return IsBoss(player);
                }
        }

        return false;
    }

    function DoTick(timeDelta)
    {
        if (player.IsAlive())
            OnTickAlive(timeDelta);
        OnTickAliveOrDead(timeDelta);
    }

    function DoFrameTick()
    {
        if (player.IsAlive())
            OnFrameTickAlive();
        OnFrameTickAliveOrDead();
    }
}

::GetTraitByClass <- function(player, traitClass)
{
    foreach (trait in characterTraits[player])
    {
        if (trait instanceof traitClass)
            return trait;
    }

    return null;
}

AddListener("spawn", -1, function (player, params)
{
    DiscardTraits(player);
    characterTraits[player] <- [];

    foreach (mercTrait in mercTraitsLibrary)
    {
        try
        {
            local newTrait = mercTrait();
            newTrait.TryApply.call(newTrait, player);
        }
        catch(e) { throw e; }
    }

    foreach (sharedTrait in sharedTraitLibrary)
    {
        try
        {
            local newTrait = sharedTrait();
            newTrait.TryApply.call(newTrait, player);
        }
        catch(e) { throw e; }
    }
});

AddListener("tick_only_valid", 2, function (timeDelta)
{
    foreach (player in GetValidPlayers())
        if (player in characterTraits)
            foreach (characterTrait in characterTraits[player])
                try { characterTrait.DoTick.call(characterTrait, timeDelta); }
                catch(e) { throw e; }
});

AddListener("tick_frame", 2, function ()
{
    if (!IsValidRound())
        return;
    foreach (player in GetValidPlayers())
        if (player in characterTraits)
            foreach (characterTrait in characterTraits[player])
                try { characterTrait.DoFrameTick.call(characterTrait); }
                catch(e) { throw e; }
});

AddListener("disconnect", 2, function (player, params)
{
    DiscardTraits(player);
});

function DiscardTraits(player)
{
    if (player in characterTraits)
    {
        foreach (characterTrait in characterTraits[player])
            try { characterTrait.OnDiscard.call(characterTrait); }
            catch(e) { throw e; }
        delete characterTraits[player];
    }
}

AddListener("death", 2, function (attacker, victim, params)
{
    if (attacker in characterTraits && IsValidPlayer(attacker))
        foreach (characterTrait in characterTraits[attacker])
            try { characterTrait.OnKill.call(characterTrait, victim, params); }
            catch(e) { throw e; }

    if (victim in characterTraits)
        foreach (characterTrait in characterTraits[victim])
            try { characterTrait.OnDeath.call(characterTrait, attacker, params); }
            catch(e) { throw e; }
});

AddListener("damage_hook", 0, function (attacker, victim, params)
{
    if (attacker in characterTraits && IsValidPlayer(attacker))
        foreach (characterTrait in characterTraits[attacker])
            try { characterTrait.OnDamageDealt.call(characterTrait, victim, params); }
            catch(e) { throw e; }

    if (victim in characterTraits && victim.IsPlayer())
        foreach (characterTrait in characterTraits[victim])
            try { characterTrait.OnDamageTaken.call(characterTrait, attacker, params); }
            catch(e) { throw e; }
});

AddListener("player_hurt", 0, function (attacker, victim, params)
{
    if (attacker in characterTraits)
        foreach (characterTrait in characterTraits[attacker])
            try { characterTrait.OnHurtDealtEvent.call(characterTrait, victim, params); }
            catch(e) { throw e; }
});