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

::clampCeiling <- function(valueA, valueB)
{
    if (valueA < valueB)
        return valueA;
    return valueB;
}

::clampFloor <- function(valueA, valueB)
{
    if (valueA > valueB)
        return valueA;
    return valueB;
}

::clamp <- function(value, min, max)
{
    if (value < min)
        return min;
    if (value > max)
        return max;
    return value;
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