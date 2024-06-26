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

AddAllClassToBossVOToQueue("setup")

mercTraitsLibrary.push(class extends CustomVoiceLine
{
    timesPlayedGlobal = [0];

    function OnApply()
    {
        if (timesPlayedGlobal[0] > 3 || RandomInt(0, 7) != 0)
            return;

        timesPlayedGlobal[0]++;

        RunWithDelay2(this, 0.1, function()
        {
            EmitPlayerToBossVODelayed(player, "setup", RandomInt(13, 15));
        })
    }
});

SendToConsole("con_filter_enable 1")
SendToConsole("con_filter_text_out WARNING")