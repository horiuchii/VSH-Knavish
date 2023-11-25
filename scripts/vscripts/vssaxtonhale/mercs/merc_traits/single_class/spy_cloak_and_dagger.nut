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
    cloaking = false;

    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SPY
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.INVIS_WATCH), "cloak_and_dagger");
    }

    function OnApply()
    {
        local invis_watch = player.GetWeaponBySlot(TF_WEAPONSLOTS.INVIS_WATCH);
        invis_watch.AddAttribute("cloak regen rate increased", 1.0, -1);
        invis_watch.AddAttribute("mult cloak meter consume rate", 2.5, -1);
        invis_watch.AddAttribute("set cloak is movement based", 0.0, -1);
    }

    function OnTickAlive(timeDelta)
    {
        if(player.InCond(TF_COND_STEALTHED)
            && GetPropFloat(player, "m_Shared.m_flInvisChangeCompleteTime") < Time())
        {
            player.AddCondEx(TF_COND_SPEED_BOOST, 0.15, null);
        }
    }

    function OnFrameTickAlive()
    {
        local inStealth = player.InCond(TF_COND_STEALTHED)
        local invisTime = GetPropFloat(player, "m_Shared.m_flInvisChangeCompleteTime");
        if (inStealth)
        {
            // Cloaking
            if (!cloaking && invisTime > Time())
            {
                cloaking = true;
                SetPropFloat(player, "m_Shared.m_flInvisChangeCompleteTime", ((invisTime - Time()) * 0.5) + Time());
            }
        }
        else
        {
            // Decloaking
            if (cloaking && invisTime > Time())
            {
                cloaking = false;
                SetPropFloat(player, "m_Shared.m_flInvisChangeCompleteTime", ((invisTime - Time()) * 0.5) + Time());
                SetPropFloat(player, "m_Shared.m_flStealthNextChangeTime", ((invisTime - Time()) * 0.5) + Time());
                SetPropFloat(player, "m_Shared.m_flStealthNoAttackExpire", ((invisTime - Time()) * 0.5) + Time());
            }
        }

        if (inStealth && invisTime < Time())
        {
            player.AddCondEx(TF_COND_SPEED_BOOST, 0.15, null);
        }
    }
});