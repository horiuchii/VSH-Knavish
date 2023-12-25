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

::saxton_model_path <- "models/player/saxton_hale.mdl";
::saxton_aura_model_path <- "models/player/items/vsh_effect_body_aura.mdl"
::saxton_viewmodel_path <- "models/weapons/c_models/c_saxton_arms.mdl"
::saxton_viewmodel_index <- GetModelIndex("models/weapons/c_models/c_saxton_arms.mdl")

PrecacheModel(saxton_model_path);
PrecacheModel(saxton_aura_model_path);
PrecacheModel(saxton_viewmodel_path);

class PurpleSaxton extends Boss
{
    name = "purple_saxton";
    name_proper = "Purple Saxton";
    color = "102 51 153";
    tfclass = TF_CLASS_HEAVY;
    HUDID = UniqueString();

    Stats =
    [
        "slamkills"
        "chargekills"
        "bravejumpcount"
    ]

    function OnApply()
    {
        base.OnApply();
        boss.SetPlayerClass(TF_CLASS_HEAVY);
        boss.Regenerate(true);
        ApplyTraits();
        CreateBoss();
    }

    function CreateBoss()
    {
        SetPropInt(boss, "m_bForcedSkin", 1);
        SetPropInt(boss, "m_nForcedSkin", 0);

        boss.SetCustomModelWithClassAnimations(saxton_model_path);
        vsh_vscript.Hale_SetRedArm(boss, false);
        vsh_vscript.Hale_SetBlueArm(boss, false);
        RunWithDelay2(this, 0.1, function() {
            vsh_vscript.Hale_SetRedArm(boss, false);
            vsh_vscript.Hale_SetBlueArm(boss, false);
            boss.CreateCustomWearable(null, saxton_aura_model_path);
            boss.GiveWeapon("Hale's Own Fists");
        });

        boss.SetModelScale(API_GetFloat("boss_scale"), 0);
        boss.GiveWeapon("Hale's Own Fists");

        player.AddCustomAttribute("move speed bonus", 1.8, -1);
        player.AddCustomAttribute("cancel falling damage", 1, -1);
        player.AddCustomAttribute("voice pitch scale", 0, -1);
        //player.AddCustomAttribute("melee range multiplier", 1.2, -1);
        player.AddCustomAttribute("damage bonus", 3, -1);
        //player.AddCustomAttribute("melee bounds multiplier", 1.1, -1);
        player.AddCustomAttribute("crit mod disabled hidden", 0, -1);
        player.AddCustomAttribute("increase player capture value", 2, -1);
        player.AddCustomAttribute("cannot pick up intelligence", 1, -1);
        player.AddCustomAttribute("patient overheal penalty", 1, -1);
        player.AddCustomAttribute("health from packs decreased", 0, -1);
        player.AddCustomAttribute("damage force reduction", 0.75, -1);
        player.AddCustomAttribute("dmg taken from crit reduced", 0.75, -1);

        boss.AddCond(TF_COND_CANNOT_SWITCH_FROM_MELEE);

        SetPropInt(boss, "m_nRenderMode", Constants.ERenderMode.kRenderTransColor);
        EntFireByHandle(boss, "Color", color, -1, boss, boss);

        BossHUD.AddHUD(player, HUDID,
            [
                BossHUDChannel(SweepingChargeTrait, 0.648, 0.92, "255 255 255"),
                BossHUDChannel(BraveJumpTrait, 0.768, 0.92, "255 255 255"),
                BossHUDChannel(MightySlamTrait, 0.893, 0.92, "255 255 255")
            ]
        );

        HUD.Get(player, HUDID).Enable();
    }
}

RegisterBoss(PurpleSaxton.name, PurpleSaxton);

Include("/bosses/saxton_hale/abilities/sweeping_charge.nut");
Include("/bosses/saxton_hale/abilities/mighty_slam.nut");
Include("/bosses/saxton_hale/misc/colored_arms.nut");
Include("/bosses/saxton_hale/misc/visible_weapon_fix.nut");
Include("/bosses/saxton_hale/misc/no_crit.nut")

AddBossTrait(PurpleSaxton.name, SweepingChargeTrait);
AddBossTrait(PurpleSaxton.name, BraveJumpTrait);
AddBossTrait(PurpleSaxton.name, MightySlamTrait);

AddBossTrait(PurpleSaxton.name, FreezeSetupTrait);
AddBossTrait(PurpleSaxton.name, DeathCleanupTrait);
AddBossTrait(PurpleSaxton.name, MovespeedTrait);
AddBossTrait(PurpleSaxton.name, ScreenShakeTrait);
AddBossTrait(PurpleSaxton.name, SetupStatRefreshTrait);
AddBossTrait(PurpleSaxton.name, TauntHandlerTrait);
AddBossTrait(PurpleSaxton.name, PreventNoAttackDamageClass);
AddBossTrait(PurpleSaxton.name, DebuffResistanceTrait);
AddBossTrait(PurpleSaxton.name, HeadStompTrait);
AddBossTrait(PurpleSaxton.name, ReceivedDamageScalingTrait);
AddBossTrait(PurpleSaxton.name, StunBreakoutTrait);
AddBossTrait(PurpleSaxton.name, BuildingDamageRescaleTrait);
AddBossTrait(PurpleSaxton.name, SpawnProtectionTrait);
AddBossTrait(PurpleSaxton.name, NoGibFixTrait);
AddBossTrait(PurpleSaxton.name, PreventBossCritTrait);

AddBossTrait(PurpleSaxton.name, JaratedVoiceLine);
AddBossTrait(PurpleSaxton.name, LastMannHidingVoiceLine);
AddBossTrait(PurpleSaxton.name, KillVoiceLine);