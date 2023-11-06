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
        return player.GetPlayerClass() == TF_CLASS_MEDIC
			&& WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "blutsauger");
    }

	function OnApply()
    {
		local primary = player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY);
		primary.AddAttribute("health drain medic", 0.0, -1);
		primary.AddAttribute("heal on hit for rapidfire", 0.0, -1);
		primary.AddAttribute("add uber charge on hit", 0.030001, -1);
    }

	function OnDamageDealt(victim, params)
    {
        if (params.damage_type & DMG_BULLET)
		{
			player.SetHealth(clampCeiling(player.GetHealth() + 5, player.GetMaxOverheal()));

			SendGlobalGameEvent("player_healonhit",
			{
				entindex = player.entindex(),
				amount = 5,
			});
		}
    }
});