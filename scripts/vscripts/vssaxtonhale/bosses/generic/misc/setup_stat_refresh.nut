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

::CalcBossMaxHealth <- function(mercCount)
{
    if (mercCount < 2)
        return 1000;
    local unrounded = mercCount * mercCount * API_GetFloat("health_factor") + (mercCount < 6 ? 1300 : 2000);
    return floor(unrounded / 100) * 100;
}

::RefreshBossSetup <- function(boss)
{
    local maxHealth = CalcBossMaxHealth(GetValidPlayerCount() - 1);

    switch(CookieUtil.Get(boss, "difficulty"))
    {
        case DIFFICULTY.EASY: maxHealth += (maxHealth * 0.2); break;
        case DIFFICULTY.HARD: maxHealth -= (maxHealth * 0.2); break;
        case DIFFICULTY.EXTREME: maxHealth -= (maxHealth * 0.4); break;
        case DIFFICULTY.IMPOSSIBLE: maxHealth -= (maxHealth * 0.6); break;
        default: break;
    }

    boss.SetHealth(maxHealth);
    boss.SetMaxHealth(maxHealth);
    boss.RemoveCustomAttribute("max health additive bonus");
    boss.AddCustomAttribute("max health additive bonus", maxHealth - TFClassUtil.GetClassMaxHealth(boss.Get().tfclass), -1);
    boss.Get().startingHealth = maxHealth;
    ::startMercCount <- GetAliveMercCount();
}

class SetupStatRefreshTrait extends BossTrait
{
    function OnDamageTaken(attacker, params)
    {
        if (IsRoundSetup())
        {
            params.damage = 0;
            params.early_out = true;
        }
    }

    function OnTickAlive(timeDelta)
    {
        if (!IsRoundSetup())
            return;

        RefreshBossSetup(boss);
	}
};