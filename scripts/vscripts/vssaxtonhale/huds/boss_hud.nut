class BossHUD
{
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

    function AddHUD(player, boss_hud_id, channels)
    {
        HUD.Add(player, CreateIdentifier(boss_hud_id), HUDObject(channels));
    }

    function CreateIdentifier(boss_hud_id)
    {
        return HUDIdentifier(boss_hud_id, HUDPriority);
    }

    function OnTickAlive(timeDelta)
    {
        foreach (player in GetBossPlayers())
        {
            if (!player.IsAlive())
                continue;

            local HUDID = player.Get().HUDID;
            if (!(HUDID in HUDTable[player]))
                continue;

            if (!HUD.Get(player, HUDID).enabled)
                continue;

            if (HUD.GetActive(player) != HUDID)
                continue;

            if (player.GetButtons() & IN_SCORE)
            {
                HUD.Get(player, HUDID).overlay = null;
                continue;
            }

            local overlay = "";
            foreach (channel in HUD.Get(player, HUDID).channels)
            {
                switch (characterTraitsTable[player][channel.ability_class].mode)
                {
                    case AbilityMode.COOLDOWN:
                        {
                            local ability = characterTraitsTable[player][channel.ability_class];
                            local progressBarText = "";
                            local cooldown = ability.cooldown;
                            local meter = ability.meter;
                            local percentage = MeterAsPercentage(cooldown, meter);
                            local progressBarText = BigToSmallNumbers(MeterAsNumber(cooldown, meter)) + " ";
                            local max_bars = 7;
                            local progress = percentage == null ? 0.0 : percentage * 0.01 * max_bars;

                            for(local i = 1; i <= max_bars; i++)
                                progressBarText += i <= progress ? "▰" : "▱";

                            overlay += percentage >= 100 ? "on_" : "off_";
                            channel.params.message = progressBarText;
                            break;
                        }
                    case AbilityMode.LIMITED_USE:
                        {
                            channel.params.message = ability.uses_left + " / " + ability.max_uses;
                            break;
                        }
                }
            }

            //HUD.Get(player, HUDID).overlay = API_GetString("ability_hud_folder") + "/" + overlay;
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