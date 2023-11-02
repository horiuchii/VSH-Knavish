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

characterTraitsClasses.push(class extends CharacterTrait
{
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SPY;
    }

    function OnDamageDealt(victim, params)
    {
        if (!(WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "ambassador") || params.weapon == HitboxDetector))
        {
            return;
        }

        local primary = player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY);
        local weapon = params.weapon;

        //Make sure weapon is an Ambassador
        if (primary == weapon && GetPropFloat(primary, "m_flLastFireTime") + 1.0 > Time())
            return;

        if (HitboxDetectorAttacking)
        {
            HitboxDetectorHitgroup = GetPropInt(params.const_entity, "m_LastHitGroup");
            params.damage = 0.0;
            params.early_out = true;
            return;
        }

        if (primary == weapon)
        {
            local attacker = params.attacker;
            if (attacker)
            {
                HitboxDetectorHitgroup = -1;
                HitboxDetectorAttacking = true;
                HitboxDetector.SetTeam(attacker.GetTeam());
                SetPropFloat(HitboxDetector, "m_flNextPrimaryAttack", 0);
                SetPropEntity(HitboxDetector, "m_hOwner", attacker);
                HitboxDetector.PrimaryAttack();
                HitboxDetectorAttacking = false;
                attacker.StopSound("Weapon_SniperRifle.Single");

                if (HitboxDetectorHitgroup == HITGROUP_HEAD)
                {
                    params.damage_type = params.damage_type | DMG_ACID | DMG_AIRBOAT;

                    if (params.damage_type & DMG_SLOWBURN)
                        params.damage_type -= DMG_SLOWBURN;

                    params.damage = 50.0;
                }
            }
        }
    }
});