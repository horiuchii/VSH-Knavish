class TeleportTrait extends BossAbility
{
    cooldown = 1;
    meter = 0;
    mode = AbilityMode.COOLDOWN;
    inUse = false;

    function OnFrameTickAlive()
    {
        if (!player.Get().CanUseAbilities() || meter != 0.0)
            return;

        if (inUse)
        {
            Trace();
            return;
        }

        if (boss.WasButtonJustPressed(IN_ATTACK2))
        {
            inUse = true;
        }
    }

    function Perform(finalPos)
    {
        SetCooldown();
        boss.SetAbsOrigin(finalPos);
        boss.SetAbsVelocity(Vector(0.0, 0.0, 0.0));
        inUse = false;
    }

    function Trace()
    {
        local showtime = 0.1;
        local player = boss;

        local stairs = 60.0;
        local max_dist = 1000.0;
        local units_per_stair = max_dist / stairs;
        local min_valid_dist = 200.0;


        local hullmin = player.GetBoundingMins();
        local hullmax = player.GetBoundingMaxs();
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
            if (planeForward.x > 270.0 && planeForward.x < 310.0)
            {
                local finalPos = DoFinalHullTrace(eyeTrace, hullmin, hullmax);
                if (finalPos != null)
                {
                    // Teleport Player
                    DebugDrawBox(finalPos, hullmin, hullmax, 255, 255, 0, 255, showtime);
                    if (!(player.GetButtons() & IN_ATTACK2))
                    {
                        Perform(finalPos);
                        return;
                    }
                }
            }
        }

        // Check below the eyeTrace using stairs
        local rounded = floor(eyeTrace.fraction * max_dist / units_per_stair) * units_per_stair;
        while (rounded > min_valid_dist)
        {
            local ang = QAngle(90.0, 0.0, 0.0);
            local tail = eyepos + (fwd * rounded);
            local stairTrace = MakeTraceLineTable(tail, tail + (ang.Forward() * 75.0));

            TraceLineFilter(stairTrace);

            if (!("enthit" in stairTrace))
            {
                rounded -= units_per_stair;
                continue;
            }

            local planeForward = VectorAngles(stairTrace.plane_normal);
            if (planeForward.x < 270.0 || planeForward.x > 310.0)
            {
                rounded -= units_per_stair;
                continue;
            }

            local finalPos = DoFinalHullTrace(stairTrace, hullmin, hullmax);
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

    function DoFinalHullTrace(lastTrace, hullmin, hullmax)
    {
        local slope_compensation = 40.0;
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

        return finalPos;
    }

    function TracePrint(text)
    {
        ClientPrint(null, HUD_PRINTTALK, text.tostring());
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

        if (fwd.y == 0 && fwd.x == 0)
        {
            yaw = 0;
            if (fwd.z > 0)
                pitch = 270.0;
            else
                pitch = 90.0;
        }
        else
        {
            yaw = (atan2(fwd.y, fwd.x) * 180.0 / PI);
            if (yaw < 0)
                yaw += 360.0;

            tmp = sqrt( (fwd.x*fwd.x) + (fwd.y*fwd.y) );
            pitch = ( atan2(-fwd.z, tmp) * 180.0 / PI );
            if (pitch < 0)
                pitch += 360.0;
        }

        ang.x = pitch;
        ang.y = yaw;
        ang.z = 0;

        return ang;
    }
}
::TeleportTrait <- TeleportTrait;