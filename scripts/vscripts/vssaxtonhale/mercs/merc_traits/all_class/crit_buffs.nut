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
    function OnTickAlive(timeDelta)
    {
        local mercsAlive = GetAliveMercCount();
        local active = GetPropEntity(player, "m_hActiveWeapon");

        if (active == null)
            return;

        if (!CanReceiveBuffs(active))
            return;

        if (CanReceivePassiveCrits(active, player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE) == active))
        {
            player.AddCondEx(TF_COND_CRITBOOSTED_ON_KILL, 0.2, player);
        }


        if (mercsAlive <= 3)
        {
            if (!IsDowngradedWeapon(active))
            {
                player.AddCondEx(TF_COND_OFFENSEBUFF, 0.2, player);
            }
        }

        if (mercsAlive == 1)    //No, it's not "else if", because engie + sentry combo benefits from both crits and minicrits
        {
            if (!IsDowngradedWeapon(active))
            {
                player.AddCondEx(TF_COND_CRITBOOSTED_ON_KILL, 0.2, player);
            }
            else
            {
                player.AddCondEx(TF_COND_OFFENSEBUFF, 0.2, player);
            }
        }

        if (CanReceivePassiveMinicrits(active))
        {
            player.AddCondEx(TF_COND_OFFENSEBUFF, 0.2, player);
        }
    }

    function IsDowngradedWeapon(active)
    {
        return WeaponIs(active, "bushwaka")
            || WeaponIs(active, "sunonastick")
            || WeaponIs(active, "axtinguisher");
    }

    function CanReceivePassiveMinicrits(active)
    {
        local classname = active.GetClassname();
        return classname == "tf_weapon_pistol"
            || classname == "tf_weapon_pistol_scout"
            || classname == "tf_weapon_handgun_scout_secondary";
    }

    function CanReceivePassiveCrits(active, isMelee)
    {
        if (isMelee)
        {
            return !(WeaponIs(active, "sunonastick") || WeaponIs(active, "axtinguisher") || WeaponIs(active, "bushwaka"));
        }

        // Add separate weapon checks here ~ Brad

        return false;
    }

    function CanReceiveBuffs(active)
    {
        return !WeaponIs(active, "market_gardener")
            && !WeaponIs(active, "holiday_punch");
    }
});