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
		if (player.GetPlayerClass() != TF_CLASS_PYRO || !player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY))
			return false;
		
		local classname = player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY).GetClassname();
		return classname == "tf_weapon_flamethrower" || classname == "tf_weapon_rocketlauncher_fireball";
    }

    function OnApply()
    {
		local primary = player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY);
        primary.AddAttribute("airblast vertical pushback scale", 0.75, -1);
        primary.AddAttribute("damage bonus", 1.25, -1);
    }
});