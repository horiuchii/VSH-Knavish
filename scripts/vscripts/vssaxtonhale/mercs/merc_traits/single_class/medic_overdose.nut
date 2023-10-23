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
        return player.GetPlayerClass() == TF_CLASS_MEDIC;
    }
	
	function OnApply()
    {
		local primary = player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY);
		if (WeaponIs(primary, "overdose"))
		{
			primary.AddAttribute("provide on active", 1.0, -1);
			primary.AddAttribute("move speed bonus", 1.1, -1);
			primary.AddAttribute("add uber charge on hit", 0.020001, -1);
		}
    }
});