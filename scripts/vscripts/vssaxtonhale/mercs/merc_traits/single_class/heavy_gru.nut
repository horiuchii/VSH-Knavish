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

const healthDrainPerSecond = 7;
const ticksPerSecond = 67;

characterTraitsClasses.push(class extends CharacterTrait
{
    degenTicks = 0;

    function CanApply()
    {
        return player.GetPlayerClass() == TF_CLASS_HEAVY
			&& WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE), "gru");
    }

    function OnApply()
    {
        local melee = player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE);
        melee.AddAttribute("mult_player_movespeed_active", 1.4, -1);
        melee.AddAttribute("mod_maxhealth_drain_rate", 0.0, -1);
        melee.AddAttribute("single wep holster time increased", 1.0, -1);
    }

	function OnFrameTickAlive()
	{
        if (GetPropEntity(player, "m_hActiveWeapon") == player.GetWeaponBySlot(TF_WEAPONSLOTS.MELEE))
        {
            degenTicks++;
            if (degenTicks == ticksPerSecond)
            {
                degenTicks = 0;

                local health = player.GetHealth();
                if (health - healthDrainPerSecond < 1)
                {
                    RemoveUberConditions(player);
                    player.TakeDamageCustom(player, player, 0, Vector(0, 0, 0), Vector(90, 0, 0), healthDrainPerSecond * 1.0, 0, TF_DMG_CUSTOM_SUICIDE);
                }
                else
                {
                    SendGlobalGameEvent("player_healonhit",
                    {
                        entindex = player.entindex(),
                        amount = -7,
                    });

                    player.SetHealth(health - healthDrainPerSecond);
                }
            }
        }
	}
});

::RemoveUberConditions <- function(player)
{
    return player.RemoveCond(TF_COND_INVULNERABLE)
        || player.RemoveCond(TF_COND_INVULNERABLE_USER_BUFF)
        || player.RemoveCond(TF_COND_INVULNERABLE_CARD_EFFECT)
        || player.RemoveCond(TF_COND_INVULNERABLE_WEARINGOFF)
        || player.RemoveCond(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED)
        || player.RemoveCond(TF_COND_INVULNERABLE_CARD_EFFECT);
}