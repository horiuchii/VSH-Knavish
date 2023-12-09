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

PrecacheSound("weapons/mantreads.wav");
PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = "mini_fireworks" });

mercTraitsLibrary.push(class extends MercenaryTrait
{
    lastFallVelocity = 0.0;
    bounceHeight = 650.0;
    requiredFallVelocity = 400.0;
    damagePercent = 0.05;
    baseDamage = 300.0;

    function CanApply()
    {
        return true;
    }

    function DoFrameTick()
    {
        local groundEntity = GetPropEntity(player, "m_hGroundEntity");
        if (IsBoss(groundEntity) && lastFallVelocity > requiredFallVelocity)
        {
            groundEntity.TakeDamageEx(player, player, player.GetActiveWeapon(), Vector(0,0,0), Vector(0,0,0), groundEntity.GetHealth() * damagePercent + baseDamage, DMG_CRUSH | DMG_PREVENT_PHYSICS_FORCE);
            local particleOrigin = Vector(groundEntity.GetOrigin().x, groundEntity.GetOrigin().y, player.GetOrigin().z);
            DispatchParticleEffect("mini_fireworks", particleOrigin, Vector(-90.0, 0.0, 0.0));
            EmitAmbientSoundOn("weapons/mantreads.wav", 1.0, 75, 100, groundEntity);
            local velocity = GetPropVector(player, "m_vecAbsVelocity");

            RunWithDelay2(this, -1, function ()
            {
                velocity.z = bounceHeight;
                SetPropVector(player, "m_vecAbsVelocity", velocity);
            });

            FireListeners("goomba", player);
        }

        lastFallVelocity = GetPropFloat(player, "m_Local.m_flFallVelocity");
    }

    function OnDamageTaken(attacker, params)
    {
        if (!(params.damage_type & DMG_FALL))
            return;

        local groundEntity = GetPropEntity(player, "m_hGroundEntity");
        if (IsBoss(groundEntity)
            && lastFallVelocity > requiredFallVelocity
            && !player.HasWearable("mantreads")
            && !(WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY), "thermal_thruster") && player.InCond(TF_COND_ROCKETPACK))
            )
        {
            params.damage = 0.0;
        }
    }
});