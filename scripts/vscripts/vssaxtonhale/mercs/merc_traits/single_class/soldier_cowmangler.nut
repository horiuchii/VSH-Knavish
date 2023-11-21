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
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SOLDIER
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "cowmangler");
    }

    function OnDamageDealt(victim, params)
    {
        if (params.damage_custom == TF_DMG_CUSTOM_PLASMA_CHARGED)
        {
            params.damage *= 1.65;
        }
    }
});

AddListener("tick_always", 0, function (timeDelta)
{
    local ent = MAX_PLAYERS + 1;
    while (ent = Entities.FindByClassname(ent, "tf_projectile_energy_ball"))
    {
        if (!("checked" in ent.GetScriptScope()))
        {
            ent.ValidateScriptScope();
            ent.GetScriptScope().checked <- true;
            local launcher = GetPropEntity(ent, "m_hLauncher");
            if (launcher == null)
                return;

            if (GetPropBool(ent, "m_bChargedShot"))
            {
                ent.SetAbsVelocity(ent.GetAbsAngles().Forward() * 2100.0);
            }
        }
    }
});

