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
        if (player.GetPlayerClass() != TF_CLASS_DEMOMAN)
            return false;
        local wearable = null;
        while (wearable = Entities.FindByClassname(wearable, "tf_wearable"))
            if (wearable.GetOwner() == player && WeaponIs(wearable, "any_demo_boots"))
                return true;
        return false;
    }

    function OnDamageDealt(victim, params)
    {
        if (params.damage_type & 128)
            SetPropFloat(player, "m_Shared.m_flChargeMeter", clampCeiling(100.0, GetPropFloat(player, "m_Shared.m_flChargeMeter") + 25.0))
    }
});