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
        return player.GetPlayerClass() == TF_CLASS_SPY
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.INVIS_WATCH), "cloak_and_dagger");
    }

    function OnApply()
    {
        local invis_watch = player.GetWeaponBySlot(TF_WEAPONSLOTS.INVIS_WATCH);
        invis_watch.AddAttribute("cloak consume rate increased", 1.15, -1);
        invis_watch.AddAttribute("mult decloak rate", 0.45, -1);
    }

    function OnTickAlive(timeDelta)
    {
        if(player.InCond(TF_COND_STEALTHED))
        {
            if(player.GetSpyCloakMeter() == 0)
            {
                player.RemoveCondEx(TF_COND_STEALTHED, true);
                return;
            }

            player.AddCondEx(TF_COND_SPEED_BOOST, 0.15, null);
        }
    }
});