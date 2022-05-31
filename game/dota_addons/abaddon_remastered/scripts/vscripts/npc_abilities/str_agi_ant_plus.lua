function HealSound( keys )
	local ability = keys.ability
	local target = keys.target
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_Miku_HealSound"
	if not ability then return end

	local agi = target:GetBaseDamageMin()
	local str = target:GetBaseMoveSpeed()
	local int = target:GetPhysicalArmorBaseValue()
	
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local mult = ability:GetLevelSpecialValueFor("mult", (ability:GetLevel() - 1))
	
	local fullheal = (agi+str+int)*(mult*0.01)

	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			ability:StartCooldown(cooldown)
			caster:EmitSound("MikuUhh")
				
			local emp_explosion_effect = ParticleManager:CreateParticle("",  PATTACH_ABSORIGIN, caster)
			
			local targets = FindUnitsInRadius(caster:GetTeamNumber(),
				caster:GetAbsOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_ALL,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
				false)

			for _,unit in pairs(targets) do
				unit:Heal(fullheal, caster)
			end		
		end
	end
end