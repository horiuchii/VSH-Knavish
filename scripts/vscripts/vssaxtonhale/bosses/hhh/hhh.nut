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

::hhh_model_path <- "models/bots/headless_hatman.mdl";
::hhh_headtaker_path <- "models/weapons/c_models/c_headtaker/c_headtaker.mdl";

PrecacheModel(hhh_model_path);
PrecacheModel(hhh_headtaker_path);

class HHH extends Boss
{
    name = "hhh";
    name_proper = "Horseless Headless Horsemann";
    color = "102 51 153";
    tfclass = TF_CLASS_DEMOMAN;
    HUDID = UniqueString();

    Stats =
    [

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
        //boss.SetCustomModelWithClassAnimations(hhh_model_path);

        RunWithDelay2(this, 0.1, function()
        {
            boss.GiveWeapon("Horseless Headless Horsemann's Headtaker");
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
        boss.AddHudHideFlags(HIDEHUD_PIPES_AND_CHARGE);

        BossHUD.AddHUD(player, HUDID,
            [
                BossHUDChannel(ScareTrait, 0.648, 0.92, "255 255 255"),
                BossHUDChannel(WallClimbTrait, 0.768, 0.92, "255 255 255"),
                //BossHUDChannel(MightySlam, 0.893, 0.92, "255 255 255")
            ]
        );

        HUD.Get(player, HUDID).Enable();
    }

    function WallClimb_Perform(newVelocity)
    {
        newVelocity.z = 750.0;
    }
}

RegisterBoss(HHH);

AddBossTrait(HHH.name, ScareTrait);
AddBossTrait(HHH.name, WallClimbTrait);
AddBossTrait(HHH.name, FreezeSetupTrait);
AddBossTrait(HHH.name, DeathCleanupTrait);
AddBossTrait(HHH.name, MovespeedTrait);
AddBossTrait(HHH.name, ScreenShakeTrait);
AddBossTrait(HHH.name, SetupStatRefreshTrait);
AddBossTrait(HHH.name, TauntHandlerTrait);
AddBossTrait(HHH.name, PreventNoAttackDamageClass);
AddBossTrait(HHH.name, DebuffResistanceTrait);
AddBossTrait(HHH.name, HeadStompTrait);
AddBossTrait(HHH.name, ReceivedDamageScalingTrait);
AddBossTrait(HHH.name, BuildingDamageRescaleTrait);
AddBossTrait(HHH.name, SpawnProtectionTrait);
AddBossTrait(HHH.name, NoGibFixTrait);

RegisterCustomWeapon(
    "Horseless Headless Horsemann's Headtaker",
    "Horseless Headless Horseman's Headtaker",
    null,
    Defaults,
    function (table, player) {
        table.worldModel = hhh_headtaker_path;
        /*table.viewModel = saxton_viewmodel_path;
        table.classArms = saxton_viewmodel_path;*/
        table.gw_props += WipeAttributes;
    },
    function (weapon, player)
    {
        //if (player.ValidateScriptScope())
        //    player.GetScriptScope()["hide_base_arms"] <- true;

        //weapon.AddAttribute("kill eater", casti2f(9001), -1);

        local isModelFlipped = false;
        try { isModelFlipped = Convars.GetClientConvarValue("cl_flipviewmodels", player.entindex()).tointeger() > 0; }
        catch(ignored) { }
        SetPropInt(weapon, "m_bFlipViewModel", isModelFlipped ? 1 : 0);
    }
);