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
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_MEDIC
			&& WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE), "vitasaw");
    }
	
	function OnApply()
    {
		local melee = player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE);
		melee.AddAttribute("add uber charge on hit", 0.15, -1);
		melee.AddAttribute("ubercharge_preserved_on_spawn_max", 0.0, -1);
    }
});
