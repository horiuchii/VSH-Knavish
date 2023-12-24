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

PrecacheScriptSound("vsh_sfx.hale_charge");
PrecacheScriptSound("vsh_sfx.hale_dash");
PrecacheScriptSound("DemoCharge.HitFlesh");

PrecacheScriptSound("saxton_hale.charge_a")
PrecacheScriptSound("saxton_hale.charge_b")
PrecacheScriptSound("saxton_hale.charge_c")
PrecacheScriptSound("saxton_hale.dash_a")
PrecacheScriptSound("saxton_hale.dash_b")
PrecacheScriptSound("saxton_hale.dash_c")

::saxton_dash_effect_model_path <- "models/player/items/vsh_dash_effect.mdl"
PrecacheModel(saxton_dash_effect_model_path);

class SweepingChargeTrait extends BossTrait
{
	TRAIT_COOLDOWN = 10;
    meter = 0;
    isCurrentlyDashing = false;
    lastDenySoundPlay = 0;
    haleLastFrameDownVelocity = 0;
    voiceTime = 0;
    voiceRNG = "a";
    bashedByHale = [];
    windUpChargeTime = 0;
    midAirWindUpOverload = 0;
    triggerCatapult = null;

    function OnApply()
    {
        triggerCatapult = SpawnEntityFromTable("trigger_catapult", {
            origin = "0 0 0",
            spawnflags = 1,
            StartDisabled = 1,
            IsEnabled = false,
            physicsSpeed = 300,
            playerSpeed = 300,
            launchDirection = "-90 270 0",
            filtername = "filter_team_boss"
        })

        triggerCatapult.KeyValueFromInt("solid", 2)
        triggerCatapult.KeyValueFromString("mins", "-64 -64 -96")
        triggerCatapult.KeyValueFromString("maxs", "64 64 96")
    }

    function OnTickAlive(timeDelta)
    {
        if (isCurrentlyDashing)
            return;

        if (meter < 0)
        {
            meter += timeDelta;
            if (meter > 0)
            {
                EmitSoundOnClient("TFPlayer.ReCharged", boss);
                meter = 0;
            }
            else
                return;
        }
    }

    function OnFrameTickAlive()
    {
        if (API_GetBool("freeze_boss_setup") && IsRoundSetup())
            return;

        if (isCurrentlyDashing)
        {
            TickDash();
            return;
        }

        local buttons = boss.GetButtons();
        if (player.Get().CanUseAbilities() && (boss.IsUsingActionSlot() || buttons & IN_RELOAD))
        {
            if (meter < 0 || boss.InCond(TF_COND_TAUNTING))
            {
                if(lastDenySoundPlay + 0.5 < Time())
                {
                    EmitSoundOnClient("WeaponMedigun.NoTarget", boss);
                    lastDenySoundPlay = Time()
                }

                return;
            }

            WindUp();
        }
        else if (windUpChargeTime >= 0.01)
            Perform();
    }

    function WindUp()
    {
        windUpChargeTime += 0.01;
        if (windUpChargeTime >= 1.0)
        {
            if (!boss.IsOnGround())
            {
                midAirWindUpOverload += 0.01;
                if (midAirWindUpOverload >= 1)
                {
                    Perform();
                    return;
                }
            }
            else
                midAirWindUpOverload = 0;
        }

        if (!boss.IsOnGround())
            SetItemId(boss.GetActiveWeapon(), 42); //Sandvich

        BossPlayViewModelAnim(boss, "vsh_dash_windup");

        if (Time() > voiceTime)
        {
            voiceRNG = ["a","b","c"][RandomInt(0,2)];
            voiceTime = Time() + 999;
            EmitPlayerVO(boss, "charge_"+voiceRNG);
            EmitSoundOn("vsh_sfx.hale_charge", boss);
            vsh_vscript.Hale_SetBlueArm(boss, true);
        }

        boss.SetAbsVelocity(Vector(0,0,0));
        PreventAttack(boss, 0.5);
        boss.AddCustomAttribute("move speed penalty", 0.25, 0.5);

        if (!boss.InCond(TF_COND_AIMING))
            boss.AddCond(TF_COND_AIMING);
    }

    function Perform()
    {
        DoEntFire("windup_vfx", "Kill", "", 0, null, null);
        SetItemId(boss.GetActiveWeapon(), 5);
        isCurrentlyDashing = true;
        bashedByHale = [];
        boss.RemoveCond(TF_COND_AIMING);
        boss.AddCondEx(TF_COND_HALLOWEEN_KART_DASH, 0.1, boss);

        local haleForwardDirection = boss.EyeAngles().Forward();
        local forwardOffset = haleForwardDirection * 60;

        EntFireByHandle(triggerCatapult, "Enable", "", 0, boss, boss);

        BossPlayViewModelAnim(boss, "vsh_dash_loop");

        local chargeDuration = clampCeiling(1.0, windUpChargeTime) / 1.66 + 0.4;
        windUpChargeTime = 0;

        local forward = boss.EyeAngles();
        local pitch = boss.IsOnGround() ? forward.Pitch() - 10 : forward.Pitch();
        forward = QAngle(pitch, forward.Yaw(), 0);
        boss.Yeet(forward.Forward() * 800 * chargeDuration)
        boss.SetGravity(0.3);
        voiceTime = 0;
        midAirWindUpOverload = 0;

        boss.AddCondEx(TF_COND_SHIELD_CHARGE, 100.0, null);
        boss.AddCondEx(TF_COND_KNOCKED_INTO_AIR, chargeDuration, null);
        PreventAttack(boss, chargeDuration + 0.5);
        EmitPlayerVO(boss, "dash_"+voiceRNG);
        EmitSoundOn("vsh_sfx.hale_dash", boss);
        RunWithDelay2(this, chargeDuration, Finish);

        local dashDome = boss.CreateCustomWearable(null, saxton_dash_effect_model_path);
        EntFireByHandle(dashDome, "Kill", "", chargeDuration, null, null);
    }

    function Finish()
    {
        vsh_vscript.Hale_SetBlueArm(boss, false);
        BossPlayViewModelAnim(boss, "vsh_dash_end");
        boss.RemoveCond(TF_COND_SHIELD_CHARGE);
        boss.AddCondEx(TF_COND_GRAPPLINGHOOK_LATCHED, 0.1, boss);
        meter = -TRAIT_COOLDOWN;
        isCurrentlyDashing = false;
        boss.SetGravity(1);
        EntFireByHandle(triggerCatapult, "Disable", "", 0, boss, boss)
        PreventAttack(boss, 0.5);
    }

    function TickDash()
    {
        local haleForwardDirection = boss.EyeAngles().Forward();
        local forwardOffset = haleForwardDirection * 60;

        SetPropInt(boss, "m_Shared.m_bJumping", 1);
        SetPropFloat(boss, "m_Shared.m_flJumpTime", 1);
        SetPropEntity(boss, "m_hGroundEntity", null);
        local force = 1400;
        boss.SetAbsVelocity(haleForwardDirection*force)
        triggerCatapult.SetAbsOrigin(boss.GetCenter());

        CreateAoEAABB(boss.GetCenter() + forwardOffset, Vector(-65, -65, -30), Vector(65, 65, 130),
            function (target, deltaVector, distance) {
                if (bashedByHale.find(target) != null)
                    return;
                local dmg = target.GetMaxHealth() * 0.55;
                if (startswith(target.GetClassname(), "obj_"))
                {
                    //dmg *= 0.2;
                    boss.SetAbsVelocity(Vector(0,0,0))
                }
                else
                    bashedByHale.push(target);
                target.TakeDamageEx(
                    boss,
                    boss,
                    boss.GetActiveWeapon(),
                    deltaVector * 1250,
                    boss.GetOrigin(),
                    dmg,
                    DMG_BURN);
            }
            function (target, deltaVector, distance) {
                if (bashedByHale.find(target) != null)
                    return;
                EmitSoundOn("DemoCharge.HitFlesh", target);
                deltaVector.Norm();
                deltaVector.x = deltaVector.x * 1250
                deltaVector.y = deltaVector.y * 1250
                deltaVector.z = 450;
                target.Yeet(deltaVector);
            });
    }

    function OnDamageTaken(attacker, params)
    {
        if (meter > 0.1)
            params.damage *= 0.5;
    }
};
::SweepingChargeTrait <- SweepingChargeTrait;