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

::CreateAoE <- function(center, radius, bDoLOSCheck, applyDamageFunc, applyPushFunc)
{
    foreach(target in GetAliveMercs())
    {
        local deltaVector = target.GetCenter() - center;
        local distance = deltaVector.Norm();
        if (distance > radius)
            continue;
        local ZDiff = target.GetCenter().z - center.z;

        local InLOS = true;
        if(bDoLOSCheck)
        {
            local trace_table = {start = center, end = target.GetCenter(), mask = MASK_SOLID_BRUSHONLY};
            TraceLineEx(trace_table);
            InLOS = !trace_table.hit;
        }

        applyPushFunc(target, deltaVector, distance, InLOS, ZDiff);
        applyDamageFunc(target, deltaVector, distance, InLOS, ZDiff);
    }

    local target = null;
    while (target = Entities.FindByClassname(target, "obj_*"))
    {
        local deltaVector = target.GetCenter() - center;
        local distance = deltaVector.Norm();
        if (distance > radius)
            continue;
        local ZDiff = target.GetCenter().z - center.z;

        local InLOS = true;
        if(bDoLOSCheck)
        {
            local trace_table = {start = center, end = target.GetCenter(), mask = MASK_SOLID_BRUSHONLY};
            TraceLineEx(trace_table);
            InLOS = !trace_table.hit;
        }

        applyDamageFunc(target, deltaVector, distance, InLOS, ZDiff);
    }
}

::CreateAoEAABB <- function(center, min, max, applyDamageFunc, applyPushFunc)
{
    local min = center + min;
    local max = center + max;
    foreach(target in GetAliveMercs())
    {
        local targetCenter = target.GetCenter();
        if (targetCenter.x >= min.x
            && targetCenter.y >= min.y
            && targetCenter.z >= min.z
            && targetCenter.x <= max.x
            && targetCenter.y <= max.y
            && targetCenter.z <= max.z)
            {
                local deltaVector = targetCenter - center;
                local distance = deltaVector.Norm();
                applyPushFunc(target, deltaVector, distance);
                applyDamageFunc(target, deltaVector, distance);
            }
    }

    local target = null;
    while (target = Entities.FindByClassname(target, "obj_*"))
    {
        local targetCenter = target.GetCenter();
        if (targetCenter.x >= min.x
            && targetCenter.y >= min.y
            && targetCenter.z >= min.z
            && targetCenter.x <= max.x
            && targetCenter.y <= max.y
            && targetCenter.z <= max.z)
            {
                local deltaVector = targetCenter - center;
                local distance = deltaVector.Norm();
                applyDamageFunc(target, deltaVector, distance);
            }
    }
}

::IsInRange <- function(entity, target, distance, bDoLOSCheck = false, traceTable = null)
{
    local deltaVector = target.GetCenter() - entity.GetCenter();
    local deltaDist = deltaVector.Norm();
    if (deltaDist > distance)
        return false;

    if (bDoLOSCheck)
    {
        TraceLineEx(traceTable);
        return traceTable.fraction > 0.99;
    }

    return true;
}

::clampCeiling <- function(A, B)
{
    return (A < B) ? A : B;
}

::clampFloor <- function(A, B)
{
    return (A > B) ? A : B;
}

::clamp <- function(value, min, max)
{
    if (value < min)
        return min;
    if (value > max)
        return max;
    return value;
}

::FormatTime <- function(input_time)
{
    local Hrs = (input_time / 3600);
    local Min = ((input_time - (Hrs * 3600)) / 60).tointeger();
    local Sec = input_time - (Hrs * 3600) - (Min * 60).tointeger();

    if(Hrs < 10) {Hrs = "0" + Hrs;}
    if(Min < 10) {Min = "0" + Min;}
    if(Sec < 10) {Sec = "0" + Sec;}

    return (Hrs + "h " + Min + "m " + Sec + "s").tostring();
}

::RGBToHex <- function(rgb)
{
    return format("%02X%02X%02X", rgb[0], rgb[1], rgb[2]);
}

::RGBAToHex <- function(rgba)
{
    return format("%02X%02X%02X%02X", rgba[0], rgba[1], rgba[2], rgba[3]);
}

::StringToIntArray <- function(str)
{
    local arr = split(str, " ");
    foreach (e, v in arr)
    {
        arr[e] = v.tointeger();
    }

    return arr;
}

::AddCommaSeperator <- function(number)
{
    local number_string = number.tostring();
    local number_length = number_string.len();
    local num_commas = (number_length - 1) / 3;

    local result = "";
    for (local i = 0; i < number_length; ++i)
    {
        result += number_string[i].tochar();

        if((number_length - i - 1) % 3 == 0 && i != number_length - 1)
            result += ",";
    }

    return result;
}

::SetPersistentVar <- function(name, value)
{
    local persistentVars = tf_gamerules.GetScriptScope();
    persistentVars[name] <- value;
}

::GetPersistentVar <- function(name, defValue = null)
{
    local persistentVars = tf_gamerules.GetScriptScope();
    return name in persistentVars ? persistentVars[name] : defValue;
}

::RunWithDelay <- function(func, activator, delay)
{
    EntFireByHandle(vsh_vscript_entity, "RunScriptCode", func, delay, activator, activator);
}

::RunWithDelay2 <- function (scope, delay, func, ...)
{
    local name = UniqueString();
    vsh_vscript[name] <- function()
    {
        try {
            func.acall([scope].extend(vargv))
        }
        catch (e) {
            throw e;
        }

        delete vsh_vscript[name];
    }
    RunWithDelay(name + "()", null, delay);
}

function CSimpleCallChainer::Call(...)
{
	if ( chain.len() )
	{
		local i;
		local args = [];
		if ( vargv.len() > 0 )
		{
			args.push( scope );
			for ( i = 0; i < vargv.len(); i++ )
			{
				args.push( vargv[i] );
			}
		}
		for ( i = chain.len() - 1; i >= 0; i -= 1 )
		{
			local func = chain[i];
			local result;
			if ( !args.len() )
			{
				result = func.call( scope );
			}
			else
			{
				result = func.acall( scope, args );
			}
			if ( result != null && !result )
				return false;
		}
	}
}
