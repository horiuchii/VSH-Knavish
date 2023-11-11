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
    ["kgb"] =
    {
        ids = [43]
    },
	["gru"] =
    {
        ids = [239, 1084, 1100]
    },
    ["market_gardener"] =
    {
        ids = [416]
    },
    ["holiday_punch"] =
    {
        ids = [656]
    },
    ["eyelander"] =
    {
        ids = [132, 266, 482, 1082]
    },
    ["natascha"] =
    {
        ids = [41]
    },
    ["kunai"] =
    {
        ids = [356]
    },
    ["big_earner"] =
    {
        ids = [461]
    },
    ["your_eternal_reward"] =
    {
        ids = [225, 574]
    },
    ["warriors_spirit"] =
    {
        ids = [310]
    },
    ["direct_hit"] =
    {
        ids = [127]
    },
    ["reserve_shooter"] =
    {
        ids = [415]
    },
    ["candy_cane"] =
    {
        ids = [317]
    },
    ["fan_o_war"] =
    {
        ids = [355]
    },
    ["rocket_jumper"] =
    {
        ids = [237]
    },
    ["dead_ringer"] =
    {
        ids = [59]
    },
    ["ubersaw"] =
    {
        ids = [37, 1003]
    },
    ["quick_fix"] =
    {
        ids = [411]
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
    ["quickiebomb_launcher"] =
    {
        ids = [1150]
    },
    ["sticky_jumper"] =
    {
        ids = [265]
    },
    ["force_a_nature"] =
    {
        ids = [45, 1078]
    },
    ["disciplinary_action"] =
    {
        ids = [447]
    },
    ["eviction_notice"] =
    {
        ids = [426]
    },
    ["diamondback"] =
    {
        ids = [525]
    },
    ["powerjack"] =
    {
        ids = [214]
    },
    ["baby_face_blaster"] =
    {
        ids = [772]
    },
    ["letranger"] =
    {
        ids = [224]
    },
    ["back_scratcher"] =
    {
        ids = [326]
    },
    ["degreaser"] =
    {
        ids = [215]
    },
    ["claidheamhmor"] =
    {
        ids = [327]
    },
    ["xbow"] =
    {
        ids = [305, 1079]
    },
    ["syringegun"] =
    {
        ids = [17, 204]
    },
    ["overdose"] =
    {
        ids = [412]
    },
    ["blutsauger"] =
    {
        ids = [36]
    },
    ["vitasaw"] =
    {
        ids = [173]
    },
    ["sunonastick"] =
    {
        ids = [349]
    },
    ["mad_milk"] =
    {
        ids = [222, 1121]
    },
    ["airstrike"] =
    {
        ids = [1104]
    },
    ["half_zatoichi"] =
    {
        ids = [357]
    },
    ["fists_of_steel"] =
    {
        ids = [331]
    },
    ["ambassador"] =
    {
        ids = [61, 1006]
    },
    ["base_jumper"] =
    {
        ids = [1101]
    },
    ["invis_watch"] =
    {
        ids = [30]
    },
    ["cloak_and_dagger"] =
    {
        ids = [60]
    },
    ["equalizer"] =
    {
        ids = [128]
    },
    ["escape_plan"] =
    {
        ids = [775]
    },
    ["hitmans_heatmaker"] =
    {
        ids = [752]
    },
    ["booties"] =
    {
        ids = [405]
    },
    ["boot_legger"] =
    {
        ids = [608]
    },
    ["smg"] =
    {
        ids = [16, 203, 1149, 15001, 15022, 15032, 15037, 15058, 15076, 15110, 15134, 15153]
    },
    ["cleaners_carbine"] =
    {
        ids = [751]
    },
    ["mantreads"] =
    {
        ids = [444]
    },
    ["chargin_targe"] =
    {
        ids = [131, 1144]
    },
    ["splendid_screen"] =
    {
        ids = [406]
    },
    ["tide_turner"] =
    {
        ids = [1099]
    },
    ["razorback"] =
    {
        ids = [57]
    },
    ["thermal_thruster"] =
    {
        ids = [1179]
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
        return weapon.GetClassname() == "tf_weapon_sword" || weapon.GetClassname() == "tf_weapon_katana";
    }
    else if(name == "any_demo_boots")
    {
        return WeaponIs(weapon, "booties") || WeaponIs(weapon, "boot_legger")
    }
    else if(name == "any_demo_shield")
    {
        return WeaponIs(weapon, "chargin_targe")
        || WeaponIs(weapon, "splendid_screen")
        || WeaponIs(weapon, "tide_turner");
    }
    else
    {
        return WeaponTable.rawin(name) && WeaponTable[name].ids.find(index) != null;
    }
}

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