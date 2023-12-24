::playerType <- {};

CTFPlayer.Get <- function() { return playerType[this] };
CTFBot.Get <- CTFPlayer.Get;

CTFPlayer.Set <- function(type)
{
    if (!(this in playerType))
        playerType[this] <- {};

    playerType[this] = (type)(this);
    playerType[this].player = this;
};
CTFBot.Set <- CTFPlayer.Set;

class PlayerType extends CharacterTrait
{
    name = null;
    color = "0 0 0";

    function constructor(player)
    {
        this.player = player;
        InitHUDs();
    }

    function InitHUDs()
    {
        HUDIdentifiers[player].clear();
        HUDTable[player].clear();
        MenuHUD.AddHUD(player);
    }

    function GetHexColor()
    {
        return RGBToHex(StringToIntArray(color));
    }
}

class Mercenary extends PlayerType
{
    color = TF_TEAM_MERCS == TF_TEAM_RED ? "255 0 0" : "0 0 255";

    function InitHUDs()
    {
        base.InitHUDs();
        InspectHUD.AddHUD(player);
        MercenaryHUD.AddHUD(player, true);
    }
}
::Mercenary <- Mercenary;

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
        boss.ForceRespawn();
        RunWithDelay2(this, 0, OnCreationPre);
    }

    function OnCreationPre()
    {
        foreach (traitClass in traitLibrary[name])
            traitClass().ApplyTrait(boss);

        ClearPlayerItems(boss); //Clear items in case a trait regenerates them
    }

    function CanUseAbilities()
    {
        return !(IsInVSHMenu(boss) || (IsRoundOver() && GetWinningTeam() != TF_TEAM_BOSS));
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