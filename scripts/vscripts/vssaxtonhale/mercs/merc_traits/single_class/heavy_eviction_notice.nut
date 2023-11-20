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

const healthDrainPerSecond = 7;
const ticksPerSecond = 67;

characterTraitsLibrary.push(class extends CharacterTrait
{
    degenTicks = 0;

    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_HEAVY
			&& WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE), "eviction_notice");
    }

    function OnApply()
    {
        player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE).AddAttribute("mod_maxhealth_drain_rate", 0.0, -1);
    }
});