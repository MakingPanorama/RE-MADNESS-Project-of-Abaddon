function ApplyBuffs(event)
	local caster = event.caster
	local ability = event.ability
	
	if caster:PassivesDisabled() then
		return 
	end


	ability:ApplyDataDrivenModifier(caster, caster, "modifier_aphotic_shield", {duration = -1})

	local abiArt = caster:FindAbilityByName("aphotic_shield_datadriven")
	if abiArt and abiArt.shadows then 
		for _,unit in pairs(abiArt.shadows) do
			if IsValidEntity(unit) and unit:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_aphotic_shield", {duration = -1})
			end
		end
	end
end
