function courage_start(event)
	if event.ability and event.ability:IsCooldownReady() and not event.caster:HasModifier("modifier_attack_speed") then
			local caster = event.caster
			local ability = event.ability
			local ability_level = ability:GetLevel() - 1
			if RollPercentage(ability:GetLevelSpecialValueFor("trigger_chance", ability_level))	then 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_attack_speed", {})
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))
			end
	end
end