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

ClearGameEventCallbacks();

function Include(path)
{
    IncludeScript("vssaxtonhale/" + path);
}

try { IncludeScript("vsh_addons/main_pre.nut"); } catch(e) { }

Include("/give_tf_weapon/_master.nut");

// These must be included first and in order!
Include("/util/constants.nut");
Include("/util/listeners.nut");
Include("/util/tfclass_util.nut")
Include("/util/player_util.nut");
Include("/util/character_trait.nut");
Include("/util/trace_filter.nut");
Include("/playertypes/player_type.nut");
Include("/vsh_api.nut");

// Order doesn't matter
Include("/cookies/stat_tracking.nut");

Include("/util/entities.nut");
Include("/util/netprops.nut");
Include("/util/player_cache.nut");
Include("/util/util.nut");
Include("/util/weapons.nut");

Include("/scriptsounds/soundcache_utils.nut");
Include("/scriptsounds/scriptsound_utils.nut");
Include("/scriptsounds/voiceline_traits.nut");

Include("/gamemode/boss_queue.nut");
Include("/gamemode/forced_arena.nut");
Include("/gamemode/gamerules.nut");
Include("/gamemode/game_events.nut");
Include("/gamemode/round_logic.nut");
Include("/gamemode/scoreboard.nut");

Include("/huds/hud.nut");
Include("/huds/menu_hud.nut");
Include("/huds/merc_hud.nut");
Include("/huds/inspect_hud.nut");
Include("/huds/boss_hud.nut");
Include("/huds/roundend_hud.nut");

// These must be included last and in order!
Include("/bosses/boss.nut");
Include("/mercs/merc_traits.nut");
Include("/mercs/merc_stats.nut");
Include("/shared/shared_traits.nut");
Include("/bug_fixes/bug_fixes.nut");
Include("/cookies/player_cookies.nut");
Include("/menus/menus.nut");

try { IncludeScript("vsh_addons/main.nut"); } catch(e) { }

__CollectGameEventCallbacks(this);
__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);