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

class FreezeSetupTrait extends BossTrait
{
    bHasRoundStarted = false;

    function OnFrameTickAlive()
    {
        if(bHasRoundStarted || !API_GetBool("freeze_boss_setup"))
            return;

        if(IsRoundSetup())
        {
            SetPropBool(boss, "m_bAllowMoveDuringTaunt", true);
            boss.AddFlag(FL_ATCONTROLS);
        }
        else
        {
            SetPropBool(boss, "m_bAllowMoveDuringTaunt", false);
            boss.RemoveFlag(FL_ATCONTROLS);
            bHasRoundStarted = true;
        }
    }
}
