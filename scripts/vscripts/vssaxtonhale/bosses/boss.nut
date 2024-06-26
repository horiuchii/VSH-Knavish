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

::bossLibrary <- {};
::bossList <- [];
::traitLibrary <- {};
::validBosses <- [];

class BossTrait extends CharacterTrait
{
    boss = null;
    trait_team = TF_TEAM_BOSS;

    // DO NOT OVERRIDE
    function ApplyTrait(player)
    {
        boss = player;
        base.ApplyTrait(player);
    }
}

function AddBossTrait(bossName, traitClass)
{
    if (!(bossName in traitLibrary))
        traitLibrary[bossName] <- [];
    traitLibrary[bossName].push(traitClass);
}

Include("/bosses/boss_util.nut");
Include("/bosses/boss_ability.nut");

Include("/bosses/saxton_hale/abilities/sweeping_charge.nut");
Include("/bosses/saxton_hale/abilities/mighty_slam.nut");
Include("/bosses/generic/abilities/brave_jump.nut");
Include("/bosses/generic/passives/stun_breakout.nut");
Include("/bosses/generic/passives/debuff_resistance.nut");
Include("/bosses/generic/passives/received_damage_scaling.nut");
Include("/bosses/generic/passives/head_stomp.nut");
Include("/bosses/generic/misc/prevent_no_attack_damage.nut");
Include("/bosses/generic/misc/freeze_boss_setup");
Include("/bosses/generic/misc/death_cleanup.nut");
Include("/bosses/generic/misc/movespeed.nut");
Include("/bosses/generic/misc/screen_shake.nut");
Include("/bosses/generic/misc/setup_stat_refresh.nut");
Include("/bosses/generic/misc/taunt_handler.nut");
Include("/bosses/generic/misc/building_damage_rescale.nut");
Include("/bosses/generic/misc/spawn_protection.nut");
Include("/bosses/generic/misc/no_gib_fix.nut");
Include("/bosses/generic/voice_lines/jarated.nut");
Include("/bosses/generic/voice_lines/kill.nut");
Include("/bosses/generic/voice_lines/round_start.nut");
Include("/bosses/generic/voice_lines/last_mann_hiding.nut");
Include("/bosses/generic/voice_lines/round_end.nut");
Include("/bosses/generic/abilities/scare.nut");
Include("/bosses/generic/abilities/wall_climb.nut");
Include("/bosses/generic/abilities/teleport.nut");

Include("/bosses/saxton_hale/saxton_hale.nut");
Include("/bosses/hhh/hhh.nut");
