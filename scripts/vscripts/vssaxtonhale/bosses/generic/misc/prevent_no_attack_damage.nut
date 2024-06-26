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

class PreventNoAttackDamageClass extends BossTrait
{
    damage_cooldown_end = 0;

    function OnDamageDealt(victim, params)
    {
        if(params.damage_type & DMG_SLASH)
            return;

        if(params.damage_type & DMG_CRUSH)
            return;

        if(params.damage_type & DMG_BLAST)
            return;

        if(damage_cooldown_end > Time())
        {
            params.damage = 0;
            params.early_out = true;
        }
    }
};

::PreventNoAttackDamage <- PreventNoAttackDamageClass