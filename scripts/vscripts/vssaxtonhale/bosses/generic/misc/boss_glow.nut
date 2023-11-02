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

class GlowTrait extends BossTrait
{
    name = "Glow Trait";

    glow_ent = null;
    glow_color = "0 0 0";
    glow_time_end = 0;
    glow_alpha = 0.0;

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
        if(glow_ent == null)
        {
            boss.KeyValueFromString("targetname", "client_" + boss.entindex().tostring());
            glow_ent = SpawnEntityFromTable("tf_glow",
            {
                target = "client_" + boss.entindex().tostring(),
                GlowColor = "0 0 0 0",
                Mode = 0,
                StartDisabled = 1
            })
            glow_ent.DispatchSpawn();
            EntFireByHandle(glow_ent, "SetParent", "!activator", -1, boss, null);
            boss.KeyValueFromString("targetname", "");
        }
        EntFireByHandle(glow_ent, "Enable", "", -1, boss, boss);

        SetGlowFlash(5);
    }

    function OnFrameTickAlive()
    {
        local alpha_change = 7.727272;

        glow_alpha = clamp(glow_alpha + (glow_time_end > Time() ? alpha_change : -alpha_change), 0, 255);

        EntFireByHandle(glow_ent, "SetGlowColor", GetBossColor(player) + " " + glow_alpha.tointeger(), -1, boss, boss);
    }
}
