::playerType <- {};

class PlayerType extends CharacterTrait
{
    name = null;
    color = "0 0 0";
}

class Mercenary extends PlayerType
{
    color = TF_TEAM_MERCS == TF_TEAM_RED ? "255 0 0" : "0 0 255";
}

class Special extends PlayerType
{
    color = "0 255 0";
}

class Boss extends PlayerType
{
    boss = null;
    traits = null;
    startingHealth = 0;
    trait_team = TF_TEAM_BOSS;

    function OnApply()
    {
        boss = player;
        player.ForceRespawn();
        RunWithDelay2(this, 0, OnApply0Delay);
    }

    function OnApply0Delay()
    {
        foreach (traitClass in traitLibrary[name])
            traitClass().ApplyTrait(player);

        ClearPlayerItems(player); //Clear items in case a trait regenerates them
    }
}

::Boss <- Boss;
::Mercenary <- Mercenary;
::Special <- Special;

::CTFPlayer.IsOfType <- function(type)
{
    return playerType[this] instanceof type;
}

::CTFPlayer.GetTypeColor <- function()
{
    return playerType[this].color;
}

::CTFPlayer.GetTypeName <- function()
{
    return playerType[this].name;
}

::CTFBot.IsOfType <- CTFPlayer.IsOfType;
::CTFBot.GetTypeColor <- CTFPlayer.GetTypeColor;
::CTFBot.GetTypeName <- CTFPlayer.GetTypeName;