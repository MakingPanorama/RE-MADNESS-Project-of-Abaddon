function HealSound( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_Miku_HealSound"
	local heal = ability:GetLevelSpecialValueFor("heal", (ability:GetLevel() - 1))
	local heal_percent = ability:GetLevelSpecialValueFor("heal_percent", (ability:GetLevel() - 1)) / 100
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	
	local fullheal = heal + caster:GetMaxMana() * heal_percent

	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			ability:StartCooldown(cooldown)
			caster:EmitSound("MikuUhh")
				
			local emp_explosion_effect = ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf",  PATTACH_ABSORIGIN, caster)
			
			local targets = FindUnitsInRadius(caster:GetTeamNumber(),
				caster:GetAbsOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
				false)

			for _,unit in pairs(targets) do
				unit:Heal(fullheal, caster)
			end		
		end
	end
end