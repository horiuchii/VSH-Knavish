
enum TeleportState
{
    NONE
    FADE_OUT
    FADE_IN
}

class TeleportTrait extends BossAbility
{
    cooldown = 1;
    meter = 0;
    mode = AbilityMode.COOLDOWN;
    inUse = false;
    state = TeleportState.NONE;
    teleTime = 0.0;
    fade_out_time = 1.0;
    fade_in_time = 0.5;
    futureTelePos = null;
    forceCrouch = false;

    function OnTickAlive(timeDelta)
    {
        base.OnTickAlive(timeDelta);

        switch (state)
        {
            case TeleportState.NONE:
                {
                    break;
                }
            case TeleportState.FADE_OUT:
                {
                    teleTime += timeDelta;

                    if (teleTime >= 0.0)
                    {
                        state = TeleportState.FADE_IN;
                        teleTime = -fade_in_time;

                        if (forceCrouch)
                        {
                            SetPropVector(boss, "m_vecMins", Vector(-24, -24, 0) * player.GetModelScale());
                            SetPropVector(boss, "m_vecMaxs", Vector(24, 24, 62) * player.GetModelScale());
                            SetPropBool(boss, "m_bDucked", true);
                            boss.AddFlag(FL_DUCKING);
                            forceCrouch = false;
                        }

                        boss.SetAbsOrigin(futureTelePos);
                        boss.AddFlag(FL_ONGROUND);
                        boss.SetGravity(1.0);
                    }
                    break;
                }
            case TeleportState.FADE_IN:
                {
                    teleTime += timeDelta;
                    if (teleTime >= 0.0)
                    {
                        state = TeleportState.NONE;
                        teleTime = 0.0;
                        boss.RemoveFlag(FL_ATCONTROLS);
                        boss.RemoveCond(TF_COND_IMMUNE_TO_PUSHBACK);
                        SetPropInt(boss, "m_nForceTauntCam", 0);
                    }
                    break;
                }
        }
    }

    function OnFrameTickAlive()
    {
        if (player.Get().CanUseAbilities())
        {
            if (state == TeleportState.NONE)
            {
                if (!meter)
                {
                    if (inUse)
                    {
                        Trace();
                        return;
                    }
                    else if (boss.WasButtonJustPressed(IN_ATTACK2))
                    {
                        inUse = true;
                        return;
                    }
                }
            }
        }
    }

    function Perform(finalPos)
    {
        SetCooldown();
        local vel = boss.GetAbsVelocity();
        vel.x *= 0.1;
        vel.y *= 0.1;
        vel.z *= 0.1;
        boss.SetGravity(0.1);
        boss.SetAbsVelocity(vel);

        boss.AddFlag(FL_ATCONTROLS);
        boss.AddCond(TF_COND_IMMUNE_TO_PUSHBACK);
        SetPropInt(boss, "m_nForceTauntCam", 1);
        inUse = false;
        teleTime = -fade_out_time;
        futureTelePos = finalPos;
        state = TeleportState.FADE_OUT;
        boss.AddCustomAttribute("no_attack", 1.0, fade_in_time + fade_out_time + 1.0);

        local portalPos = boss.GetOrigin();
        portalPos.z += 4.0;
        DispatchParticleEffect("halloween_boss_summon", portalPos, Vector(0.0, 0.0, 0.0));

        finalPos.z += 4.0;
        DispatchParticleEffect("halloween_boss_summon", finalPos, Vector(0.0, 0.0, 0.0));
    }

    function Trace()
    {
        local showtime = 0.1;
        local player = boss;

        local stairs = 60.0;
        local max_dist = 1200.0;
        local units_per_stair = max_dist / stairs;
        local min_valid_dist = 200.0;
        local plane_normal_reduction = 270.0;
        local max_plane_slope = 315.0;
        local min_plane_slope = 270.0;

        // Use crouching bounding box
        local hullmin = Vector(-24, -24, 0) * player.GetModelScale();
        local hullmax = Vector(24, 24, 62) * player.GetModelScale();
        local eyepos = player.EyePosition();
        local eyeang = player.EyeAngles();
        local fwd = eyeang.Forward();
        local end = eyepos + (fwd * max_dist);

        local eyeTrace = MakeTraceLineTable(eyepos, end);

        TraceLineFilter(eyeTrace);

        if (eyeTrace.fraction < min_valid_dist / max_dist)
        {
            if (!(player.GetButtons() & IN_ATTACK2))
            {
                inUse = false;
            }

            return;
        }

        // When directly hitting a valid surface
        if (eyeTrace.fraction < 1.0)
        {
            local planeForward = VectorAngles(eyeTrace.plane_normal);
            if (planeForward.x >= min_plane_slope && planeForward.x <= max_plane_slope)
            {
                local finalPos = DoFinalHullTrace(eyeTrace, hullmin, hullmax, planeForward.x - plane_normal_reduction);
                if (finalPos != null)
                {
                    // Teleport Player
                    DebugDrawBox(finalPos, hullmin, hullmax, 255, 255, 0, 255, showtime);
                    if (!(player.GetButtons() & IN_ATTACK2))
                    {
                        Perform(finalPos);
                    }
                    return;
                }
            }
        }

        // Check below the eyeTrace using stairs
        local rounded = floor(eyeTrace.fraction * max_dist / units_per_stair) * units_per_stair;
        while (rounded > min_valid_dist)
        {
            local ang = QAngle(90.0, 0.0, 0.0);
            local tail = eyepos + (fwd * rounded);
            local stairTrace = MakeTraceLineTable(tail, tail + (ang.Forward() * 125.0));

            TraceLineFilter(stairTrace);

            if (!("enthit" in stairTrace))
            {
                rounded -= units_per_stair;
                continue;
            }

            local planeForward = VectorAngles(stairTrace.plane_normal);
            if (planeForward.x < min_plane_slope || planeForward.x > max_plane_slope)
            {
                rounded -= units_per_stair;
                continue;
            }

            local finalPos = DoFinalHullTrace(stairTrace, hullmin, hullmax, planeForward.x - plane_normal_reduction);
            if (finalPos == null)
            {
                rounded -= units_per_stair;
                continue;
            }

            DebugDrawBox(finalPos, hullmin, hullmax, 255, 255, 0, 255, showtime);

            if (!(player.GetButtons() & IN_ATTACK2))
            {
                Perform(finalPos);
                break;
            }
            // Teleport Player
            // Destination Is Valid
            break;
        }

        if (!(player.GetButtons() & IN_ATTACK2))
        {
            inUse = false;
        }

        return;
    }

    function DoFinalHullTrace(lastTrace, hullmin, hullmax, slope_compensation)
    {
        local hullStart = lastTrace.pos;
        hullStart.z += slope_compensation;
        local hullTrace = MakeTraceHullTable(hullStart, lastTrace.endpos, hullmin, hullmax);
        TraceHullFilter(hullTrace);

        // There's no room
        if (hullTrace.fraction == 0.0)
        {
            return null;
        }

        local finalPos = hullTrace.endpos;
        finalPos.z += 0.03125;
        local finalHullTrace = MakeTraceHullTable(finalPos, finalPos, hullmin, hullmax);
        TraceHull(finalHullTrace);

        if (finalHullTrace.fraction != 1.0)
        {
            return null;
        }

        // Do one more hull trace with standing mins and maxs
        // If this fails then force the player to crouch upon teleporting
        local standing_min = Vector(-24, -24, 0) * player.GetModelScale();
        local standing_max = Vector(24, 24, 82) * player.GetModelScale();

        local standingHullTrace = MakeTraceHullTable(finalPos, finalPos, standing_min, standing_max);
        TraceHull(standingHullTrace);

        if (standingHullTrace.fraction <= 0.99)
        {
            forceCrouch = true;
        }

        return finalPos;
    }

    function MakeTraceLineTable(_start, _end)
    {
        local table =
        {
            start = _start
            end = _end
            mask = MASK_SHOT | MASK_PLAYERSOLID
            filter = function(entity)
            {
                local classname = entity.GetClassname();

                if (entity == worldspawn)
                    return TRACE_STOP;

                if (startswith(classname, "obj_"))
                    return TRACE_STOP;

                if (startswith(entity.GetClassname(), "prop_"))
                    return TRACE_STOP;

                if (startswith(entity.GetClassname(), "func_breakable"))
                    return TRACE_STOP;

                if (startswith(entity.GetClassname(), "func_door"))
                    return TRACE_STOP;

                if (startswith(entity.GetClassname(), "func_brush"))
                    return TRACE_STOP;

                if (startswith(classname, "proj_"))
                    return TRACE_CONTINUE;

                return TRACE_CONTINUE;
            }
        }

        return table;
    }

    function MakeTraceHullTable(_start, _end, _hullmin, _hullmax)
    {
        local table =
        {
            start = _start
            end = _end
            hullmin = _hullmin
            hullmax = _hullmax
            mask = MASK_SHOT | MASK_PLAYERSOLID
            filter = function(entity)
            {
                local classname = entity.GetClassname();

                if (entity == worldspawn)
                    return TRACE_STOP;

                if (entity.IsPlayer() && entity.GetTeam() != TF_TEAM_BLUE)
                    return TRACE_STOP;

                if (startswith(classname, "obj_"))
                    return TRACE_STOP;

                if (startswith(entity.GetClassname(), "prop_"))
                    return TRACE_STOP;

                if (startswith(classname, "proj_"))
                    return TRACE_CONTINUE;

                return TRACE_CONTINUE;
            }
        }

        return table;
    }

    function VectorAngles(fwd)
    {
        local ang = QAngle(0, 0, 0);
        local tmp;
        local yaw;
        local pitch;

		yaw = (atan2(fwd.y, fwd.x) * 180.0 / PI);
		if (yaw < 0)
			yaw += 360.0;

		tmp = sqrt( (fwd.x*fwd.x) + (fwd.y*fwd.y) );
		pitch = ( atan2(-fwd.z, tmp) * 180.0 / PI );
		if (pitch < 0)
			pitch += 360.0;

        ang.x = pitch;
        ang.y = yaw;
        ang.z = 0;

        return ang;
    }
}
::TeleportTrait <- TeleportTrait;