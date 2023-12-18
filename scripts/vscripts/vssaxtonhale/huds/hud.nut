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

::HUDIdentifiers <- {};
::HUDTable <- {};
::hud_text <- SpawnEntityFromTable("game_text", {});

class HUD
{
    function Add(player, identifier, hud)
    {
        printl("\n\nADD " + player + "\n\n");
        local size = HUDIdentifiers[player].len();
        local i = 0;
        for (; i < size; i++)
        {
            if (HUDIdentifiers[player][i].priority < identifier.priority)
            {
                break;
            }
        }

        HUDIdentifiers[player].insert(i, identifier);
        HUDTable[player][identifier.id] <- hud;
        foreach (index, channel in HUDTable[player][identifier.id].channels)
        {
            channel.player = player;
            channel.params.channel = index;
        }
    }
}
::HUD <- HUD();

class HUDIdentifier
{
    id = ""
    priority = 0

    function constructor(_id, _priority)
    {
        id = _id;
        priority = _priority;
    }
}
::HUDIdentifier <- HUDIdentifier;

class HUDObject
{
    enabled = false
	channels = []

    function constructor(_channels = {})
    {
        channels = _channels;
    }

	function UpdateChannels()
	{
        if (!enabled)
        {
            return;
        }

        foreach (index, channel in channels)
        {
            channel.params.channel = index;
            channel.Update();
        }
	}

    function Enable()
    {
        enabled = true;
        foreach (index, channel in channels)
        {
            channel.params.channel = index;
            channel.OnEnabled();
        }
    }

    function Disable()
    {
        enabled = false;
        foreach (index, channel in channels)
        {
            channel.params.channel = index;
            channel.OnDisabled();
            EntFireByHandle(hud_text, "AddOutput", "channel " + index, -1, null, null);
            EntFireByHandle(hud_text, "AddOutput", "message ", -1, null, null);
            EntFireByHandle(hud_text, "Display", "", -1, channel.player, channel.player);
        }
    }
}
::HUDObject <- HUDObject;

class HUDChannel
{
    player = null;
    params =
    {
        x = 0
        y = 0
        channel = 0
        color = "255 255 255"
        holdtime = 0
        fadein = 0
        fadeout = 0
        message = ""
    }

    function constructor(_x = 0, _y = 0, _color = "255 255 255", _holdtime = 0, _fadein = 0, _fadeout = 0)
    {
        params.x = _x;
        params.y = _y;
        params.color = _color;
        params.fadein = _fadein;
        params.fadeout = _fadeout;
        params.holdtime = _holdtime;
    }

    function SetGameTextParams()
    {
        printl(params.message);
        EntFireByHandle(hud_text, "AddOutput", "channel " + params.channel, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "x " + params.x, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "y " + params.y, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "color " + params.color, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "fadein " + params.fadein, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "fadeout " + params.fadeout, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "holdtime " + params.holdtime, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "message " + params.message, -1, null, null);
    }

    function Update() { return; }
    function OnEnabled() { return; }
    function OnDisabled() { return; }
}
::HUDChannel <- HUDChannel;

::game_text_merc_hud <- SpawnEntityFromTable("game_text",
{
    color = "236 227 203",
    channel = 1,
    fadein = 0,
    fadeout = 0,
    holdtime = 500,
    message = "",
    x = 0.481,
    y = 0.788
});

::env_hudhint <- SpawnEntityFromTable("env_hudhint", {message = "%+inspect% HOLD TO VIEW WEAPON STATS%+attack3% DOUBLE TAP OR CHAT /vshmenu TO OPEN VSH MENU"});
::env_hudhint_boss <- SpawnEntityFromTable("env_hudhint", {message = "%+attack3% DOUBLE TAP OR CHAT /vshmenu TO OPEN VSH MENU"});
bossBarTicker <- 0;

AddListener("tick_frame", 2, function ()
{
    foreach (player in GetValidClients())
    {
        if (IsPlayerABot(player))
            continue;

        foreach (identifier in HUDIdentifiers[player])
        {
            if (HUDTable[player][identifier.id].enabled)
            {
                HUDTable[player][identifier.id].UpdateChannels();
                break;
            }
        }
    }
});

AddListener("spawn", 0, function (player, params)
{
    RunWithDelay2(this, 1.0, function ()
    {
        EntFireByHandle(IsBoss(player) ? env_hudhint_boss : env_hudhint, "ShowHudHint", "", 0, player, player);
    })
});

AddListener("tick_only_valid", 2, function (deltaTime)
{
    TickBossBar(GetBossPlayers()[0]); //todo not built for duo-bosses
})

::TickBossBar <- function(boss)
{
    if (boss.IsDead())
        return;

    if(IsRoundSetup())
    {
        SetPropInt(pd_logic, "m_nBlueScore", 0);
        SetPropInt(pd_logic, "m_nBlueTargetPoints", 0);
        SetPropInt(pd_logic, "m_nMaxPoints", 0);
        SetPropInt(pd_logic, "m_nRedScore", GetAliveMercCount());
        return;
    }

    if (bossBarTicker < 2)
    {
        bossBarTicker++;
        SetPropInt(pd_logic, "m_nBlueScore", 0);
        SetPropInt(pd_logic, "m_nBlueTargetPoints", 0);
        return
    }
    local barValue = clampCeiling(boss.GetHealth(), boss.GetMaxHealth());
    SetPropInt(pd_logic, "m_nBlueScore", barValue);
    SetPropInt(pd_logic, "m_nBlueTargetPoints", barValue);
    SetPropInt(pd_logic, "m_nMaxPoints", boss.GetMaxHealth());
    SetPropInt(pd_logic, "m_nRedScore", GetAliveMercCount());
}

::UpdateDamageHUD <- function(player)
{
    local number = floor(player in damage_score ? damage_score[player] : 0);
    local offset = number < 10 ? 0.498 : number < 100 ? 0.493 : number < 1000 ? 0.491 : 0.487;

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 0", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + number, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "y 0.788", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "x " + offset, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
}

::UpdateWeaponStatHUD <- function(player)
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

    EntFireByHandle(game_text_merc_hud, "AddOutput", "channel 1", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "message " + weapon_primary + weapon_secondary + weapon_melee, 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "y 0.295", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "AddOutput", "x 0.71", 0, player, player);
    EntFireByHandle(game_text_merc_hud, "Display", "", 0, player, player);
}