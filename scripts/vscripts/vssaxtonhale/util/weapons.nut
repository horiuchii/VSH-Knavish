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
        desc = "Heal 50% of health on hit\n\n\n\n\n"
    },
    ["reserve_shooter"] =
    {
        ids = [415]
        desc = "Crits airborne victims\n\n\n\n\n"
    },
    ["base_jumper"] =
    {
        ids = [1101]
        desc = "Lasts 3 seconds once deployed\n\n\n\n\n"
    },

    /*
    *   Scout
    */

    ["force_a_nature"] =
    {
        ids = [45, 1078]
        desc = "Buffed knockback\n\n\n\n\n"
    },
    ["shortstop"] =
    {
        ids = [220]
        desc = "+25% Damage bonus\n+50% Stronger shove\n\n\n\n"
    },
    ["baby_face_blaster"] =
    {
        ids = [772]
        desc = "Decays over 8 seconds\n\n\n\n\n"
    },
    ["backscatter"] =
    {
        ids = [1103]
        desc = "Crits from behind\n\n\n\n\n"
    },

    ["mad_milk"] =
    {
        ids = [222, 1121]
    },

    ["candy_cane"] =
    {
        ids = [317]
        desc = "Drop a small health pack on hit\n\n\n\n\n"
    },
    ["sunonastick"] =
    {
        ids = [349]
        desc = "No passive crits\n+50% damage bonus\n\n\n\n"
    },
    ["fan_o_war"] =
    {
        ids = [355]
        desc = "Marked-For-Death effect\nlasts 8 seconds instead of 15\n\n\n\n"
    },

    /*
    *   Soldier
    */

    ["direct_hit"] =
    {
        ids = [127]
        desc = "Crits airborne victims\n\n\n\n\n"
    },
    ["rocket_jumper"] =
    {
        ids = [237]
        desc = "No bonus reserve ammo\n\n\n\n\n"
    },
    ["cowmangler"] =
    {
        ids = [441]
        desc = "+65% Charge shot damage\n+90% Charge shot projectile speed\n\n\n\n"
    },
    ["airstrike"] =
    {
        ids = [1104]
        desc = "Gain extra clip every 200 damage\n-5% damage penalty\n+20% faster reload\n\n\n"
    },

    ["mantreads"] =
    {
        ids = [444]
    },

    ["equalizer"] =
    {
        ids = [128]
        desc = "+100% holster speed bonus\n\n\n\n\n"
    },
    ["market_gardener"] =
    {
        ids = [416]
        desc = "Gardens deal bonus damage\n\n\n\n\n"
    },
    ["disciplinary_action"] =
    {
        ids = [447]
    },
    ["escape_plan"] =
    {
        ids = [775]
        desc = "No longer Marked-For-Death\nwhile active\n\n\n\n"
    },

    /*
    *   Pyro
    */

    ["flamethrower"] =
    {
        ids = [21, 208, 659, 741, 798, 807, 887, 896, 905, 914, 963, 972, 15005, 15017, 15030,
            15034, 15049, 15054, 15066, 15067, 15068, 15089, 15090, 15115, 15141, 30474]
        desc = "-25% vertical airblast scale\n+25% damage bonus\n\n\n\n"
    },
    ["degreaser"] =
    {
        ids = [215]
        desc = "-25% vertical airblast scale\n+25% damage bonus\n+9% afterburn damage bonus\n\n\n"
    },

    ["thermal_thruster"] =
    {
        ids = [1179]
    },

    ["axtinguisher"] =
    {
        ids = [38,1000]
        desc = "No passive crits\n+100% damage bonus\n\n\n\n"
    },
    ["homewrecker"] =
    {
        ids = [153,466]
    },
    ["powerjack"] =
    {
        ids = [214]
        desc = "+75 health on hit, overheals\n\n\n\n\n"
    },
    ["back_scratcher"] =
    {
        ids = [326]
        desc = "+50% health from healers\n\n\n\n\n"
    },

    /*
    *   Demoman
    */

    ["booties"] =
    {
        ids = [405]
        desc = "+10% faster move speed\n(no shield required)\n\n\n\n"
    },
    ["boot_legger"] =
    {
        ids = [608]
        desc = "+10% faster move speed\n(no shield required)\n\n\n\n"
    },

    ["stickybomb_launcher"] =
    {
        ids = [20, 207, 661, 797, 806, 886, 895, 904, 913, 962, 971, 15009, 15012, 15024,
            15038, 15045, 15048, 15082, 15083, 15084, 15113, 15137, 15138, 15155]
    },
    ["scottish_resistance"] =
    {
        ids = [130]
        desc = "Cannot Crit\n\n\n\n\n"
    },
    ["chargin_targe"] =
    {
        ids = [131, 1144]
        desc = "Blocks a single hit (can still charge)\n\n\n\n\n"
    },
    ["sticky_jumper"] =
    {
        ids = [265]
        desc = "No bonus reserve ammo\n\n\n\n\n"
    },
    ["splendid_screen"] =
    {
        ids = [406]
        desc = "Blocks a single hit (can still charge)\n\n\n\n\n"
    },
    ["tide_turner"] =
    {
        ids = [1099]
        desc = "Blocks a single hit (can still charge)\n\n\n\n\n"
    },
    ["quickiebomb_launcher"] =
    {
        ids = [1150]
    },

    ["eyelander"] =
    {
        ids = [132, 266, 482, 1082]
        desc = "Gain a head for every hit\n+15 health on hit, overheals\n\n\n\n"
    },
    ["claidheamhmor"] =
    {
        ids = [327]
        desc = "No damage vulnerability\n\n\n\n\n"
    },

    /*
    *   Heavy
    */

    ["natascha"] =
    {
        ids = [41]
        desc = "No slow on hit\n\n\n\n\n\n"
    },

    ["kgb"] =
    {
        ids = [43]
        desc = "+5 seconds of crits on hit\n\n\n\n\n\n"
    },
	["gru"] =
    {
        ids = [239, 1084, 1100]
        desc = "+10% faster move speed while active\n-7 health per second\n\n\n\n\n"
    },
    ["warriors_spirit"] =
    {
        ids = [310]
        desc = "+50 health on hit, overheals\n\n\n\n\n\n"
    },
    ["fists_of_steel"] =
    {
        ids = [331]
    },
    ["eviction_notice"] =
    {
        ids = [426]
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
        desc = "+4% ÜberCharge added on hit\n\n\n\n\n"
    },
    ["blutsauger"] =
    {
        ids = [36]
        desc = "No Regen penalty\n+3% ÜberCharge added on hit\n+5 health added on hit, overheals\n\n\n"
    },
    ["xbow"] =
    {
        ids = [305, 1079]
        desc = "+10% ÜberCharge added on hit\n\n\n\n\n"
    },
    ["overdose"] =
    {
        ids = [412]
        desc = "+2% ÜberCharge added on hit\n+10% faster move speed while active\n\n\n\n"
    },

    ["quick_fix"] =
    {
        ids = [411]
        desc = "No Overheal penalty\n\n\n\n\n"
    },

    ["ubersaw"] =
    {
        ids = [37, 1003]
    },
    ["vitasaw"] =
    {
        ids = [173]
        desc = "On Hit: +15% UberCharge added\n\n\n\n\n"
    },
    ["solemnvow"] =
    {
        ids = [413]
        desc = "+10% stronger wall climb\n\n\n\n\n"
    },

    /*
    *   Sniper
    */

    ["hitmans_heatmaker"] =
    {
        ids = [752]
        desc = "Outline victim on hit,\nlength based on charge power\n\n\n\n"
    },
    ["classic"] =
    {
        ids = [1098]
        desc = "+25% Faster charge rate\n\n\n\n\n"
    },

    ["smg"] =
    {
        ids = [16, 203, 1149, 15001, 15022, 15032, 15037, 15058, 15076, 15110, 15134, 15153]
        desc = "+50% damage bonus\nCrit on headshot\n\n\n\n"
    },
    ["razorback"] =
    {
        ids = [57]
        desc = "Blocks a single hit\n\n\n\n\n"
    },
    ["darwins_danger_shield"] =
    {
        ids = [231]
        desc = "Overheal increased to 225\n\n\n\n\n"
    },
    ["cozy_camper"] =
    {
        ids = [642]
    },
    ["cleaners_carbine"] =
    {
        ids = [751]
        desc = "+50% damage bonus\nCrit on headshot\n\n\n\n"
    },

    ["bushwaka"] =
    {
        ids = [232]
        desc = "No passive crits\n+100% damage bonus\n\n\n\n"
    },

    /*
    *   Spy
    */

    ["ambassador"] =
    {
        ids = [61, 1006]
        desc = "No headshot falloff\n\n\n\n\n"
    },
    ["letranger"] =
    {
        ids = [224]
        desc = "-10% cloak on hit\n\n\n\n\n"
    },
    ["diamondback"] =
    {
        ids = [525]
        desc = "Grants 2 guaranteed\ncritical hits on backstab\n\n\n\n"
    },

    ["your_eternal_reward"] =
    {
        ids = [225, 574]
        desc = "Disguise as teammate on backstab\n\n\n\n\n"
    },
    ["kunai"] =
    {
        ids = [356]
        desc = "+180 health on backstab\n\n\n\n\n"
    },
    ["big_earner"] =
    {
        ids = [461]
        desc = "No backstab stun\n-30 max health on wearer\n\n\n\n"
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
        desc = "+50% cloak / decloak rate\nSpeed boost while cloaked\nRegular cloak type\n\n\n"
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

    return WeaponTable[name].desc;
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
        return WeaponIs("razorback")
            || WeaponIs("darwins_danger_shield")
            || WeaponIs("cozy_camper");
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
        if (wearable.GetClassname().find("tf_wearable") == null)
            continue;

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
        if (wearable.GetClassname().find("tf_wearable") == null)
            continue;

        if (WeaponIs(wearable, name))
            return wearable;
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

