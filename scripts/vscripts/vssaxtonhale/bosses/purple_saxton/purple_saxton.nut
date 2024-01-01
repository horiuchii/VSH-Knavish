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

class PurpleSaxton extends Boss
{
    name = "purple_saxton";
    name_proper = "Purple Saxton";
    color = "102 51 153";
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
        boss.SetPlayerClass(TF_CLASS_HEAVY);
        boss.Regenerate(true);
        ApplyTraits();
        CreateBoss();
    }

    function CreateBoss()
    {
        boss.SetCustomModelWithClassAnimations(saxton_model_path);
        SetArm(RED_ARM, false);
        SetArm(BLUE_ARM, false);

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

        SetPropInt(boss, "m_nRenderMode", kRenderTransColor);
        EntFireByHandle(boss, "Color", color, -1, boss, boss);

        BossHUD.AddHUD(player, HUDID,
            [
                BossHUDChannel(SweepingCharge, 0.648, 0.92, "255 255 255"),
                BossHUDChannel(BraveJump, 0.768, 0.92, "255 255 255"),
                BossHUDChannel(MightySlam, 0.893, 0.92, "255 255 255")
            ]
        );

        HUD.Get(player, HUDID).Enable();
    }

    function SetArm(color, newStatus)
    {
        local aura = "wearable_vs_hale_aura_";
        local wearable = Entities.FindByName(null, aura + color);
        if (wearable != null)
            wearable.Kill();


        switch (color)
        {
            case RED_ARM:
            {
                redArmEnabled = newStatus;
                wearable = boss.CreateCustomWearable(null, newStatus ? hale_aura_red_on : hale_aura_red_off);
                ColorThirdPersonArms();
                local viewmodel = null;
                while (viewmodel = Entities.FindByClassname(viewmodel, "tf_wearable_vm"))
                {
                    if (viewmodel.GetOwner() == boss)
                        viewmodel.SetBodygroup(1, newStatus ? 1 : 0);
                }

                GetPropEntity(boss, "m_hViewModel").SetBodygroup(1, newStatus ? 1 : 0);
            }
            case BLUE_ARM:
            {
                blueArmEnabled = newStatus;
                wearable = boss.CreateCustomWearable(null, newStatus ? hale_aura_blue_on : hale_aura_blue_off);
                ColorThirdPersonArms();
                local viewmodel = null;
                while (viewmodel = Entities.FindByClassname(viewmodel, "tf_wearable_vm"))
                {
                    if (viewmodel.GetOwner() == boss)
                        viewmodel.SetBodygroup(0, newStatus ? 1 : 0);
                }

                if (newStatus)
                    GetPropEntity(boss, "m_hViewModel").DisableDraw();
                else
                    GetPropEntity(boss, "m_hViewModel").EnableDraw();
            }
        }

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

RegisterBoss(PurpleSaxton);

AddBossTrait(PurpleSaxton.name, SweepingCharge);
AddBossTrait(PurpleSaxton.name, BraveJump);
AddBossTrait(PurpleSaxton.name, MightySlam);
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

RegisterCustomWeapon(
    "Purple Hale's Own Fists",
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