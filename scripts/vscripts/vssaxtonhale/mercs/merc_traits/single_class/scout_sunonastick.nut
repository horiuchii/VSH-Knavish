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
        return player.GetPlayerClass() == TF_CLASS_SCOUT
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE), "sunonastick");
    }

    function OnApply()
    {
        player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE).AddAttribute("damage bonus", 1.5, -1);
    }

    function OnDamageDealt(victim, params)
    {
        if (victim.IsPlayer()
            && params.weapon == player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE)
            && (params.damage_type & DMG_CLUB)
            && victim.InCond(TF_COND_BURNING))
			params.damage *= 2.0;
    }
});