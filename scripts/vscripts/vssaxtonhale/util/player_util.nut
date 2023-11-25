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

::CTFPlayer.IsAlive <- function()
{
    return GetPropInt(this, "m_lifeState") == LIFE_STATE.ALIVE;
}

::CTFPlayer.IsDead <- function()
{
    return GetPropInt(this, "m_lifeState") != LIFE_STATE.ALIVE;
}

::CTFPlayer.IsOnGround <- function()
{
    return this.GetFlags() & FL_ONGROUND;
}

::CTFPlayer.Yeet <- function(vector)
{
    SetPropEntity(this, "m_hGroundEntity", null);
    this.ApplyAbsVelocityImpulse(vector);
    this.RemoveFlag(FL_ONGROUND);
}

::CTFBot.SwitchTeam <- function(team)
{
    this.ForceChangeTeam(team, true);
    SetPropInt(this, "m_iTeamNum", team);
}

::CTFPlayer.SwitchTeam <- function(team)
{
    SetPropInt(this, "m_bIsCoaching", 1);
    this.ForceChangeTeam(team, true);
    SetPropInt(this, "m_bIsCoaching", 0);
}

::CTFPlayer.GetMaxOverheal <- function()
{
    local overheal = this.GetMaxHealth() * 1.5;
    return overheal - (overheal % 5.0);
}

::CTFPlayer.NetName <- function()
{
    return GetPropString(this, "m_szNetName");
}

// Shared with CTFBot
::CTFBot.IsAlive <- CTFPlayer.IsAlive;
::CTFBot.IsDead <- CTFPlayer.IsDead;
::CTFBot.IsOnGround <- CTFPlayer.IsOnGround;
::CTFBot.Yeet <- CTFPlayer.Yeet;
::CTFBot.GetMaxOverheal <- CTFPlayer.GetMaxOverheal;
::CTFBot.NetName <- CTFPlayer.NetName;

::IsValidClient <- function(player)
{
    try
    {
        return player != null && player.IsValid() && player.IsPlayer();
    }
    catch(e)
    {
        return false;
    }
}

::IsValidPlayer <- function(player)
{
    try
    {
        return player != null && player.IsValid() && player.IsPlayer() && player.GetTeam() > 1;
    }
    catch(e)
    {
        return false;
    }
}

::IsValidPlayerOrBuilding <- function(entity)
{
    try
    {
        return entity != null
            && entity.IsValid()
            && entity.GetTeam() > 1
            && (entity.IsPlayer() || startswith(entity.GetClassname(), "obj_"));
    }
    catch(e)
    {
        return false;
    }
}

::IsValidBuilding <- function(building)
{
    try
    {
        return building != null
            && building.IsValid()
            && startswith(building.GetClassname(), "obj_")
            && building.GetTeam() > 1;
    }
    catch(e)
    {
        return false;
    }
}

::GetPlayerFromParams <- function(params, key = "userid")
{
    if (!(key in params))
        return null;
    local player = GetPlayerFromUserID(params[key]);
    if (IsValidPlayer(player))
        return player;
    return null;
}

::PlaySoundForAll <- function(soundScript)
{
    for (local i = 1; i <= MAX_PLAYERS; i++)
    {
        local player = PlayerInstanceFromIndex(i);
        if (IsValidPlayer(player))
            EmitSoundOnClient(soundScript, player);
    }
}

::PlaySoundForPlayer <- function(player, sound)
{
    PrecacheSound(sound);
    EmitSoundEx({sound_name = sound, entity = player, filter_type = RECIPIENT_FILTER_SINGLE_PLAYER});
}

::SwitchPlayerTeam <- function(player, team)
{
    if (IsValidPlayer(player))
    {
        player.SwitchTeam(team);
        if (!IsBoss(player) && IsRoundSetup())
        {
            player.ForceRegenerateAndRespawn();
            local ammoPack = null;
            while (ammoPack = Entities.FindByClassname(ammoPack, "tf_ammo_pack"))
            {
                if (ammoPack.GetOwner() == player)
                {
                    ammoPack.Kill();
                    return;
                }
            }
        }
    }
}