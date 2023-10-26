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
        return player.GetPlayerClass() == TF_CLASS_DEMOMAN
			&& WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY), "scottish_resistance");
    }

	function OnApply()
	{
		player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY).AddAttribute("no crit boost", 1, -1);
	}

	function OnDamageDealt(victim, params)
	{
		if (params.weapon == player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY))
		{
			params.crit_type = 0;
			if (params.damage_type & DMG_ACID)
			{
				params.damage_type -= DMG_ACID;
			}
		}
	}
});

AddListener("tick_frame", 0, function()
{
    local ent = null
    while( ent = Entities.FindByClassname(ent, "tf_projectile_pipe_remote") )
    {
        if (GetPropInt(ent, "m_hLauncher") == null)
            continue;

        if (GetItemID(GetPropEntity(ent, "m_hLauncher")) == 130)
            SetPropBool(ent, "m_bCritical", false);
    }
});