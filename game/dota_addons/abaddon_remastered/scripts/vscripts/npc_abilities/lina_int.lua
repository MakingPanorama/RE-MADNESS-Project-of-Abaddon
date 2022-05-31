function AddInt(keys)
	local stack_value = keys.stack_value
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local buff = "modifier_int"
	local dur = inf
	if caster:HasModifier(buff) then
		local current_stack = caster:GetModifierStackCount(buff, ability)
		ability:ApplyDataDrivenModifier(caster, caster, buff, {duration = dur})
		caster:SetModifierStackCount(buff, ability, current_stack + stack_value)
	else
		ability:ApplyDataDrivenModifier(caster, caster, buff, {duration = dur})
		caster:SetModifierStackCount(buff, ability, stack_value)
	end
end