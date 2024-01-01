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

class MovespeedTrait extends BossTrait
{
    function OnTickAlive(timeDelta)
    {
        local max_speed = 480;
        local min_speed = 320;
        local speed_range = max_speed - min_speed;

        // Full health example where full health is 1000 and the boss class is Heavy with 230 speed

        // Brings heavy's speed from 230 to 320 (320 / 230 = 1.3913)
        local class_mult = min_speed / GetClassSpeed(boss.GetPlayerClass());

        local ignored_health_mult = 0.25;

        // 1000 - (clamped to 0 (1000 * 0.25)) = 750
        local health = clampFloor(boss.GetHealth() - (boss.GetMaxHealth() * ignored_health_mult), 0);

        // 1000 * (1 - 0.25) = 750
        local max_health = boss.GetMaxHealth() * (1 - ignored_health_mult);

        // 750 / 750 = 1
        local remaining_health_percent = health / max_health;

        // 1 - 1 = 0
        // 0 * 160 = 0
        // 0 + 320 = 320
        // 320 / 320 = 1
        // 1 * 1.3913 = 1.3913
        local result = ((((1 - remaining_health_percent) * speed_range) + min_speed) / min_speed) * class_mult;

        // 1.3913 * 230 = 320
        boss.AddCustomAttribute("move speed bonus", result, -1);
    }

    function GetClassSpeed(class_id)
    {
        switch(class_id)
        {
            case TF_CLASS_SCOUT: return 400.0;
            case TF_CLASS_SOLDIER: return 240.0;
            case TF_CLASS_PYRO: return 300.0;
            case TF_CLASS_DEMOMAN: return 280.0;
            case TF_CLASS_HEAVYWEAPONS: return 230.0;
            case TF_CLASS_ENGINEER: return 300.0;
            case TF_CLASS_MEDIC: return 320.0;
            case TF_CLASS_SNIPER: return 300.0;
            case TF_CLASS_SPY: return 320.0;
        }
    }
};