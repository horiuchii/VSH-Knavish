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

class BuildingDamageRescaleTrait extends BossTrait
{
    function OnDamageDealt(victim, params)
    {
        if (victim == null || !startswith(victim.GetClassname(), "obj_"))
            return;

        local level = GetPropInt(victim, "m_iUpgradeLevel");

        switch(level)
        {
            case 1: params.damage *= 0.85; break; //dies in 1
            case 2: params.damage *= 0.5; break; //2
            case 3: params.damage *= 0.65; break; //2
        }

        if (GetPropInt(victim, "m_nShieldLevel") > 0)
        {
            switch(level)
            {
                case 1: params.damage *= 2; break; //dies in 2
                case 2: params.damage *= 2; break; //3
                case 3: params.damage *= 1.5; break; //4
            }
        }
    }
};