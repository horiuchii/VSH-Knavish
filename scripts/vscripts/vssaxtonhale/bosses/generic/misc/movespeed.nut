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

class MovespeedTrait extends BossTrait
{
    function OnTickAlive(timeDelta)
    {
		//clamp speed to prevent going too slow or above 480
        local speed = clamp(1.4 + (boss.GetMaxHealth() - boss.GetHealth()) * 1.2 / boss.GetMaxHealth(), 1.4, 2.08657)
        boss.RemoveCond(TF_COND_CRITBOOSTED_PUMPKIN);
        boss.AddCustomAttribute("move speed bonus", speed, -1);
    }
};