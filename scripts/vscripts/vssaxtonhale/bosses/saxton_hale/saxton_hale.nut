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

::saxton_model_path <- ("models/player/saxton_hale.mdl");
::saxton_aura_model_path <- "models/player/items/vsh_effect_body_aura.mdl";
::saxton_viewmodel_path <- "models/weapons/c_models/c_saxton_arms.mdl";
::saxton_viewmodel_index <- GetModelIndex("models/weapons/c_models/c_saxton_arms.mdl");

::hale_aura_red_off <- "models/player/items/vsh_effect_ltarm_aura.mdl";
::hale_aura_blue_off <- "models/player/items/vsh_effect_rtarm_aura.mdl";
::hale_aura_red_on <- "models/player/items/vsh_effect_ltarm_aura_megapunch.mdl";
::hale_aura_blue_on <- "models/player/items/vsh_effect_rtarm_aura_chargedash.mdl";

PrecacheModel(hale_aura_red_off);
PrecacheModel(hale_aura_blue_off);
PrecacheModel(hale_aura_red_on);
PrecacheModel(hale_aura_blue_on);
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

    redArmEnabled = false;
    blueArmEnabled = false;
    RED_ARM = "red";
    BLUE_ARM = "blue";

    Stats =
    [
        "slamkills"
        "chargekills"
        "bravejumpcount"
    ]

    function OnApply()
    {
        base.OnApply();
        boss.SetPlayerClass(tfclass);
        boss.Regenerate(true);
        ApplyTraits();
        CreateBoss();
    }

    function CreateBoss()
    {
        boss.SetCustomModelWithClassAnimations(saxton_model_path);
        SetArm(RED_ARM, false);
        SetArm(BLUE_ARM, false);
        SetPropInt(player, "m_nForcedSkin", 0);
        SetPropBool(player, "m_bForcedSkin", true);

        RunWithDelay2(this, 0.1, function()
        {
            boss.CreateCustomWearable(null, saxton_aura_model_path);
            boss.GiveWeapon("Hale's Own Fists");
        });

        boss.SetModelScale(API_GetFloat("boss_scale"), 0);

        player.AddCustomAttribute("move speed bonus", 1.8, -1);
        player.AddCustomAttribute("cancel falling damage", 1, -1);
        player.AddCustomAttribute("voice pitch scale", 0, -1);
        player.AddCustomAttribute("damage bonus", 3, -1);
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
                BossHUDChannel(SweepingCharge, 0.648, 0.92, "255 255 255"),
                BossHUDChannel(BraveJump, 0.768, 0.92, "255 255 255"),
                BossHUDChannel(MightySlam, 0.893, 0.92, "255 255 255")
            ]
        );

        HUD.Get(player, HUDID).Enable();
    }

    function OnTickAlive(timeDelta)
    {
        local weapon = boss.GetActiveWeapon();
        if (weapon != null && weapon.IsValid())
        {
            SetPropInt(weapon, "m_iWorldModelIndex", empty_model_index);
            weapon.DisableDraw();
            SetPropInt(weapon, "m_nRenderMode", 1);
            weapon.SetModelScale(0.05, 0);
        }
    }

    function SetArm(color, newStatus)
    {
        local aura = "wearable_vs_hale_aura_";
        local wearable = Entities.FindByName(null, aura + color);
        if (wearable != null)
        {
            wearable.Kill();
        }

        local viewmodel = null;
        while (viewmodel = Entities.FindByClassname(viewmodel, "tf_wearable_vm"))
        {
            if (viewmodel.GetOwner() == boss)
                viewmodel.SetBodygroup(0, newStatus ? 1 : 0);
        }

        switch (color)
        {
            case RED_ARM:
            {
                redArmEnabled = newStatus;
                wearable = boss.CreateCustomWearable(null, newStatus ? hale_aura_red_on : hale_aura_red_off);
                GetPropEntity(boss, "m_hViewModel").SetBodygroup(1, newStatus ? 1 : 0);
            }
            case BLUE_ARM:
            {
                blueArmEnabled = newStatus;
                wearable = boss.CreateCustomWearable(null, newStatus ? hale_aura_blue_on : hale_aura_blue_off);

                if (newStatus)
                    GetPropEntity(boss, "m_hViewModel").DisableDraw();
                else
                    GetPropEntity(boss, "m_hViewModel").EnableDraw();
            }
        }

        ColorThirdPersonArms();
        wearable.KeyValueFromString("targetname", aura + color);
    }

    function ColorThirdPersonArms()
    {
        local newSkin = 0;
        if (redArmEnabled)
        {
            newSkin = blueArmEnabled ? 4 : 2;
        }
        else
        {
            newSkin = blueArmEnabled ? 3 : 0;
        }

        SetPropInt(boss, "m_nForcedSkin", newSkin);
    }

    function SweepingCharge_WindUp(voiceRNG)
    {
        EmitPlayerVO(boss, "charge_" + voiceRNG);
        EmitSoundOn("vsh_sfx.hale_charge", boss);
        SetArm(BLUE_ARM, true);
    }

    function SweepingCharge_Perform(voiceRNG, chargeDuration)
    {
        EmitPlayerVO(boss, "dash_" + voiceRNG);
        EmitSoundOn("vsh_sfx.hale_dash", boss);
        local dashDome = boss.CreateCustomWearable(null, saxton_dash_effect_model_path);
        EntFireByHandle(dashDome, "Kill", "", chargeDuration, null, null);
    }

    function SweepingCharge_Finish()
    {
        SetArm(BLUE_ARM, false);
    }
}

RegisterBoss(SaxtonHale);

Include("/bosses/saxton_hale/misc/visible_weapon_fix.nut");

AddBossTrait(SaxtonHale.name, SweepingCharge);
AddBossTrait(SaxtonHale.name, BraveJump);
AddBossTrait(SaxtonHale.name, MightySlam);
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