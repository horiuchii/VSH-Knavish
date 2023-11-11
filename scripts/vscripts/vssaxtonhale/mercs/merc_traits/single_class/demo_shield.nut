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

PrecacheArbitrarySound("vsh_sfx.shield_break");
PrecacheArbitrarySound("demo.shield")
PrecacheArbitrarySound("demo.shield_lowhp")

characterTraitsLibrary.push(class extends CharacterTrait
{
    wasDestroyed = false;
    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_DEMOMAN && player.HasWearable("any_demo_shield");
    }

    function OnDamageTaken(attacker, params)
    {
        if (wasDestroyed || !IsValidBoss(attacker) || player.InCond(TF_COND_INVULNERABLE))
            return;

        if ((params.damage_type == DMG_CRUSH || params.damage_type == DMG_BLAST) && params.damage < player.GetHealth())
            return;

        wasDestroyed = true;
        params.damage = 0;

        local deltaVector = player.GetCenter() - attacker.GetCenter();
        deltaVector.z = 0;
        deltaVector.Norm();
        player.Yeet(deltaVector * 900 + Vector(0, 0, 300));

        EmitSoundOn("vsh_sfx.shield_break", player);

        if (params.damage_type == DMG_BLAST)
            EmitPlayerVODelayed(player, "shield_lowhp", 1);
        else
            EmitPlayerVODelayed(player, "shield", 1);
    }
});