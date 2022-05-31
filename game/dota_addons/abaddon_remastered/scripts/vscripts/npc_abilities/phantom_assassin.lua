function meiyingzhixi_StoreAttackTarget(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stack = 0
	if caster:HasModifier("modifier_meiyingzhixi") then
		stack = caster:GetModifierStackCount("modifier_meiyingzhixi", caster)
		if stack <= 0 then
			stack = 0
		end
		stack = stack + 1
		caster:RemoveModifierByName("modifier_meiyingzhixi")
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_meiyingzhixi", {})
	caster:SetModifierStackCount("modifier_meiyingzhixi", caster, stack)
	local basic_crit = ability:GetLevelSpecialValueFor("basic_crit", ability:GetLevel() - 1)
	local bonus_crit = ability:GetLevelSpecialValueFor("bonus_crit", ability:GetLevel() - 1)
	local crit = basic_crit + bonus_crit * (stack or 0 )
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_meiyingzhixi_crit", {})
	caster:SetModifierStackCount("modifier_meiyingzhixi_crit", caster, crit)
end
