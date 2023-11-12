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
        return player.GetPlayerClass() == TF_CLASS_SCOUT && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "backscatter");
    }

    function OnDamageDealt(victim, params)
    {
        local distance = victim.GetOrigin() - player.GetOrigin();

        if(distance.Length() > 512)
            return;

        local boss_forward = victim.EyeAngles().Forward();
        distance.z = 0.0;
        distance.Norm();

        if(distance.x * boss_forward.x + distance.y * boss_forward.y + distance.z * boss_forward.z > 0.259)
            params.damage_type += DMG_CRIT;
    }
});