class WallClimbTrait extends BossAbility
{
    uses_left = 0;
    max_uses = 5;
    mode = AbilityMode.LIMITED_USE;

    function OnFrameTickAlive()
    {
        if (!player.Get().CanUseAbilities())
            return;

        if (boss.IsOnGround())
        {
            uses_left = 0;
        }
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
            targetname = "trigger_stun",
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

        EntFireByHandle(trigger_stun, "EndTouch", "", -1, boss, boss);

        boss.AddCustomAttribute("CARD: move speed bonus", 1.333333, duration);
    }
}
::ScareTrait <- ScareTrait;