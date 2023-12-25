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

class SaxtonHale extends Boss
{
    name = "saxton_hale";
    name_proper = "Saxton Hale";
    color = "255 230 0";
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

RegisterBoss(SaxtonHale.name, SaxtonHale);

Include("/bosses/saxton_hale/abilities/sweeping_charge.nut");
Include("/bosses/saxton_hale/abilities/mighty_slam.nut");
Include("/bosses/saxton_hale/misc/colored_arms.nut");
Include("/bosses/saxton_hale/misc/visible_weapon_fix.nut");
Include("/bosses/saxton_hale/misc/no_crit.nut")

AddBossTrait(SaxtonHale.name, SweepingChargeTrait);
AddBossTrait(SaxtonHale.name, BraveJumpTrait);
AddBossTrait(SaxtonHale.name, MightySlamTrait);

AddBossTrait(SaxtonHale.name, FreezeSetupTrait);
AddBossTrait(SaxtonHale.name, DeathCleanupTrait);
AddBossTrait(SaxtonHale.name, MovespeedTrait);
AddBossTrait(SaxtonHale.name, ScreenShakeTrait);
AddBossTrait(SaxtonHale.name, SetupStatRefreshTrait);
AddBossTrait(SaxtonHale.name, TauntHandlerTrait);
AddBossTrait(SaxtonHale.name, PreventNoAttackDamageClass);
AddBossTrait(SaxtonHale.name, DebuffResistanceTrait);
AddBossTrait(SaxtonHale.name, HeadStompTrait);
AddBossTrait(SaxtonHale.name, ReceivedDamageScalingTrait);
AddBossTrait(SaxtonHale.name, StunBreakoutTrait);
AddBossTrait(SaxtonHale.name, BuildingDamageRescaleTrait);
AddBossTrait(SaxtonHale.name, SpawnProtectionTrait);
AddBossTrait(SaxtonHale.name, NoGibFixTrait);
AddBossTrait(SaxtonHale.name, PreventBossCritTrait);

AddBossTrait(SaxtonHale.name, JaratedVoiceLine);
AddBossTrait(SaxtonHale.name, LastMannHidingVoiceLine);
AddBossTrait(SaxtonHale.name, KillVoiceLine);

RegisterCustomWeapon(
    "Hale's Own Fists",
    "Fists",
    null,
    Defaults,
    function (table, player) {
        table.worldModel = "models/empty.mdl";
        table.viewModel = saxton_viewmodel_path;
        table.classArms = saxton_viewmodel_path;
    },
    function (weapon, player)
    {
        if (player.ValidateScriptScope())
            player.GetScriptScope()["hide_base_arms"] <- true;

        weapon.AddAttribute("kill eater", casti2f(9001), -1);

        local isModelFlipped = false;
        try { isModelFlipped = Convars.GetClientConvarValue("cl_flipviewmodels", player.entindex()).tointeger() > 0; }
        catch(ignored) { }
        SetPropInt(weapon, "m_bFlipViewModel", isModelFlipped ? 1 : 0);
    }
);