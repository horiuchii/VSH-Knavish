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
        return player.GetPlayerClass() == TF_CLASS_SCOUT
            && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "shortstop");
    }

    function OnApply()
    {
        player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY).AddAttribute("damage bonus", 1.25, -1);
        player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY).AddAttribute("scattergun knockback mult", 10.0, -1);
    }

    function OnDamageDealt(victim, params)
    {
        if (params.weapon == player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY)
            && params.damage_type & DMG_NEVERGIB
            && params.damage_type & DMG_BLAST_SURFACE)
        {
            local deltaVec = victim.GetOrigin() - params.attacker.GetOrigin();
            deltaVec.Norm();
            victim.Yeet(deltaVec * 200.0);
        }
    }
});