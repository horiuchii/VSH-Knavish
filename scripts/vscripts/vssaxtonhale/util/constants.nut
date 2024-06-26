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

::ROOT <- getroottable();
if (!("ConstantNamingConvention" in ROOT)) // make sure folding is only done once
{
	foreach (a,b in Constants)
		foreach (k,v in b)
			if (v == null)
				ROOT[k] <- 0;
			else
				ROOT[k] <- v;
}

foreach (k, v in NetProps.getclass())
    if (k != "IsValid")
		ROOT[k] <- NetProps[k].bindenv(NetProps);

::DMG_CRIT <- DMG_ACID;                 //Crit / Minicrit
::DMG_RADIUS_MAX <- DMG_ENERGYBEAM;     //No Damage Falloff
::DMG_NOCLOSEDISTANCEMOD <- DMG_POISON; //Don't do damage falloff too close
::DMG_HALF_FALLOFF <- DMG_POISON;       //50% damage falloff
::DMG_USEDISTANCEMOD <- DMG_SLOWBURN;   //Do damage falloff
::DMG_IGNITE <- DMG_PLASMA;             //Ignite victim
::DMG_USE_HITLOCATIONS <- DMG_AIRBOAT;  //Do hit location damage (sniper rifle & ambassador)

::TF_TEAM_UNASSIGNED <- TEAM_UNASSIGNED;
::TF_TEAM_SPECTATOR <- TEAM_SPECTATOR;
::TF_TEAM_BLU <- TF_TEAM_RED;
::TF_TEAM_MERC <- TF_TEAM_RED;
::TF_TEAM_MERCS <- TF_TEAM_RED;
::TF_TEAM_BOSS <- TF_TEAM_BLUE;
::TF_TEAM_BOSSES <- TF_TEAM_BLUE;
::TF_TEAM_ANY <- -1;
::TF_CLASS_HEAVY <- TF_CLASS_HEAVYWEAPONS;
::MAX_PLAYERS <- MaxClients().tointeger();

::CHAN_REPLACE <- -1;
::CHAN_MUSIC <- CHAN_REPLACE;

::MASK_SHOT <- 1174421507;
::MASK_PLAYERSOLID <- 33636363;

enum TF_DEATHFLAG
{
    KILLER_DOMINATION = 1,
    ASSISTER_DOMINATION = 2,
    KILLER_REVENGE = 4
    ASSISTER_REVENGE = 8
    FIRST_BLOOD = 16
    DEAD_RINGER = 32
    INTERRUPTED = 64
    GIBBED = 128
    PURGATORY = 256
}

enum LIFE_STATE
{
    ALIVE = 0,
    DYING = 1,
    DEAD = 2,
    RESPAWNABLE = 3,
    DISCARDBODY = 4
}

enum MINIGUN_STATE
{
    IDLE = 0,
    STARTFIRING = 1,
    FIRING = 2,
    SPINNING = 3,
    DRYFIRE = 4,
}

enum DIFFICULTY
{
    EASY = 0,
    NORMAL = 1,
    HARD = 2,
    EXTREME = 3,
    IMPOSSIBLE = 4,
}

enum STUNFLAG
{
    NONE = 0
    MOVEMENT = 1
    CONTROLS = 2
    BOTH = 3
    MOVEMENT_FORWARD_ONLY = 4
    SPECIAL_SOUND = 8
    DODGE_COOLDOWN = 16
    NO_EFFECTS = 32
    LOSER_STATE = 64
    BY_TRIGGER = 128
}

::DifficultyInternalName <-
[
    "easy"
    "normal"
    "hard"
    "extreme"
    "impossible"
]

::DifficultyName <-
[
    "Easy"
    "Normal"
    "Hard"
    "Extreme"
    "Impossible"
]

::DifficultyColor <-
[
    "5885A2"
    "729E42"
    "B8383B"
    "B71111"
    "7D4071"
]

::MASK_SOLID_BRUSHONLY <- 16395;

::KNA_VSH <- "\x01" + "\x07FFD700" + "[KNA-VSH] \x01";