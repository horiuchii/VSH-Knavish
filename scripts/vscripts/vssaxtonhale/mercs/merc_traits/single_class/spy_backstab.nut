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

AddVoiceLineScriptSoundToQueue("stabbed")

mercTraitsLibrary.push(class extends MercenaryTrait
{
    bDisallowCloak = false;
    iCloakToSet = 0.0;

    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SPY;
    }

    function OnTickAlive(timeDelta)
    {
        if(bDisallowCloak)
        {
            player.SetSpyCloakMeter(0.01);
        }
    }

    function OnDamageDealt(victim, params)
    {
        //Le backstabe
        if (params.damage_custom == TF_DMG_CUSTOM_BACKSTAB)
        {
            params.damage = vsh_vscript.CalcStabDamage(victim) / 2.5; //Crit compensation

            local do_stab_stun = true;

            if (WeaponIs(params.weapon, "kunai"))
            {
                player.SetHealth(clampCeiling(270, player.GetHealth() + 180));
            }
            else if (WeaponIs(params.weapon, "big_earner"))
            {
                player.AddCondEx(TF_COND_SPEED_BOOST, 3, player);
                player.SetSpyCloakMeter(clampFloor(100, player.GetSpyCloakMeter() + 30));
                do_stab_stun = false;
            }
            else if (WeaponIs(params.weapon, "your_eternal_reward") || WeaponIs(params.weapon, "wanga_prick"))
            {
                RunWithDelay("YERDisguise(activator)", player, 0.1);
            }

            if (WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "diamondback"))
                AddPropInt(player, "m_Shared.m_iRevengeCrits", 2);

            if(do_stab_stun)
            {
                SetPropFloat(params.weapon, "m_flNextPrimaryAttack", Time() + 2.0);
                SetPropFloat(player, "m_flNextAttack", Time() + 2.0);

                bDisallowCloak = true;
                iCloakToSet = player.GetSpyCloakMeter();
                RunWithDelay2(this, 1.9, function()
                {
                    bDisallowCloak = false;
                    player.SetSpyCloakMeter(iCloakToSet);
                });
            }

            EmitSoundOn("Player.Spy_Shield_Break", victim);
            EmitSoundOn("Player.Spy_Shield_Break", victim);
            FireListeners("backstab", player);
            if (victim.GetHealth() > params.damage * 2.5)
                PlayAnnouncerVO(victim, "stabbed");
        }
    }
});

function CalcStabDamage(victim)
{
    return clampFloor(500, GetPerPlayerDamageQuota(victim));
}

function GetPerPlayerDamageQuota(victim)
{
    if (!(victim in playerType))
        return 0;
    return startMercCount > 0 ? playerType[victim].startingHealth / startMercCount : 500;
}

function YERDisguise(player)
{
    //todo this is kinda buggy. no proper solution yet
    local teammate = null;
    for (local i = 1; i <= MAX_PLAYERS; i++)
    {
        teammate = PlayerInstanceFromIndex(i);
        if (teammate != player && IsMercValidAndAlive(teammate))
        {
            SetPropEntity(player, "m_Shared.m_hDisguiseTarget", teammate);
            SetPropInt(player, "m_Shared.m_nDisguiseTeam", teammate.GetTeam());
            SetPropInt(player, "m_Shared.m_nDisguiseClass", teammate.GetPlayerClass());
            SetPropInt(player, "m_Shared.m_nDisguiseHealth", teammate.GetHealth());
            SetPropInt(player, "m_Shared.m_nMaskClass", teammate.GetPlayerClass());
            player.AddCond(TF_COND_DISGUISED);
            return;
        }
    }
}