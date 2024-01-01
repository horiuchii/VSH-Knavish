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

::SetItemId <- function(item, id)
{
    if (item != null)
        SetPropInt(item, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", id);
}

::ClearPlayerItems <- function(player)
{
    local item = null;
    local itemsToKill = [];
    while (item = Entities.FindByClassname(item, "tf_we*"))
    {
        if (item.GetOwner() == player)
            itemsToKill.push(item);
    }
    item = null;
    while (item = Entities.FindByClassname(item, "tf_powerup_bottle"))
    {
        if (item.GetOwner() == player)
            itemsToKill.push(item);
    }
    foreach (item in itemsToKill)
        item.Kill();
}

::WeaponTable <-
{
    /*
    *   All-Class
    */

    ["half_zatoichi"] =
    {
        ids = [357]
        name = "Half Zatoichi"
        desc = "Heal 45% of health on hit\n-66% Knockback on hit\n"
    },
    ["reserve_shooter"] =
    {
        ids = [415]
        name = "Reserve Shooter"
        desc = "Crits airborne victims\n\n"
    },
    ["base_jumper"] =
    {
        ids = [1101]
        name = "Base Jumper"
        desc = "Lasts 3 seconds once deployed\n\n"
    },

    /*
    *   Scout
    */

    ["force_a_nature"] =
    {
        ids = [45, 1078]
        name = "Force-A-Nature"
        desc = "Buffed knockback\n\n"
    },
    ["shortstop"] =
    {
        ids = [220]
        name = "Shortstop"
        desc = "+25% Damage bonus\n+50% Stronger shove\n"
    },
    ["baby_face_blaster"] =
    {
        ids = [772]
        name = "Baby Face's Blaster"
        desc = "Decays over 8 seconds\n\n"
    },
    ["backscatter"] =
    {
        ids = [1103]
        name = "Back Scatter"
        desc = "Crits from behind\n\n"
    },

    ["crit_a_cola"] =
    {
        ids = [163]
        name = "Crit-a-Cola"
        desc = "Grants crits instead of mini-crits\n\n"
    },
    ["pbpp"] =
    {
        ids = [773]
        name = "Pretty Boy's Pocket Pistol"
        desc = "No fall damage while active\n\n"
    },

    ["atomizer"] =
    {
        ids = [450]
        name = "Atomizer"
        desc = "Removed deploy time penalty\n\n"
    },
    ["candy_cane"] =
    {
        ids = [317]
        name = "Candy Cane"
        desc = "Drop a small health pack on hit\n\n"
    },
    ["sunonastick"] =
    {
        ids = [349]
        name = "Sun-on-a-Stick"
        desc = "No passive crits\n+50% damage bonus\n2x Damage vs burning victims"
    },
    ["fan_o_war"] =
    {
        ids = [355]
        name = "Fan O'War"
        desc = "-50% Marked-For-Death duration\n(15s > 7.5s)\n"
    },

    /*
    *   Soldier
    */

    ["direct_hit"] =
    {
        ids = [127]
        name = "Direct Hit"
        desc = "Crits airborne victims\n\n"
    },
    ["rocket_jumper"] =
    {
        ids = [237]
        name = "Rocket Jumper"
        desc = "No bonus reserve ammo\n\n"
    },
    ["cowmangler"] =
    {
        ids = [441]
        name = "Cow Mangler 5000"
        desc = "+65% Charge shot damage\n+90% Charge shot projectile speed\n"
    },
    ["airstrike"] =
    {
        ids = [1104]
        name = "Air Strike"
        desc = "Gain extra clip every 200 damage\n-20% damage penalty\n+20% faster reload"
    },

    ["mantreads"] =
    {
        name = "Mantreads"
        ids = [444]
    },

    ["equalizer"] =
    {
        ids = [128]
        name = "Equalizer"
        desc = "-100% holster speed\n+30% Damage resist while active\n"
    },
    ["market_gardener"] =
    {
        ids = [416]
        name = "Market Gardener"
        desc = "Gardens deal bonus damage\n\n"
    },
    ["disciplinary_action"] =
    {
        ids = [447]
    },
    ["escape_plan"] =
    {
        ids = [775]
        name = "Escape Plan"
        desc = "No longer Marked-For-Death\nwhile active\n"
    },

    /*
    *   Pyro
    */

    ["flamethrower"] =
    {
        ids = [21, 208, 659, 741, 798, 807, 887, 896, 905, 914, 963, 972, 15005, 15017, 15030,
            15034, 15049, 15054, 15066, 15067, 15068, 15089, 15090, 15115, 15141, 30474]
        name = "Flame Thrower"
        desc = "-25% Vertical airblast scale\n+25% Damage bonus\n"
    },
    ["backburner"] =
    {
        ids = [40, 1146]
        name = "Backburner"
        desc = "-25% Vertical airblast scale\n+25% Damage bonus\n"
    },
    ["degreaser"] =
    {
        ids = [215]
        name = "Degreaser"
        desc = "-25% Vertical airblast scale\n+25% Damage bonus\n-25% Afterburn damage bonus"
    },
    ["phlog"] =
    {
        ids = [594]
        name = "Phlogistinator"
        desc = "-25% Vertical airblast scale\n+25% Damage bonus\n"
    },
    ["dragonsfury"] =
    {
        ids = [1178]
        name = "Dragon's Fury"
        desc = "-25% Vertical airblast scale\n+25% Damage bonus\n"
    },

    ["detonator"] =
    {
        ids = [351]
        name = "Detonator"
        desc = "+100% Self damage force\n\n"
    },
    ["manmelter"] =
    {
        ids = [595]
        name = "Manmelter"
        desc = "+50% Projectile speed\n+50% Faster firing speed\n"
    },
    ["thermal_thruster"] =
    {
        ids = [1179]
    },

    ["axtinguisher"] =
    {
        ids = [38,1000]
        name = "Axtinguisher"
        desc = "No passive crits\n+100% Damage bonus\n"
    },
    ["homewrecker"] =
    {
        ids = [153,466]
    },
    ["powerjack"] =
    {
        ids = [214]
        name = "Powerjack"
        desc = "No damage vulnerability\n+75 Health on hit, overheals\n"
    },
    ["back_scratcher"] =
    {
        ids = [326]
        name = "Back Scratcher"
        desc = "+50% Health from healers\n\n"
    },

    /*
    *   Demoman
    */

    ["booties"] =
    {
        ids = [405]
        name = "Ali Baba's Wee Booties"
        desc = "+10% Faster move speed\n(So shield required)\n"
    },
    ["boot_legger"] =
    {
        ids = [608]
        name = "Bootlegger"
        desc = "+10% Faster move speed\n(No shield required)\n"
    },

    ["stickybomb_launcher"] =
    {
        ids = [20, 207, 661, 797, 806, 886, 895, 904, 913, 962, 971, 15009, 15012, 15024,
            15038, 15045, 15048, 15082, 15083, 15084, 15113, 15137, 15138, 15155]
    },
    ["scottish_resistance"] =
    {
        ids = [130]
        name = "Scottish Resistance"
        desc = "Cannot Crit\n\n"
    },
    ["chargin_targe"] =
    {
        ids = [131, 1144]
        name = "Chargin' Targe"
        desc = "Blocks a single hit (Can still charge)\n\n"
    },
    ["sticky_jumper"] =
    {
        ids = [265]
        name = "Sticky Jumper"
        desc = "No bonus reserve ammo\n\n"
    },
    ["splendid_screen"] =
    {
        ids = [406]
        name = "Splendid Screen"
        desc = "Blocks a single hit (Can still charge)\n\n"
    },
    ["tide_turner"] =
    {
        ids = [1099]
        name = "Tide Turner"
        desc = "Blocks a single hit (Can still charge)\n\n"
    },
    ["quickiebomb_launcher"] =
    {
        ids = [1150]
    },

    ["eyelander"] =
    {
        ids = [132, 266, 482, 1082]
        name = "Eyelander"
        desc = "Gain a head for every hit\n+15 Health on hit, overheals\n-66% Knockback on hit"
    },
    ["claidheamhmor"] =
    {
        ids = [327]
        name = "Claidheamh Mòr"
        desc = "No damage vulnerability\n-66% Knockback on hit\n"
    },
    ["scotsmans_skullcutter"] =
    {
        ids = [172]
        name = "Scotsman's Skullcutter"
        desc = "-66% Knockback on hit\n\n"
    },
    ["persian_pursuader"] =
    {
        ids = [404]
        name = "Persian Pursuader"
        desc = "-66% Knockback on hit\n\n"
    },

    /*
    *   Heavy
    */

    ["natascha"] =
    {
        ids = [41]
        name = "Natascha"
        desc = "No slow on hit\n\n"
    },

    ["kgb"] =
    {
        ids = [43]
        name = "Killing Gloves of Boxing"
        desc = "+5 Seconds of crits on hit\n\n"
    },
	["gru"] =
    {
        ids = [239, 1084, 1100]
        name = "Gloves of Running Urgently"
        desc = "+10% Faster move speed while active\n-7 Health per second\n"
    },
    ["warriors_spirit"] =
    {
        ids = [310]
        name = "Warrior's Spirit"
        desc = "+50 Health on hit, overheals\n\n"
    },
    ["fists_of_steel"] =
    {
        ids = [331]
    },
    ["eviction_notice"] =
    {
        ids = [426]
        desc = "Removed health drain\n-33% Knockback on hit\n"
    },
    ["holiday_punch"] =
    {
        ids = [656]
    },

    /*
    *   Engineer
    */



    /*
    *   Medic
    */

    ["syringegun"] =
    {
        ids = [17, 204]
        name = "Syringe Gun"
        desc = "+4% ÜberCharge added on hit\n\n"
    },
    ["blutsauger"] =
    {
        ids = [36]
        name = "Blutsauger"
        desc = "No Regen penalty\n+3% ÜberCharge added on hit\n+5 Health added on hit, overheals"
    },
    ["xbow"] =
    {
        ids = [305, 1079]
        name = "Crusader's Crossbow"
        desc = "+10% ÜberCharge added on hit\n\n"
    },
    ["overdose"] =
    {
        ids = [412]
        name = "Overdose"
        desc = "+2% ÜberCharge added on hit\n+10% Faster move speed while active\n"
    },

    ["kritzkreig"] =
    {
        ids = [35]
        name = "Kritzkrieg"
        desc = "+30% Übercharge rate\n\n"
    },
    ["quick_fix"] =
    {
        ids = [411]
        name = "Quick-Fix"
        desc = "No Overheal penalty\n\n"
    },
    ["vaccinator"] =
    {
        ids = [998]
    },

    ["ubersaw"] =
    {
        ids = [37, 1003]
        desc = "-33% Knockback on hit\n\n"
    },
    ["vitasaw"] =
    {
        ids = [173]
        name = "Vita-Saw"
        desc = "+15% ÜberCharge added on hit\n\n"
    },
    ["solemnvow"] =
    {
        ids = [413]
        name = "Solemn Vow"
        desc = "+10% Stronger wall climb\n\n"
    },

    /*
    *   Sniper
    */

    ["hitmans_heatmaker"] =
    {
        ids = [752]
        name = "Hitman's Heatmaker"
        desc = "Outline victim on hit,\nlength based on charge power\n"
    },
    ["classic"] =
    {
        ids = [1098]
        name = "Classic"
        desc = "+25% Faster charge rate\n\n"
    },

    ["smg"] =
    {
        ids = [16, 203, 1149, 15001, 15022, 15032, 15037, 15058, 15076, 15110, 15134, 15153]
        name = "SMG"
        desc = "+50% Damage bonus\nCrit on headshot\n"
    },
    ["razorback"] =
    {
        ids = [57]
        name = "Razorback"
        desc = "Blocks a single hit\n\n"
    },
    ["darwins_danger_shield"] =
    {
        ids = [231]
        name = "Darwin's Danger Shield"
        desc = "Max overheal increased to 225\n\n"
    },
    ["cozy_camper"] =
    {
        ids = [642]
    },
    ["cleaners_carbine"] =
    {
        ids = [751]
        name = "Cleaner's Carbine"
        desc = "+50% damage bonus\nCrit on headshot\n"
    },

    ["bushwaka"] =
    {
        ids = [232]
        name = "Bushwaka"
        desc = "No passive crits\n+100% Damage bonus\n"
    },

    /*
    *   Spy
    */

    ["ambassador"] =
    {
        ids = [61, 1006]
        name = "Ambassador"
        desc = "Can headshot from any range\nHeadshots deal base 150 crit damage\n"
    },
    ["letranger"] =
    {
        ids = [224]
        name = "L'Etranger"
        desc = "-10% Cloak on hit\n\n"
    },
    ["diamondback"] =
    {
        ids = [525]
        name = "Diamondback"
        desc = "Grants 2 guaranteed\ncritical hits on backstab\n"
    },

    ["your_eternal_reward"] =
    {
        ids = [225, 574]
        name = "Your Eternal Reward"
        desc = "Disguise as teammate on backstab\n\n"
    },
    ["kunai"] =
    {
        ids = [356]
        name = "Conniver's Kunai"
        desc = "+180 Health on backstab\n\n"
    },
    ["big_earner"] =
    {
        ids = [461]
        name = "Big Earner"
        desc = "No backstab stun\n-30 Max health on wearer\n"
    },

    ["invis_watch"] =
    {
        ids = [30]
    },
    ["dead_ringer"] =
    {
        ids = [59]
    },
    ["cloak_and_dagger"] =
    {
        ids = [60]
        name = "Cloak and Dagger"
        desc = "+50% Cloak / Decloak rate\nSpeed boost while cloaked\nInvis Watch cloak mode"
    },
};

::WeaponTableID <- {};

foreach (key, weapon in WeaponTable)
{
    foreach(id in weapon.ids)
    {
        WeaponTableID[id] <- key;
    }
}

::GetWeaponName <- function(weapon)
{
    if(GetItemID(weapon) in WeaponTableID)
        return WeaponTableID[GetItemID(weapon)];

    return null;
}

::GetWeaponDescription <- function(name)
{
    if(name == null)
        return "Not Changed\n\n\n\n\n";

    if(!("desc" in WeaponTable[name]))
        return "Not Changed\n\n\n\n\n";

    return WeaponTable[name].desc + "\n\n\n";
}

::WeaponIs <- function(weapon, name)
{
    local index = GetItemID(weapon);
    if (name == "any_stickybomb_launcher")
    {
        return WeaponIs(weapon, "stickybomb_launcher")
            || WeaponIs(weapon, "scottish_resistance")
            || WeaponIs(weapon, "quickiebomb_launcher")
            || WeaponIs(weapon, "sticky_jumper");
    }
    else if(name == "any_sword")
    {
        return weapon.GetClassname() == "tf_weapon_sword"
            || weapon.GetClassname() == "tf_weapon_katana";
    }
    else if(name == "any_demo_boots")
    {
        return WeaponIs(weapon, "booties")
            || WeaponIs(weapon, "boot_legger")
    }
    else if(name == "any_demo_shield")
    {
        return WeaponIs(weapon, "chargin_targe")
            || WeaponIs(weapon, "splendid_screen")
            || WeaponIs(weapon, "tide_turner");
    }
    else if(name == "any_pistol")
    {
        return weapon.GetClassname() == "tf_weapon_pistol"
            || weapon.GetClassname() == "tf_weapon_handgun_scout_secondary";
    }
    else if(name == "any_sniper_backpack")
    {
        return WeaponIs(weapon, "razorback")
            || WeaponIs(weapon, "darwins_danger_shield")
            || WeaponIs(weapon, "cozy_camper");
    }
    else
    {
        return WeaponTable.rawin(name) && WeaponTable[name].ids.find(index) != null;
    }
}

::CTFPlayer.GetAmmo <- function(weapon)
{
    local ammotype = weapon.GetPrimaryAmmoType();
    return ammotype == -1 ? -1 : GetPropInt(this, "m_iAmmo." + "00" + ammotype.tostring());
}

::CTFBot.GetAmmo <- CTFPlayer.GetAmmo;

::CTFPlayer.SetAmmo <- function(weapon, amount)
{
    local ammotype = weapon.GetPrimaryAmmoType();
    if (ammotype == -1)
        return;

    SetPropInt(this, "m_iAmmo." + "00" + ammotype.tostring(), amount);
}

::CTFBot.SetAmmo <- CTFPlayer.SetAmmo;

::CTFPlayer.HasWearable <- function(name)
{
    for (local wearable = FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        if (!startswith(wearable.GetClassname(), "tf_wearable"))
        {
            continue;
        }

        if (WeaponIs(wearable, name))
        {
            return true;
        }
    }

    return false;
}

::CTFBot.HasWearable <- CTFPlayer.HasWearable;

::CTFPlayer.GetWearable <- function(name)
{
    for (local wearable = FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        if (!startswith(wearable.GetClassname(), "tf_wearable"))
        {
            continue;
        }

        if (WeaponIs(wearable, name))
        {
            return wearable;
        }
    }

    return false;
}

::CTFBot.GetWearable <- CTFPlayer.GetWearable;

::GetSwingLength <- function(weapon)
{
    if(WeaponIs(weapon, "any_sword"))
        return 72;

    if(WeaponIs(weapon, "disciplinary_action"))
        return 81.6;

    return 48;
}

::GetBoundsMultiplier <- function(weapon)
{
    if(WeaponIs(weapon, "disciplinary_action"))
        return 1.55;

    return 1.0;
}

// When we need to check for headshots, use HitboxDetector
if ("HitboxDetector" in getroottable() && HitboxDetector.IsValid())
    HitboxDetector.Destroy();

::HitboxDetector <- Entities.CreateByClassname("tf_weapon_sniperrifle");
SetPropInt(HitboxDetector, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", 14);
SetPropBool(HitboxDetector, "m_AttributeManager.m_Item.m_bInitialized", true);
Entities.DispatchSpawn(HitboxDetector);
HitboxDetector.SetClip1(-1);

::HitboxDetectorAttacking <- false;
::HitboxDetectorHitgroup <- false;

