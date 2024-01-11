PrecacheSound("vo/halloween_boss/knight_alert.mp3");

class ScareTrait extends BossAbility
{
    duration = 3;
    cooldown = 30;
    meter = 0;
    mode = AbilityMode.COOLDOWN;

    function OnFrameTickAlive()
    {
        if (!player.Get().CanUseAbilities())
            return;

        if (!meter && boss.GetButtons() & IN_RELOAD)
        {
            Perform();
        }
    }

    function Perform()
    {
        SetCooldown();
        local trigger_stun = SpawnEntityFromTable("trigger_stun",
        {
            targetname = "horsemann_scare",
            stun_type = 2,
            stun_effects = true,
            stun_duration = duration,
            move_speed_reduction = 0,
            trigger_delay = -1,
            StartDisabled = 0,
            spawnflags = 1,
            solid = 2,
            "OnStunPlayer#1": "!self,Kill,0,0.01,-1",
        });

        EmitSoundOn("vo/halloween_boss/knight_alert.mp3", boss);

        local boss_center = boss.GetCenter();
        for (local i = 1; i <= MAX_PLAYERS; i++)
        {
            local target = PlayerInstanceFromIndex(i);
            if (!IsValidPlayer(target) || !player.IsAlive() || target == boss)
                continue;

            if (IsInRange(boss, target, 300.0, true, { start = boss_center, end = target.GetCenter(), mask = MASK_SOLID_BRUSHONLY }))
            {
                EntFireByHandle(trigger_stun, "EndTouch", "", -1, target, target);
                target.AddCustomAttribute("CARD: move speed bonus", 1.333333, duration);
            }
        }
    }
}
::ScareTrait <- ScareTrait;