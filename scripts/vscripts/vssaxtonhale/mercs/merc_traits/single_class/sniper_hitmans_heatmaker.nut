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

mercTraitsLibrary.push(class extends CharacterTrait
{
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_SNIPER
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "hitmans_heatmaker");
    }

    function OnDamageDealt(victim, params)
    {
        if (IsBoss(victim) && params.weapon == player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY))
        {
            local glowTrait = GetTraitByClass(victim, GlowTrait);
            if (glowTrait != null)
            {
                local glow_length = clamp(GetPropFloat(params.weapon, "m_flChargedDamage") / 30 + 1.0, 3, 6);
                glowTrait.SetGlowTime(glow_length);
                FireListeners("hitmans_glow", player, victim, glow_length);
            }
        }
    }
});