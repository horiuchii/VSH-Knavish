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

characterTraitsLibrary.push(class extends CharacterTrait
{
    function CanApply()
    {
        return player.GetPlayerClass() != TF_CLASS_SPY;
    }

    function OnApply()
    {
        local weapon = player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE);
        if (weapon != null)
            weapon.AddAttribute("single wep deploy time decreased", 0.75, -1);
    }

    function OnTickAlive(timeDelta)
    {
        local melee = player.GetActiveWeapon();
        if (melee == null || melee.GetSlot() != TF_WEAPONSLOTS.MELEE)
            return;

        if (!WeaponIs(melee, "disciplinary_action") && !WeaponIs(melee, "any_sword"))
        {
            local myCenter = player.GetCenter();
            foreach (boss in GetAliveBossPlayers())
            {
                local distanceToBoss = (boss.GetCenter() - myCenter).Length()
                if (distanceToBoss < 350)
                {
                    melee.AddAttribute("melee range multiplier", 1.6, -1);
                    break;
                }
                else
                    melee.AddAttribute("melee range multiplier", 1.0, 1);
           }
        }
    }

    function OnDamageDealt(victim, params)
    {
        if (IsBoss(victim)
            && (params.damage_type & DMG_CLUB)
            && player.InCond(TF_COND_CRITBOOSTED_ON_KILL))
        {
            params.damage *= 1.2; //Hale has Crit Resistance. Restoring melee damage back.

            if (!victim.InCond(TF_COND_TAUNTING))
            {
                local deltaVector = victim.GetOrigin() - player.GetOrigin();
                deltaVector.z = 0;
                if (deltaVector.Norm() < 180)
                {
                    local force = 300.0;
                    if (WeaponIs(params.weapon, "any_sword"))
                    {
                        force = 100.0;
                    }
                    if (WeaponIs(params.weapon, "ubersaw")
                        || WeaponIs(params.weapon, "eviction_notice"))
                    {
                        force = 200.0;
                    }
                    victim.Yeet(deltaVector * force + Vector(0.0, 0.0, force));
                }
            }
        }
    }
});