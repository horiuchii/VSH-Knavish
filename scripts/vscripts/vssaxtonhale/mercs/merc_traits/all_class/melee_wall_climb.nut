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

::hitStreak <- {};
::justWallClimbed <- {};
ignoreWallClimb <- [
    "player",
    "tf_bot",
    "obj_sentrygun",
    "obj_dispenser",
    "obj_teleporter"
]

function MeleeWallClimb_Hit(params)
{
    if (IsMercValidAndAlive(params.attacker))
        MeleeClimb_Perform(params.attacker);
}

function MeleeWallClimb_Check(params)
{
    return ignoreWallClimb.find(params.const_entity.GetClassname()) == null;
}

AddListener("tick_always", 0, function (timeDelta)
{
    foreach (player in GetAliveMercs())
        if ((player.GetFlags() & FL_ONGROUND))
            hitStreak[player] <- 0;
});

::MeleeClimb_Perform <- function(player, quickFixLink = false)
{
    justWallClimbed[player] <- true;

    RunWithDelay2(this, -1, function()
    {
        justWallClimbed[player] <- false;
    })

    local hits = (player in hitStreak ? hitStreak[player] : 0) + 1;
    local launchVelocity = hits == 1 ? 600 : hits == 2 ? 450 : hits <= 4 ? 400 : 200;
    hitStreak[player] <- hits;

    SetPropEntity(player, "m_hGroundEntity", null);
    player.RemoveFlag(FL_ONGROUND);

    local newVelocity = player.GetAbsVelocity();
    if (hits == 2)
    {
        newVelocity.x /= 2;
        newVelocity.y /= 2;
    }

    switch (player.GetPlayerClass())
    {
        case TF_CLASS_PYRO:
            {
                if (WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE), "homewrecker"))
                {
                    launchVelocity *= 1.10;
                }

                break;
            }
        case TF_CLASS_MEDIC:
            {
                if (WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE), "solemnvow"))
                {
                    launchVelocity *= 1.10;
                }

                break;
            }
        case TF_CLASS_SNIPER:
            {
                launchVelocity *= 1.25;
                break;
            }
    }

    newVelocity.z = launchVelocity > 430 ? launchVelocity : launchVelocity + newVelocity.z;
    player.SetAbsVelocity(newVelocity);
    FireListeners("wall_climb", player, hits, quickFixLink);

    if (!quickFixLink)
        foreach (otherPlayer in GetAliveMercs())
        {
            if (otherPlayer.GetPlayerClass() != TF_CLASS_MEDIC)
                return;
            local medigun = otherPlayer.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY);
            if (!WeaponIs(medigun,"quick_fix"))
                return;
            local target = GetPropEntity(medigun, "m_hHealingTarget");
            if (target == player)
                return MeleeClimb_Perform(otherPlayer, true);
        }
}

::LastActiveWeapon <- {};

::CheckMeleeSmack <- function()
{
	local player = self.GetOwner();

	// when melee smacks, m_iNextMeleeCrit is 0
	if (GetPropInt(player, "m_Shared.m_iNextMeleeCrit") == 0)
	{
        // checking last weapon will prevent shit where switching from banner to melee will cause the fake wall climb
        if(!(player in LastActiveWeapon))
            LastActiveWeapon[player] <- player.GetActiveWeapon();

		// when switching away from melee, m_iNextMeleeCrit will also be 0 so check for that case
		if (player.GetActiveWeapon() == self && LastActiveWeapon[player] == self)
		{
            local docheck = player in justWallClimbed ? justWallClimbed[player] : false;

            if(docheck)
            {
                // continue smack detection
		        SetPropInt(player, "m_Shared.m_iNextMeleeCrit", -2);
                return -1;
            }

            local eyepos = player.EyePosition();
            local bounds_scale = GetBoundsMultiplier(self);
            local hit_enemy = false;

            traceTable <-
            {
                start = eyepos
                end = eyepos + (player.EyeAngles().Forward() * GetSwingLength(self))
                hullmin = Vector(-18,-18,-18) * bounds_scale
                hullmax = Vector(18,18,18) * bounds_scale
                mask = (CONTENTS_SOLID|CONTENTS_MONSTER|CONTENTS_HITBOX)
                filter = function(entity)
                {
                    if(IsValidBuilding(entity) || (IsValidPlayer(entity) && entity.GetTeam() != player.GetTeam()))
                    {
                        hit_enemy = true;
                        return TRACE_STOP;
                    }

                    return TRACE_CONTINUE;
                }
            }

            TraceHullFilter(traceTable);

            if(!traceTable.hit || hit_enemy)
            {
                // continue smack detection
		        SetPropInt(player, "m_Shared.m_iNextMeleeCrit", -2);
                return -1;
            }

            MeleeClimb_Perform(player);
		}

		// continue smack detection
		SetPropInt(player, "m_Shared.m_iNextMeleeCrit", -2);
        LastActiveWeapon[player] <- player.GetActiveWeapon();
	}

	return -1;
}

AddListener("spawn", 15, function (player, params)
{
    if (player.GetTeam() != TF_TEAM_MERC)
        return;

    local weapon = player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE);
    if (weapon != null)
    {
        SetPropInt(player, "m_Shared.m_iNextMeleeCrit", -2);
        AddThinkToEnt(weapon, "CheckMeleeSmack");
    }
});