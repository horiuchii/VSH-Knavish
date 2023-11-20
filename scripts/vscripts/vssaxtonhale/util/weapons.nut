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
    },
    ["reserve_shooter"] =
    {
        ids = [415]
    },
    ["base_jumper"] =
    {
        ids = [1101]
    },

    /*
    *   Scout
    */

    ["force_a_nature"] =
    {
        ids = [45, 1078]
    },
    ["shortstop"] =
    {
        ids = [220]
    },
    ["baby_face_blaster"] =
    {
        ids = [772]
    },
    ["backscatter"] =
    {
        ids = [1103]
    },

    ["mad_milk"] =
    {
        ids = [222, 1121]
    },

    ["candy_cane"] =
    {
        ids = [317]
    },
    ["sunonastick"] =
    {
        ids = [349]
    },
    ["fan_o_war"] =
    {
        ids = [355]
    },

    /*
    *   Soldier
    */

    ["direct_hit"] =
    {
        ids = [127]
    },
    ["rocket_jumper"] =
    {
        ids = [237]
    },
    ["cowmangler"] =
    {
        ids = [441]
    },
    ["airstrike"] =
    {
        ids = [1104]
    },

    ["mantreads"] =
    {
        ids = [444]
    },

    ["equalizer"] =
    {
        ids = [128]
    },
    ["market_gardener"] =
    {
        ids = [416]
    },
    ["disciplinary_action"] =
    {
        ids = [447]
    },
    ["escape_plan"] =
    {
        ids = [775]
    },

    /*
    *   Pyro
    */

    ["degreaser"] =
    {
        ids = [215]
    },

    ["thermal_thruster"] =
    {
        ids = [1179]
    },

    ["axtinguisher"] =
    {
        ids = [38,1000]
    },
    ["homewrecker"] =
    {
        ids = [153,466]
    },
    ["powerjack"] =
    {
        ids = [214]
    },
    ["back_scratcher"] =
    {
        ids = [326]
    },

    /*
    *   Demoman
    */

    ["booties"] =
    {
        ids = [405]
    },
    ["boot_legger"] =
    {
        ids = [608]
    },

    ["stickybomb_launcher"] =
    {
        ids = [20, 207, 661, 797, 806, 886, 895, 904, 913, 962, 971, 15009, 15012, 15024,
            15038, 15045, 15048, 15082, 15083, 15084, 15113, 15137, 15138, 15155]
    },
    ["scottish_resistance"] =
    {
        ids = [130]
    },
    ["chargin_targe"] =
    {
        ids = [131, 1144]
    },
    ["sticky_jumper"] =
    {
        ids = [265]
    },
    ["splendid_screen"] =
    {
        ids = [406]
    },
    ["tide_turner"] =
    {
        ids = [1099]
    },
    ["quickiebomb_launcher"] =
    {
        ids = [1150]
    },

    ["eyelander"] =
    {
        ids = [132, 266, 482, 1082]
    },
    ["claidheamhmor"] =
    {
        ids = [327]
    },

    /*
    *   Heavy
    */

    ["natascha"] =
    {
        ids = [41]
    },

    ["kgb"] =
    {
        ids = [43]
    },
	["gru"] =
    {
        ids = [239, 1084, 1100]
    },
    ["warriors_spirit"] =
    {
        ids = [310]
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
    },
    ["blutsauger"] =
    {
        ids = [36]
    },
    ["xbow"] =
    {
        ids = [305, 1079]
    },
    ["overdose"] =
    {
        ids = [412]
    },

    ["quick_fix"] =
    {
        ids = [411]
    },

    ["ubersaw"] =
    {
        ids = [37, 1003]
    },
    ["vitasaw"] =
    {
        ids = [173]
    },
    ["solemnvow"] =
    {
        ids = [413]
    },

    /*
    *   Sniper
    */

    ["hitmans_heatmaker"] =
    {
        ids = [752]
    },
    ["classic"] =
    {
        ids = [1098]
    },

    ["smg"] =
    {
        ids = [16, 203, 1149, 15001, 15022, 15032, 15037, 15058, 15076, 15110, 15134, 15153]
    },
    ["razorback"] =
    {
        ids = [57]
    },
    ["darwins_danger_shield"] =
    {
        ids = [231]
    },
    ["cleaners_carbine"] =
    {
        ids = [751]
    },

    ["bushwaka"] =
    {
        ids = [232]
    },

    /*
    *   Spy
    */

    ["ambassador"] =
    {
        ids = [61, 1006]
    },
    ["letranger"] =
    {
        ids = [224]
    },
    ["diamondback"] =
    {
        ids = [525]
    },

    ["your_eternal_reward"] =
    {
        ids = [225, 574]
    },
    ["kunai"] =
    {
        ids = [356]
    },
    ["big_earner"] =
    {
        ids = [461]
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
    },
};

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

