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

AddVoiceLineScriptSoundToQueue("count1")
AddVoiceLineScriptSoundToQueue("count2")
AddVoiceLineScriptSoundToQueue("count3")
AddVoiceLineScriptSoundToQueue("count4")
AddVoiceLineScriptSoundToQueue("count5")

AddVoiceLineScriptSoundToQueue("round_start")
AddVoiceLineScriptSoundToQueue("round_start_4boss")
AddVoiceLineScriptSoundToQueue("round_start_long")
AddVoiceLineScriptSoundToQueue("round_start_beer")
AddVoiceLineScriptSoundToQueue("round_start_after_loss")

AddListener("setup_start", 0, function ()
{
    if (API_GetBool("setup_lines"))
        RunWithDelay("PlayRoundStartVO()", null, 2);
});

function PlayRoundStartVO()
{
    if (IsRoundOver())
        return;
    local boss = GetRandomBossPlayer();
    if (boss == null)
        return;
    if (API_GetBool("long_setup_lines") && RandomInt(1, 10) <= 4)
        PlayAnnouncerVO(boss, "round_start_long");
    else
    {
        if (API_GetBool("beer_lines") && RandomInt(1, 10) <= 4)
            PlayAnnouncerVO(boss, "round_start_beer")
        else if (RandomInt(1, 5) == 1 && GetPersistentVar("last_round_winner") == TF_TEAM_BOSS)
            PlayAnnouncerVO(boss, "round_start_after_loss")
        else
            PlayAnnouncerVO(boss, "round_start")

        if (!API_GetBool("setup_countdown_lines"))
            return;
        local countdownDelay = API_GetFloat("setup_length") - 8;
        PlayAnnouncerVODelayed(boss, "count5", countdownDelay++, true);
        PlayAnnouncerVODelayed(boss, "count4", countdownDelay++, true);
        PlayAnnouncerVODelayed(boss, "count3", countdownDelay++, true);
        PlayAnnouncerVODelayed(boss, "count2", countdownDelay++, true);
        PlayAnnouncerVODelayed(boss, "count1", countdownDelay, true);
    }
    PlayAnnouncerVOToPlayer(boss, boss, "round_start_4boss");
}