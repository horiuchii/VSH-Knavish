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
::saxton_hud <- UniqueString();

PrecacheModel(saxton_model_path);
PrecacheModel(saxton_aura_model_path);
PrecacheModel(saxton_viewmodel_path);

class SaxtonHale extends Boss
{
    name = "saxton_hale";
    name_proper = "Saxton Hale";
    color = "255 230 0";
    tfclass = TF_CLASS_HEAVY;

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

        boss.AddCustomAttribute("move speed bonus", 1.8, -1);
        boss.AddCustomAttribute("cancel falling damage", 1, -1);
        boss.AddCustomAttribute("voice pitch scale", 0, -1);
        boss.AddCustomAttribute("melee range multiplier", 1.2, -1);
        boss.AddCustomAttribute("damage bonus", 3, -1);
        boss.AddCustomAttribute("melee bounds multiplier", 1.1, -1);
        boss.AddCustomAttribute("crit mod disabled hidden", 0, -1);
        boss.AddCustomAttribute("increase player capture value", 2, -1);
        boss.AddCustomAttribute("cannot pick up intelligence", 1, -1);
        boss.AddCustomAttribute("patient overheal penalty", 1, -1);
        boss.AddCustomAttribute("health from packs decreased", 0, -1);
        boss.AddCustomAttribute("damage force reduction", 0.75, -1);
        boss.AddCustomAttribute("dmg taken from crit reduced", 0.75, -1);

        boss.AddCond(TF_COND_CANNOT_SWITCH_FROM_MELEE);

        BossHUD.AddHUD(player,
            [
                BossHUDChannel(SweepingChargeTrait, 0.648, 0.92, "255 255 255"),
                BossHUDChannel(BraveJumpTrait, 0.768, 0.92, "255 255 255"),
                BossHUDChannel(MightySlamTrait, 0.893, 0.92, "255 255 255")
            ]
        );


        HUD.Get(player, BossHUD.HUDID).Enable();
    }
}

RegisterBoss("saxton_hale", SaxtonHale);

Include("/bosses/saxton_hale/abilities/sweeping_charge.nut");
Include("/bosses/saxton_hale/abilities/mighty_slam.nut");
Include("/bosses/saxton_hale/misc/colored_arms.nut");
Include("/bosses/saxton_hale/misc/visible_weapon_fix.nut");
Include("/bosses/saxton_hale/misc/no_crit.nut")

AddBossTrait("saxton_hale", SweepingChargeTrait);
AddBossTrait("saxton_hale", BraveJumpTrait);
AddBossTrait("saxton_hale", MightySlamTrait);

AddBossTrait("saxton_hale", FreezeSetupTrait);
AddBossTrait("saxton_hale", DeathCleanupTrait);
AddBossTrait("saxton_hale", MovespeedTrait);
AddBossTrait("saxton_hale", ScreenShakeTrait);
AddBossTrait("saxton_hale", SetupStatRefreshTrait);
AddBossTrait("saxton_hale", TauntHandlerTrait);
AddBossTrait("saxton_hale", DebuffResistanceTrait);
AddBossTrait("saxton_hale", HeadStompTrait);
AddBossTrait("saxton_hale", ReceivedDamageScalingTrait);
AddBossTrait("saxton_hale", StunBreakoutTrait);
AddBossTrait("saxton_hale", BuildingDamageRescaleTrait);
AddBossTrait("saxton_hale", SpawnProtectionTrait);
AddBossTrait("saxton_hale", NoGibFixTrait);
AddBossTrait("saxton_hale", PreventBossCritTrait);

AddBossTrait("saxton_hale", JaratedVoiceLine);
AddBossTrait("saxton_hale", LastMannHidingVoiceLine);
AddBossTrait("saxton_hale", KillVoiceLine);

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