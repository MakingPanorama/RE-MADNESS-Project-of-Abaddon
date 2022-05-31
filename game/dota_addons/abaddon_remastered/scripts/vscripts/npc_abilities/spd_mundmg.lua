function ApplyBuffs(event)
	local caster = event.caster
	local ability = event.ability
	
	
	if caster:PassivesDisabled() then
		return 
	end

    local atk_spd = GetBaseAttackTime()
	local NUM_CK = ability:GetSpecialValueFor("NUM_CK")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_beseall", {duration = (atk_spd * NUM_CK) })

	local abiShadow = caster:FindAbilityByName("berserkky")
	if abiShadow and abiShadow.shadow and IsValidEntity(abiShadow.shadow) and abiShadow.shadow:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, abiShadow.shadow, "modifier_beseall", {duration = (atk_spd * NUM_CK) })
	end

	local abiArt = caster:FindAbilityByName("berserkky")
	if abiArt and abiArt.shadows then 
		for _,unit in pairs(abiArt.shadows) do
			if IsValidEntity(unit) and unit:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_beseall", {duration = (atk_spd * NUM_CK) })
			end
		end
	end
end
