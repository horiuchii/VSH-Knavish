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

::mercTraitsLibrary <- [];

class MercenaryTrait extends CharacterTrait
{
    trait_team = TF_TEAM_MERCS;
}

enum TRAIT {
    ALL = "all_class/"
    SINGLE = "single_class/"
}

function IncludeTrait(type, path)
{
    Include("/mercs/merc_traits/" + type + path);
}

//Merc Traits
IncludeTrait(TRAIT.ALL, "airborne_minicrits.nut");
IncludeTrait(TRAIT.ALL, "melee_buffs.nut");
IncludeTrait(TRAIT.ALL, "melee_wall_climb.nut");
IncludeTrait(TRAIT.ALL, "burst_damage_nerf.nut");
IncludeTrait(TRAIT.ALL, "no_pyrovision.nut");
IncludeTrait(TRAIT.ALL, "allclass_katana.nut");
IncludeTrait(TRAIT.ALL, "base_jumper_duration_nerf.nut");
IncludeTrait(TRAIT.ALL, "goomba.nut");
IncludeTrait(TRAIT.ALL, "crit_buffs.nut");

//Scout
IncludeTrait(TRAIT.SINGLE, "scout_atomizer.nut");
IncludeTrait(TRAIT.SINGLE, "scout_candy_cane.nut");
IncludeTrait(TRAIT.SINGLE, "scout_stronger_fan.nut");
IncludeTrait(TRAIT.SINGLE, "scout_bfb_decay.nut");
IncludeTrait(TRAIT.SINGLE, "scout_critacola_fullcrit.nut");
IncludeTrait(TRAIT.SINGLE, "scout_sunonastick.nut");
IncludeTrait(TRAIT.SINGLE, "scout_backscatter.nut");
IncludeTrait(TRAIT.SINGLE, "scout_shortstop.nut");
IncludeTrait(TRAIT.SINGLE, "scout_pbpp.nut");

//Soldier
IncludeTrait(TRAIT.SINGLE, "soldier_jumper_ammo.nut");
IncludeTrait(TRAIT.SINGLE, "soldier_airstrike.nut");
IncludeTrait(TRAIT.SINGLE, "soldier_market_gardener.nut");
IncludeTrait(TRAIT.SINGLE, "soldier_equalizer.nut");
IncludeTrait(TRAIT.SINGLE, "soldier_escape_plan.nut");
IncludeTrait(TRAIT.SINGLE, "soldier_cowmangler.nut");

//Pyro
IncludeTrait(TRAIT.SINGLE, "pyro_airblast_nerf.nut");
IncludeTrait(TRAIT.SINGLE, "pyro_back_scratcher.nut");
IncludeTrait(TRAIT.SINGLE, "pyro_degreaser.nut");
IncludeTrait(TRAIT.SINGLE, "pyro_powerjack.nut");
IncludeTrait(TRAIT.SINGLE, "pyro_axtinguisher.nut");
IncludeTrait(TRAIT.SINGLE, "pyro_detonator.nut");
IncludeTrait(TRAIT.SINGLE, "pyro_manmelter.nut");

//Demoman
IncludeTrait(TRAIT.SINGLE, "demo_shield.nut");
IncludeTrait(TRAIT.SINGLE, "demo_head_collecting.nut");
IncludeTrait(TRAIT.SINGLE, "demo_scottres_nerf.nut");
IncludeTrait(TRAIT.SINGLE, "demo_jumper_ammo.nut");
IncludeTrait(TRAIT.SINGLE, "demo_boots.nut");
IncludeTrait(TRAIT.SINGLE, "demo_claidheamhmor.nut");

//Heavy
IncludeTrait(TRAIT.SINGLE, "heavy_minigun_nerf.nut");
IncludeTrait(TRAIT.SINGLE, "heavy_natascha_nerf.nut");
IncludeTrait(TRAIT.SINGLE, "heavy_kgb_crits.nut");
IncludeTrait(TRAIT.SINGLE, "heavy_warriors_spirit.nut");
IncludeTrait(TRAIT.SINGLE, "heavy_received_knockback.nut");
IncludeTrait(TRAIT.SINGLE, "heavy_gru.nut");
IncludeTrait(TRAIT.SINGLE, "heavy_fists_of_steel.nut");
IncludeTrait(TRAIT.SINGLE, "heavy_eviction_notice.nut");

//Engineer
IncludeTrait(TRAIT.SINGLE, "engineer_building_build_boost.nut");
IncludeTrait(TRAIT.SINGLE, "engineer_sentry.nut");
IncludeTrait(TRAIT.SINGLE, "engineer_telefrag_scaling.nut");

//Medic
IncludeTrait(TRAIT.SINGLE, "medic_uber_rate.nut");
IncludeTrait(TRAIT.SINGLE, "medic_xbow.nut");
IncludeTrait(TRAIT.SINGLE, "medic_syringegun.nut");
IncludeTrait(TRAIT.SINGLE, "medic_overdose.nut");
IncludeTrait(TRAIT.SINGLE, "medic_blutsauger.nut");
IncludeTrait(TRAIT.SINGLE, "medic_vitasaw.nut");
IncludeTrait(TRAIT.SINGLE, "medic_quickfix_overhealbuff.nut");

//Sniper
IncludeTrait(TRAIT.SINGLE, "sniper_hitmans_heatmaker.nut");
IncludeTrait(TRAIT.SINGLE, "sniper_smg_buffs.nut");
IncludeTrait(TRAIT.SINGLE, "sniper_focus.nut");
IncludeTrait(TRAIT.SINGLE, "sniper_head_collecting.nut");
IncludeTrait(TRAIT.SINGLE, "sniper_razorback.nut");
IncludeTrait(TRAIT.SINGLE, "sniper_darwins_danger_shield.nut");
IncludeTrait(TRAIT.SINGLE, "sniper_bushwaka.nut");
IncludeTrait(TRAIT.SINGLE, "sniper_classic.nut");

//Spy
IncludeTrait(TRAIT.SINGLE, "spy_invis_res.nut");
IncludeTrait(TRAIT.SINGLE, "spy_letranger_nerf.nut");
IncludeTrait(TRAIT.SINGLE, "spy_backstab.nut");
IncludeTrait(TRAIT.SINGLE, "spy_ambassador.nut");
IncludeTrait(TRAIT.SINGLE, "spy_cloak_and_dagger.nut");
IncludeTrait(TRAIT.SINGLE, "spy_bigearner_nerf.nut");

//Voicelines
Include("/mercs/voice_lines/all_class/tracing_boss.nut");
Include("/mercs/voice_lines/all_class/no_medic.nut");
Include("/mercs/voice_lines/all_class/setup.nut");
Include("/mercs/voice_lines/all_class/wall_climb.nut");
Include("/mercs/voice_lines/all_class/victory.nut");
Include("/mercs/voice_lines/all_class/silent_tie.nut");

Include("/mercs/voice_lines/single_class/scout_marked.nut");
Include("/mercs/voice_lines/single_class/soldier_jumper.nut");
Include("/mercs/voice_lines/single_class/demo_sticky_trap.nut");
Include("/mercs/voice_lines/single_class/demo_fix_charge_sfx.nut");
Include("/mercs/voice_lines/single_class/demo_trap_cheer.nut");
Include("/mercs/voice_lines/single_class/heavy_lowammo.nut");
Include("/mercs/voice_lines/single_class/heavy_tickle.nut");
Include("/mercs/voice_lines/single_class/spy_dead_ringer.nut");
Include("/mercs/voice_lines/single_class/spy_last_mann.nut");
Include("/mercs/voice_lines/single_class/sniper_run.nut");
Include("/mercs/voice_lines/single_class/pyro_airblast.nut");
Include("/mercs/voice_lines/single_class/pyro_airblast.nut");