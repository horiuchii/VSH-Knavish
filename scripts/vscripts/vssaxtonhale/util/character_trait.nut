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
::characterTraitsTable <- {};
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
        characterTraitsTable[player][this.getclass()] <- this;

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
    function OnStunPlayer(stunner, victim, params) { }
    function OnDiscard() { }

    function CanReceiveTrait()
    {
        switch (trait_team)
        {
            case TF_TEAM_ANY: return true;
            case TF_TEAM_MERCS:
                {
                    return IsMerc(player);
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
    return traitClass in characterTraitsTable[player] ? characterTraitsTable[player][traitClass] : null;
}

AddListener("spawn", -1, function (player, params)
{
    DiscardTraits(player);
    characterTraits[player] <- [];
    characterTraitsTable[player] <- {};

    if (player.Get() instanceof Mercenary)
    {
        foreach (mercTrait in mercTraitsLibrary)
        {
            try
            {
                local newTrait = mercTrait();
                newTrait.TryApply.call(newTrait, player);
            }
            catch(e) { throw e; }
        }
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
    {
        CallCharacterTraitListener(player, "DoTick", timeDelta);
    }
});

AddListener("tick_frame", 0, function ()
{
    if (!IsValidRound())
    {
        return;
    }

    foreach (player in GetValidPlayers())
    {
        CallCharacterTraitListener(player, "DoFrameTick");
    }
});

AddListener("disconnect", 2, function (player, params)
{
    DiscardTraits(player);
});

function DiscardTraits(player)
{
    CallCharacterTraitListener(player, "OnDiscard");
    delete characterTraits[player];
    delete characterTraitsTable[player];
}

AddListener("death", 2, function (attacker, victim, params)
{
    if (IsValidPlayer(attacker))
    {
        CallCharacterTraitListener(attacker, "OnKill", victim, params);
    }

    CallCharacterTraitListener(victim, "OnDeath", attacker, params);
});

AddListener("damage_hook", 0, function (attacker, victim, params)
{
    CallCharacterTraitListener(attacker, "OnDamageDealt", victim, params);

    if (victim.IsPlayer())
    {
        CallCharacterTraitListener(victim, "OnDamageTaken", attacker, params);
    }
});

AddListener("player_hurt", 0, function (attacker, victim, params)
{
    CallCharacterTraitListener(attacker, "OnHurtDealtEvent", victim, params);
});

AddListener("stun_player", 0, function (stunner, victim, params)
{
    if (IsValidPlayer(stunner))
    {
        CallCharacterTraitListener(stunner, "OnStunPlayer", stunner, victim, params);
    }
});

function CallCharacterTraitListener(player, func_name, ...)
{
    foreach (characterTrait in characterTraits[player])
    {
        local array = [characterTrait];
        foreach (i, val in vargv)
        {
            array.append(val);
        }

        try
        {
            characterTrait.rawget(func_name).acall(array);
        }
        catch(e) { throw e; }
    }
}