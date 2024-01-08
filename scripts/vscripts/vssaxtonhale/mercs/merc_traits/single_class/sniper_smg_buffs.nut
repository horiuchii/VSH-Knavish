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

mercTraitsLibrary.push(class extends MercenaryTrait
{
    function CanApply()
    {
        local weapon = player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY);
        return player.GetPlayerClass() == TF_CLASS_SNIPER
            && (WeaponIs(weapon, "smg") || WeaponIs(weapon, "cleaners_carbine"));
    }

    function OnApply()
    {
        local secondary = player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY);
        secondary.AddAttribute("damage bonus", 1.5, -1);
        secondary.AddAttribute("maxammo secondary increased", 1.33, -1);
        player.SetAmmo(secondary, 100);
    }

    function OnDamageDealt(victim, params)
    {
        if (victim.IsPlayer()
            && params.weapon == player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY)
            && GetPropInt(params.const_entity, "m_LastHitGroup") == HITGROUP_HEAD)
        {
            if (!(params.damage_type & DMG_CRIT))
            {
                params.damage_type += DMG_CRIT;
            }

            // Prevents weird rounding where the min damage fall off is only one less than max (min: 29 | max: 30)
            if (params.damage_type & DMG_USEDISTANCEMOD)
            {
                params.damage_type -= DMG_USEDISTANCEMOD;
            }
        }
    }
});