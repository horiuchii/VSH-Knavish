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

::tf_glow_ent <- null;

class GlowTrait extends BossTrait
{
    glow_time_end = 0;
    alpha = 0.0;

    function SetGlowTime(length)
    {
        glow_time_end = Time() + length;
    }

    function SetGlowFlash(amount)
    {
        for (local i = 0; i < amount; i++)
        {
            RunWithDelay2(this, i, function ()
            {
                SetGlowTime(0.5);
            })
        }
    }

    function OnApply()
    {
        if(tf_glow_ent == null || tf_glow_ent_vm == null)
        {
            boss.KeyValueFromString("targetname", "client_" + boss.entindex().tostring());
            tf_glow_ent = SpawnEntityFromTable("tf_glow",
            {
                target = "client_" + boss.entindex().tostring(),
                GlowColor = "0 0 0 0",
                Mode = 0,
                StartDisabled = 1
            })
            tf_glow_ent.DispatchSpawn();
            EntFireByHandle(tf_glow_ent, "SetParent", "!activator", -1, boss, null);
            boss.KeyValueFromString("targetname", "");
        }
        EntFireByHandle(tf_glow_ent, "Enable", "", -1, boss, boss);

        SetGlowFlash(5);
    }

    function OnFrameTickAlive()
    {
        local alpha_change = 7.727272;

        alpha = clamp(alpha + (glow_time_end > Time() ? alpha_change : -alpha_change), 0, 255);

        EntFireByHandle(tf_glow_ent, "SetGlowColor", GetBossColor(player) + " " + alpha.tointeger(), -1, boss, boss);
    }
}
