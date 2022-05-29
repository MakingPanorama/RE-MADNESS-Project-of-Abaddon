function IntervalBonusDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local current_stack = caster:GetModifierStackCount("modifier_damage_get", ability)

	if not caster:HasModifier("modifier_damage_get") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_damage_get", {})

		caster:SetModifierStackCount("modifier_damage_get", ability, 1)

	end
	caster:SetModifierStackCount("modifier_damage_get", ability, current_stack + 1)
end