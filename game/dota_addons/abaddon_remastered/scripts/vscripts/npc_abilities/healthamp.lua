function OnJingzhunshejiAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability

	local effect_trigger_stack = ability:GetLevelSpecialValueFor("effect_trigger_stack", ability:GetLevel() - 1)

	if not caster:HasModifier("modifier_jingzhunsheji_stacker") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_jingzhunsheji_stacker", {})
	end

	local stack_count = caster:GetModifierStackCount("modifier_jingzhunsheji_stacker", caster)
	if not caster:HasModifier("modifier_jingzhunsheji_effect") then -- 拥有精准射击效果的那一下攻击不叠加，到底是这个先执行还是下面的先执行呢？
		caster:SetModifierStackCount("modifier_jingzhunsheji_stacker", caster, stack_count + 1)
	end
	if stack_count + 1 >= effect_trigger_stack then
		caster:SetModifierStackCount("modifier_jingzhunsheji_stacker", caster, 0)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_jingzhunsheji_effect", {})
	end
end


function OnJingzhunshejiOrbImpact(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local agi_damage_amp = ability:GetLevelSpecialValueFor("agi_damage_amp", ability:GetLevel() - 1)
	local MaxHealth = caster:GetMaxHealth()
	local damage = MaxHealth * agi_damage_amp
		ApplyDamage({
			attacker = caster,
			victim = target,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
		})
end
