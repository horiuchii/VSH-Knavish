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
        return player.GetPlayerClass() == TF_CLASS_SPY
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "ambassador");
    }

    function OnDamageDealt(victim, params)
    {
        local primary = player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY);

        if (primary == params.weapon
            && GetPropFloat(params.weapon, "m_flLastFireTime") + 1.0 < Time()
            && GetPropInt(params.const_entity, "m_LastHitGroup") == HITGROUP_HEAD)
        {
            params.damage_type = params.damage_type | DMG_CRIT | DMG_USE_HITLOCATIONS;

            if (params.damage_type & DMG_USEDISTANCEMOD)
            {
                params.damage_type -= DMG_USEDISTANCEMOD;
            }

            params.damage = 50.0;
        }
    }

    function OnTickAlive(timeDelta)
    {
        local ent = 0;
        while(Entities.FindByClassname(ent, "tf_taunt_prop"))
        {
            printl("Found Glow");
        }
    }
});