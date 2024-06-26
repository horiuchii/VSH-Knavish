class WallClimbTrait extends BossAbility
{
    uses_left = 0;
    max_uses = 5;
    mode = AbilityMode.LIMITED_USE;
    last_active_wep = null;
    justWallClimbed = false;
    maxSpeedMult = 40.0;

    ignoreWallClimb =
    [
        "player",
        "tf_bot",
        "obj_sentrygun",
        "obj_dispenser",
        "obj_teleporter"
    ]

    function OnTickAlive(timeDelta)
    {
        if (boss.IsOnGround())
            uses_left = 0;
    }

    function DoFrameTick()
    {
        local absVel = boss.GetAbsVelocity();
        local hVel = sqrt(absVel.x * absVel.x + absVel.y * absVel.y);
        local melee = boss.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE);

        if (melee == null)
            return;

        // when melee smacks, m_iNextMeleeCrit is 0
        if (GetPropInt(boss, "m_Shared.m_iNextMeleeCrit") == 0)
        {
            // checking last weapon will prevent shit where switching from banner to melee will cause the fake wall climb
            last_active_wep = boss.GetActiveWeapon();

            // when switching away from melee, m_iNextMeleeCrit will also be 0 so check for that case
            if (boss.GetActiveWeapon() == melee && last_active_wep == melee)
            {
                if(justWallClimbed)
                {
                    // continue smack detection
                    SetPropInt(boss, "m_Shared.m_iNextMeleeCrit", -2);
                    return -1;
                }

                local eyepos = boss.Weapon_ShootPosition();
                local bounds_scale = GetBoundsMultiplier(melee);
                local hit_valid = false;

                local traceTable =
                {
                    player = boss
                    start = eyepos
                    end = eyepos + (boss.EyeAngles().Forward() * GetSwingLength(melee))
                    hullmin = Vector(-18,-18,-18) * bounds_scale
                    hullmax = Vector(18,18,18) * bounds_scale
                    mask = (CONTENTS_SOLID|CONTENTS_MONSTER|CONTENTS_HITBOX)
                    filter = function(entity)
                    {
                        if(IsValidBuilding(entity) || (IsValidPlayer(entity) && entity.GetTeam() != player.GetTeam()))
                        {
                            hit_valid = false;
                            return TRACE_STOP;
                        }

                        if ((IsValidPlayer(entity) && entity == player)
                            || startswith(entity.GetClassname(), "tf_proj"))
                        {
                            return TRACE_CONTINUE;
                        }

                        hit_valid = true;
                        return TRACE_CONTINUE;
                    }
                }

                TraceHullFilter(traceTable);

                if(!traceTable.hit || !hit_valid)
                {
                    // continue smack detection
                    SetPropInt(boss, "m_Shared.m_iNextMeleeCrit", -2);
                    return;
                }

                MeleeClimb_Perform(boss);
            }

            // continue smack detection
            SetPropInt(boss, "m_Shared.m_iNextMeleeCrit", -2);
            last_active_wep = boss.GetActiveWeapon();
        }
    }

    function OnDamageDealt(victim, params)
    {
        if (params.attacker.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE) == params.weapon
            && params.damage_type & DMG_CLUB)
        {
            if (params.const_entity == worldspawn) //wall climb off of the static world
            {
                Perform(params.attacker);
                return;
            }
            else
            {
                // Wall climb off of the rest of the world. worldspawn handled separately for performance reasons
                if (ignoreWallClimb.find(params.const_entity.GetClassname()) == null)
                {
                    Perform(params.attacker);
                    return;
                }
            }
        }
    }

    function Perform(player)
    {
        if (uses_left == max_uses)
        {
            return;
        }

        uses_left++;
        justWallClimbed = true;

        RunWithDelay2(this, -1, function()
        {
            justWallClimbed = false;
        })

        SetPropEntity(player, "m_hGroundEntity", null);
        player.RemoveFlag(FL_ONGROUND);

        local newVelocity = player.GetAbsVelocity();
        newVelocity.z = 600.0;

        if (boss.Get().rawin("WallClimb_Perform"))
        {
            boss.Get().WallClimb_Perform(newVelocity);
        }

        local maxSpeed = GetPropFloat(boss, "m_flMaxspeed");
        local absVel = boss.GetAbsVelocity();
        local currHVel = sqrt(absVel.x * absVel.x + absVel.y * absVel.y);
        local velFwd = QAngle(0.0, atan2(absVel.y, absVel.x) * 180.0 / PI, 0.0).Forward();
        DebugDrawLine(boss.GetOrigin(), boss.GetOrigin() + Vector(velFwd.x, velFwd.y, velFwd.z) * 200.0, 255, 0, 0, false, 5.0);
        local maxClimbBoost = 600.0;

        // Ex: 540 < 600;
        if (currHVel < maxClimbBoost)
        {
            local newHVel = currHVel * 1.15;

            // Ex: (540 * 1.15 = 621) > 600
            if (newHVel > maxClimbBoost)
            {
                velFwd *= maxClimbBoost - currHVel;
            }
            else
            {
                // Ex: 320 * 1.15 = 368
                velFwd *= currHVel * 0.15;
            }
        }
        else
        {
            velFwd = Vector(0.0, 0.0, 0.0);
        }


        player.SetAbsVelocity(newVelocity + Vector(velFwd.x, velFwd.y, velFwd.z));
    }
}
::WallClimbTrait <- WallClimbTrait;