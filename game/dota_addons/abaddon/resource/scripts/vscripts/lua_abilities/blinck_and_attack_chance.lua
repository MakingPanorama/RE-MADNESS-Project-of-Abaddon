function ApplyBuffs(event)
	local caster = event.caster
	local ability = event.ability
	
	if caster:PassivesDisabled() then
		return 
	end

	local duration = ability:GetSpecialValueFor("duration")

	ability:ApplyDataDrivenModifier(caster, caster, "blinkertdd", {duration = duration})

	local abiShadow = caster:FindAbilityByName("shadow_master_shadow")
	if abiShadow and abiShadow.shadow and IsValidEntity(abiShadow.shadow) and abiShadow.shadow:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, abiShadow.shadow, "blinkertdd", {duration = duration})
	end

	local abiArt = caster:FindAbilityByName("shadow_master_art_of_shadows")
	if abiArt and abiArt.shadows then 
		for _,unit in pairs(abiArt.shadows) do
			if IsValidEntity(unit) and unit:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, unit, "blinkertdd", {duration = duration})
			end
		end
	end
end

function Picked (event)
    local heroentity = EntIndexToHScript(event.heroindex)
    local ability = heroentity:FindAbilityByName("shadow_master_agility_of_shadows")
    ability:SetLevel(1)
end
