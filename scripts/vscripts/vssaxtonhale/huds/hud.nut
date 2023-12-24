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
::hud_text <- SpawnEntityFromTable("game_text",
{
    x = -1
    y = -1
    color = "255 255 255"
    holdtime = 500
    fadein = 0
    fadeout = 0
    message = " "
});

class HUD
{
    function Add(player, identifier, hud)
    {
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
        HUDTable[player][identifier.id].player = player;
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
    player = null
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

        local i = 0;
        foreach (index, channel in channels)
        {
            channel.params.channel = index;
            channel.Update();
            i++;
        }

        for (; i < 2; i++)
        {
            EntFireByHandle(hud_text, "AddOutput", "channel " + i, -1, null, null);
            EntFireByHandle(hud_text, "AddOutput", "message " + " ", -1, null, null);
            EntFireByHandle(hud_text, "Display", "", -1, player, player);
        }
	}

    function Enable()
    {
        enabled = true;

        // Only fire Enable if the highest priority HUD is this one
        foreach (identifier in HUDIdentifiers[player])
        {
            if (HUDTable[player][identifier.id].enabled)
            {
                if (HUDTable[player][identifier.id] == this)
                {
                    ClearChannels();
                    foreach (index, channel in channels)
                    {
                        channel.params.channel = index;
                        channel.OnEnabled();
                    }
                }

                break;
            }
        }
    }

    function Disable()
    {
        // Only fire Disable if the highest priority HUD is this one
        foreach (identifier in HUDIdentifiers[player])
        {
            if (HUDTable[player][identifier.id].enabled)
            {
                if (HUDTable[player][identifier.id] == this)
                {
                    ClearChannels();
                    foreach (index, channel in channels)
                    {
                        channel.params.channel = index;
                        channel.OnDisabled();
                    }

                    enabled = false;

                    // Enable the next enabled HUD in identifiers
                    foreach (identifier in HUDIdentifiers[player])
                    {
                        if (HUDTable[player][identifier.id].enabled)
                        {
                            HUDTable[player][identifier.id].Enable();
                            break;
                        }
                    }
                }

                break;
            }
        }
    }

    function ClearChannels()
    {
        player.SetScriptOverlayMaterial(null);
        for(local i = 0; i < 2; i++)
        {
            EntFireByHandle(hud_text, "AddOutput", "channel " + i, -1, null, null);
            EntFireByHandle(hud_text, "AddOutput", "message " + " ", -1, null, null);
            EntFireByHandle(hud_text, "Display", "", -1, player, player);
        }
    }
}
::HUDObject <- HUDObject;

class HUDChannel
{
    player = null;
    params = null;

    function constructor(_x = 0, _y = 0, _color = "255 255 255", _holdtime = 0, _fadein = 0, _fadeout = 0)
    {
        params = {
            scope = null
            x = 0
            y = 0
            channel = 0
            color = "255 255 255"
            holdtime = 500
            fadein = 0
            fadeout = 0
            message = ""
        }

        params.scope = this;
        params.x = _x;
        params.y = _y;
        params.color = _color;
        params.fadein = _fadein;
        params.fadeout = _fadeout;
        params.holdtime = _holdtime;
    }

    function SetGameTextParams()
    {
        EntFireByHandle(hud_text, "AddOutput", "channel " + params.channel, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "x " + params.x, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "y " + params.y, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "color " + params.color, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "fadein " + params.fadein, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "fadeout " + params.fadeout, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "holdtime " + params.holdtime, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "message " + params.message, -1, null, null);
    }

    function Update()
    {
        Display();
    }
    function OnEnabled()
    {
        Display();
    }
    function OnDisabled()
    {
        Clear();
    }
    function Clear()
    {
        EntFireByHandle(hud_text, "AddOutput", "channel " + params.channel, -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "x -1", -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "y -1", -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "color 255 255 255", -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "fadein 0", -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "fadeout 0", -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "holdtime 500", -1, null, null);
        EntFireByHandle(hud_text, "AddOutput", "message ", -1, null, null);
        EntFireByHandle(hud_text, "Display", "", -1, player, player);
    }
    function Display()
    {
        SetGameTextParams();
        EntFireByHandle(hud_text, "Display", params.message, -1, player, player);
    }
}
::HUDChannel <- HUDChannel;

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
    player.SetScriptOverlayMaterial(null);
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