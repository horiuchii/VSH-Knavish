class InspectHUD
{
    HUDPriority = 10;
    HUDID = UniqueString();

    function AddHUD(player)
    {
        HUD.Add(player, CreateIdentifier(), CreateHUDObject());
    }

    function CreateIdentifier()
    {
        return HUDIdentifier(HUDID, HUDPriority);
    }

    function CreateHUDObject()
    {
        return HUDObject(
            [
                MercenaryHUD.CreateDamageChannel(),
                CreateWeaponStatsChannel()
            ]
        );
    }

    function CreateWeaponStatsChannel()
    {
        return class extends HUDChannel
        {
            function OnEnabled()
            {
                InspectHUD.UpdateWeaponStatHUD(player, params);
                base.OnEnabled();
            }
            function Update()
            {
                return;
            }
        }(0.71, 0.295, "255 255 255", 500, 0, 0);
    }

    function OnFrameTick()
    {
        foreach (player in GetValidMercs())
        {
            if (!IsMerc(player))
                continue;

            if (player.IsInspecting() && !HUDTable[player][HUDID].enabled)
            {
                HUDTable[player][HUDID].Enable();
            }
            else if (!player.IsInspecting() && HUDTable[player][HUDID].enabled)
            {
                HUDTable[player][HUDID].Disable();
            }
        }
    }

    function UpdateWeaponStatHUD(player, params)
    {
        EntFireByHandle(env_hudhint, "HideHudHint", "", 0, player, player);
        //display weapon stats
        local weapon_primary = "";
        if (player.GetPlayerClass() == TF_CLASS_DEMOMAN && player.HasWearable("any_demo_boots"))
            weapon_primary = GetWeaponDescription("booties");
        else
            weapon_primary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY)))

        local weapon_secondary = "";
        if (player.GetPlayerClass() == TF_CLASS_SNIPER
            && player.HasWearable("any_sniper_backpack"))
        {
            local wearable = player.GetWearable("any_sniper_backpack");
            weapon_secondary = GetWeaponDescription(GetWeaponName(wearable));
        }
        else if (player.GetPlayerClass() == TF_CLASS_DEMOMAN
            && player.HasWearable("any_demo_shield"))
        {
            local wearable = player.GetWearable("any_demo_shield");
            weapon_secondary = GetWeaponDescription(GetWeaponName(wearable));
        }
        else if (player.GetPlayerClass() == TF_CLASS_SPY)
            weapon_secondary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.INVIS_WATCH)));
        else
            weapon_secondary = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY)));

        local weapon_melee = GetWeaponDescription(GetWeaponName(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE)));

        player.SetScriptOverlayMaterial(API_GetString("ability_hud_folder") + "/weapon_info");
        params.message = weapon_primary + weapon_secondary + weapon_melee;
    }
}
::InspectHUD <- InspectHUD();

AddListener("tick_frame", 2, function ()
{
    InspectHUD.OnFrameTick();
});