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

::hudAbilityInstances <- {};

class AbilityHudTrait extends BossTrait
{
    in_vsh_menu = false;
    game_text_tip = null;
    game_text_charge = null;
    game_text_jump = null;
    game_text_slam = null;

    //₁₂₃₄₅₆₇₈₉₀
    //¹²³⁴⁵⁶⁷⁸⁹⁰
    big2small = {
        " ": " ", //" "
        "x": " Χ "
        "r": "✔",
        "1": "₁",
        "2": "₂",
        "3": "₃",
        "4": "₄",
        "5": "₅",
        "6": "₆",
        "7": "₇",
        "8": "₈",
        "9": "₉",
        "0": "₀",
    };

    function OnApply()
    {
        game_text_charge = SpawnEntityFromTable("game_text",
        {
            color = "255 255 255",
            color2 = "0 0 0",
            channel = 0,
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = 250,
            message = "0",
            spawnflags = 0,
            x = 0.67,
            y = 0.91
        });

        game_text_jump = SpawnEntityFromTable("game_text",
        {
            color = "255 255 255",
            color2 = "0 0 0",
            channel = 1,
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = 250,
            message = "0",
            spawnflags = 0,
            x = 0.778,
            y = 0.91
        });

        game_text_slam = SpawnEntityFromTable("game_text",
        {
            color = "255 255 255",
            color2 = "0 0 0",
            channel = 2,
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = 250,
            message = "0",
            spawnflags = 0,
            x = 0.885,
            y = 0.91
        });

        game_text_tip = SpawnEntityFromTable("game_text",
        {
            color = "255 255 255",
            color2 = "0 0 0",
            channel = 3,
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = 9999,
            message = "",
            spawnflags = 0,
            x = 0.665,
            y = 0.955
        });

        RunWithDelay2(this, 0.2, function () {
            EntFireByHandle(game_text_tip, "Display", "", 0, boss, boss);
        });
    }

    function OnTickAlive(timeDelta)
    {
        if (!(player in hudAbilityInstances))
            return;

        if (GetPropInt(player, "m_nButtons") & IN_SCORE)
        {
            player.SetScriptOverlayMaterial(null);
            return;
        }

        if(IsInVSHMenu(player))
        {
            if(!in_vsh_menu)
            {
                EntFireByHandle(game_text_charge, "AddOutput", "message ", 0, boss, boss);
                EntFireByHandle(game_text_charge, "Display", "", 0, boss, boss);
                EntFireByHandle(game_text_slam, "AddOutput", "message ", 0, boss, boss);
                EntFireByHandle(game_text_slam, "Display", "", 0, boss, boss);
                EntFireByHandle(game_text_tip, "AddOutput", "message ", 0, boss, boss);
                EntFireByHandle(game_text_tip, "Display", "", 0, boss, boss);
                in_vsh_menu = true;
            }
            return;
        }

        in_vsh_menu = false;

        local progressBarTexts = [];
        local overlay = "";
        foreach(ability in hudAbilityInstances[player])
        {
            local percentage = ability.MeterAsPercentage();
            local progressBarText = BigToSmallNumbers(ability.MeterAsNumber())+" ";
            local i = 13;
            for(; i < clampCeiling(100, percentage); i+=13)
                progressBarText += "▰";
            for(; i <= 100; i+=13)
                progressBarText += "▱";
            progressBarTexts.push(progressBarText);
            if (percentage >= 100)
                overlay += "on_";
            else
                overlay += "off_";
        }

        EntFireByHandle(game_text_charge, "AddOutput", "message "+progressBarTexts[0], 0, boss, boss);
        EntFireByHandle(game_text_charge, "Display", "", 0, boss, boss);

        EntFireByHandle(game_text_jump, "AddOutput", "message "+progressBarTexts[1], 0, boss, boss);
        EntFireByHandle(game_text_jump, "Display", "", 0, boss, boss);

        EntFireByHandle(game_text_slam, "AddOutput", "message "+progressBarTexts[2], 0, boss, boss);
        EntFireByHandle(game_text_slam, "Display", "", 0, boss, boss);

        EntFireByHandle(game_text_tip, "AddOutput", "message " + "Hold 'Reload' Double Jump Hold 'Crouch'", 0, boss, boss);
        EntFireByHandle(game_text_tip, "Display", "", 0, boss, boss);

        player.SetScriptOverlayMaterial(API_GetString("ability_hud_folder") + "/" + overlay);
    }

    function OnDeath(attacker, params)
    {
        EntFireByHandle(game_text_charge, "AddOutput", "message ", 0, boss, boss);
        EntFireByHandle(game_text_charge, "Display", "", 0, boss, boss);
        EntFireByHandle(game_text_jump, "AddOutput", "message ", 0, boss, boss);
        EntFireByHandle(game_text_jump, "Display", "", 0, boss, boss);
        EntFireByHandle(game_text_slam, "AddOutput", "message ", 0, boss, boss);
        EntFireByHandle(game_text_slam, "Display", "", 0, boss, boss);

        EntFireByHandle(game_text_tip, "AddOutput", "message ", 0, boss, boss);
        EntFireByHandle(game_text_tip, "Display", "", 0, boss, boss);

        if(!IsInVSHMenu(player))
            player.SetScriptOverlayMaterial("");
    }

    function BigToSmallNumbers(input)
    {
        local result = "";
        foreach (char in input)
            result += big2small[char.tochar()];
        return result;
    }
};