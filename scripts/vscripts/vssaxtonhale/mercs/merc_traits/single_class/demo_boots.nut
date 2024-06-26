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
        return player.GetPlayerClass() == TF_CLASS_DEMOMAN && player.HasWearable("any_demo_boots");
    }

	function OnApply()
	{
        local wearable = player.GetWearable("any_demo_boots");
        wearable.AddAttribute("move speed bonus shield required", 1.0, -1);
        wearable.AddAttribute("move speed bonus", 1.10, -1);
	}

    function OnDamageDealt(victim, params)
    {
        if (victim.IsPlayer() && params.damage_type & DMG_CLUB)
            SetPropFloat(player, "m_Shared.m_flChargeMeter", clampCeiling(100.0, GetPropFloat(player, "m_Shared.m_flChargeMeter") + 25.0))
    }
});