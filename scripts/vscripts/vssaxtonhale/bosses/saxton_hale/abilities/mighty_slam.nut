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

AddGenericScriptSoundToQueue("vsh_sfx.boss_slam_impact");
AddGenericScriptSoundToQueue("vsh_sfx.slam_ready");

class MightySlamTrait extends BossTrait
{
    meter = 0;
    inUse = false;
    lastFrameDownVelocity = 0;
	TRAIT_COOLDOWN = 15;

    function OnApply()
    {
        if (!(player in hudAbilityInstances))
            hudAbilityInstances[player] <- [];
        hudAbilityInstances[player].push(this);
    }

    function OnTickAlive(timeDelta)
    {
        if (!player.Get().CanUseAbilities())
            return;

        if (meter < 0)
        {
            meter += timeDelta;
            if (meter > 0)
            {
                EmitSoundOnClient("vsh_sfx.slam_ready", boss);
                EmitSoundOnClient("TFPlayer.ReCharged", boss);
                meter = 0;
            }
        }

        if (!boss.IsOnGround() && (boss.GetFlags() & FL_DUCKING))
        {
            Weightdown();
        }
        else if (inUse && !(boss.GetFlags() & FL_DUCKING))
        {
            inUse = false;
            SetItemId(boss.GetActiveWeapon(), 5);
            boss.SetGravity(1);
            BossPlayViewModelAnim(boss, "f_idle");
        }
        else if (inUse && boss.IsOnGround())
        {
            inUse = false;
            SetItemId(boss.GetActiveWeapon(), 5);
            boss.SetGravity(1);
            if (meter >= 0 && lastFrameDownVelocity < -300)
                Perform();
            else
                BossPlayViewModelAnim(boss, "f_idle");
        }
    }

    function Weightdown()
    {
        local origin = player.GetOrigin();
        local fraction = TraceLine(origin, origin + Vector(0, 0, -150), null);
        if (fraction < 1)
            return;

        inUse = true;
        boss.SetGravity(3);
        lastFrameDownVelocity = boss.GetAbsVelocity().z;
        if (meter >= 0)
        {
            BossPlayViewModelAnim(boss, "vsh_slam_fall");
            boss.AddCustomAttribute("no_attack", 1, 0.25);
            SetItemId(boss.GetActiveWeapon(), 264); //Frying Pan
        }
    }

    function Perform()
    {
        DispatchParticleEffect("hammer_impact_button", boss.GetOrigin() + Vector(0,0,20), Vector(0,0,0));
        EmitSoundOn("vsh_sfx.boss_slam_impact", boss);
        lastFrameDownVelocity = 0;
        meter = -TRAIT_COOLDOWN;

        local bossLocal = boss;
        BossPlayViewModelAnim(boss, "vsh_slam_land");
        local weapon = boss.GetActiveWeapon();
        SetItemId(weapon, 444); //Mantreads

        local radius = 500;

        CreateAoE(boss.GetCenter(), radius, true,
            function (target, deltaVector, distance, InLOS, ZDiff)
            {
                local damage = target.GetMaxHealth() * (1 - distance / radius);

                switch(CookieUtil.Get(boss, "difficulty"))
                {
                    case DIFFICULTY.NORMAL: damage -= (damage * 0.2); break;
                    case DIFFICULTY.HARD: damage -= (damage * 0.4); break;
                    case DIFFICULTY.EXTREME: damage -= (damage * 0.6); break;
                    case DIFFICULTY.IMPOSSIBLE: damage -= (damage * 0.8); break;
                    default: break;
                }

                if(!InLOS)
                {
                    if(ZDiff < 151)
                        damage *= 0.5;
                    else
                        return;
                }

                if (!target.IsPlayer())
                    damage *= 2;

                if (damage <= 30 && target.GetHealth() <= 30)
                    return; // We don't want to have people on low health die because Hale just Slammed a mile away.

                target.TakeDamageEx(
                    bossLocal,
                    bossLocal,
                    weapon,
                    deltaVector * 1250,
                    bossLocal.GetOrigin(),
                    damage,
                    DMG_BLAST);
            }
            function (target, deltaVector, distance, InLOS, ZDiff)
            {
                local pushForce = distance < 100 ? 1 : 100 / distance;

                if(!InLOS)
                {
                    if(ZDiff < 151)
                        pushForce *= 0.5;
                    else
                        return;
                }

                deltaVector.x = deltaVector.x * 1250 * pushForce;
                deltaVector.y = deltaVector.y * 1250 * pushForce;
                deltaVector.z = 950 * pushForce;
                target.Yeet(deltaVector);
            });

        SetItemId(weapon, 5);
        ScreenShake(boss.GetCenter(), 10, 2.5, 1, 1000, 0, true);
    }
};