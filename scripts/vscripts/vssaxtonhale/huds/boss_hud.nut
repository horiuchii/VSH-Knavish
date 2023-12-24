class BossHUD
{
    HUDID = UniqueString();
    HUDPriority = 1;

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

    function AddHUD(player, channels)
    {
        HUD.Add(player, CreateIdentifier(), HUDObject(channels));
    }

    function CreateIdentifier()
    {
        return HUDIdentifier(HUDID, HUDPriority);
    }

    function OnTickAlive(timeDelta)
    {
        foreach (player in GetBossPlayers())
        {
            if (!HUDTable[player][HUDID].enabled)
                continue;

            if (player.GetButtons() & IN_SCORE)
            {
                player.SetScriptOverlayMaterial(null);
                continue;
            }

            local overlay = "";
            foreach (channel in HUDTable[player][HUDID].channels)
            {
                local cooldown = characterTraitsTable[player][channel.ability_class].TRAIT_COOLDOWN;
                local meter = characterTraitsTable[player][channel.ability_class].meter;
                local percentage = MeterAsPercentage(cooldown, meter);
                local progressBarText = BigToSmallNumbers(MeterAsNumber(cooldown, meter))+" ";
                local i = 1;
                local max_bars = 7;
                local progress = percentage * 0.01 * max_bars;

                for(; i <= progress; i++)
                    progressBarText += "▰";
                for(; i <= max_bars; i++)
                    progressBarText += "▱";

                if (percentage >= 100)
                    overlay += "on_";
                else
                    overlay += "off_";

                channel.params.message = progressBarText;
            }

            player.SetScriptOverlayMaterial(API_GetString("ability_hud_folder") + "/" + overlay);
        }
    }

    function BigToSmallNumbers(input)
    {
        local result = "";
        foreach (char in input)
            result += big2small[char.tochar()];
        return result;
    }

    function MeterAsPercentage(cooldown, meter)
    {
        if (cooldown == null)
            return;

        return meter < 0 ? (cooldown + meter) * 100 / cooldown : 100;
    }

    function MeterAsNumber(cooldown, meter)
    {
        if (cooldown == null)
            return "x";

        local rounded = abs(ceil(-meter));

        if (meter == 0)
            return "r";
        if (rounded < 10)
            return format(" %d", rounded);
        else
            return format("%d", rounded);
    }
}
::BossHUD <- BossHUD();

class BossHUDChannel extends HUDChannel
{
    params = null
    ability_class = null

    function constructor(_ability_class, _x = 0, _y = 0, _color = "255 255 255")
    {
        base.constructor(_x, _y, _color);
        ability_class = _ability_class;
    }
}
::BossHUDChannel <- BossHUDChannel;

AddListener("tick_only_valid", 2, function (timeDelta)
{
    BossHUD.OnTickAlive(timeDelta);
});