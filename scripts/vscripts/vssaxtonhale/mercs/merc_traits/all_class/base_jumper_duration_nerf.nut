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

const maxParachuteTime = 3.0;

mercTraitsLibrary.push(class extends MercenaryTrait
{
	isDeployed = false;
	lastDeployTime = 0.0;
	
    function CanApply()
    {
        local playerClass = player.GetPlayerClass();
		return true;
        return (playerClass == TF_CLASS_SOLDIER && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.SECONDARY), "base_jumper"))
			|| (playerClass == TF_CLASS_DEMOMAN && WeaponIs(player.GetWeaponBySlot(TF_WEAPONSLOTS.PRIMARY), "base_jumper"));
    }
	
	function OnTickAlive(timeDelta)
	{	
		local hasParachute = player.InCond(TF_COND_PARACHUTE_ACTIVE);
		if (isDeployed && !hasParachute)
		{
			isDeployed = false;
		}
		else if (!isDeployed && hasParachute)
		{
			isDeployed = true;
			lastDeployTime = Time();
		}
		else if (isDeployed && hasParachute)
		{
			if (Time() > lastDeployTime + maxParachuteTime)
			{
				isDeployed = false;
				player.RemoveCond(TF_COND_PARACHUTE_ACTIVE);
			}
		}
	}
});