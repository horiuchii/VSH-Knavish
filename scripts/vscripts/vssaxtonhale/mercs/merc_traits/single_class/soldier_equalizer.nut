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
        return player.GetPlayerClass() == TF_CLASS_SOLDIER
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE), "equalizer");
    }

    function OnApply()
    {
        player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE).AddAttribute("single wep holster time increased", 2.0, -1);
    }

    function OnDamageTaken(victim, params)
    {
        if (IsBoss(params.attacker)
            && GetPropEntity(player, "m_hActiveWeapon") == player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE))
        {
            params.damage *= 0.7;
        }
    }
});