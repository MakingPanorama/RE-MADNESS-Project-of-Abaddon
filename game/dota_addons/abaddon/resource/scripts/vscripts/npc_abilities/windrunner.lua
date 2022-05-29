function OnKuangfengyouxiaAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability

	local effect_trigger_stack = ability:GetLevelSpecialValueFor("effect_trigger_stack", ability:GetLevel() - 1)

	if not caster:HasModifier("modifier_kuangfengyouxia_stacker") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kuangfengyouxia_stacker", {})
	end

	local stack_count = caster:GetModifierStackCount("modifier_kuangfengyouxia_stacker", caster)
	if not caster:HasModifier("modifier_kuangfengyouxia_effect") then -- 拥有精准射击效果的那一下攻击不叠加，到底是这个先执行还是下面的先执行呢？
		caster:SetModifierStackCount("modifier_kuangfengyouxia_stacker", caster, stack_count + 1)
	end
	if stack_count + 1 >= effect_trigger_stack then
		caster:SetModifierStackCount("modifier_kuangfengyouxia_stacker", caster, 0)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kuangfengyouxia_effect", {})
	end
end

function OnKuangfengyouxiaProjectileHitUnit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local int_damage_amp = ability:GetLevelSpecialValueFor("int_damage_amp", ability:GetLevel() - 1)
	local intellect = caster:GetIntellect()
	local damage = intellect * int_damage_amp
		ApplyDamage({
			attacker = caster,
			victim = target,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
		})
end

function OnKuangfengyouxiaAttackSpeedAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local attack_times =  ability:GetLevelSpecialValueFor("attack_times", ability:GetLevel() - 1)
	caster.__attack_times = caster.__attack_times or 0
	caster.__attack_times = caster.__attack_times + 1
	if caster.__attack_times >= attack_times then
		caster:RemoveModifierByName("modifier_kuangfengyouxia_attack_speed")
		caster.__attack_times = 0
	end
end

function OnKuangfengyouxiaMoveSpeedCreated(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local movespeed =  ability:GetLevelSpecialValueFor("movespeed", ability:GetLevel() - 1)

	caster:RemoveModifierByName("modifier_movespeed_cap_522")
	caster:AddNewModifier(caster, ability, "modifier_movespeed_cap_" .. movespeed, {})
	-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_movespeed_max_effect", {})
end

function OnKuangfengyouxiaMoveSpeedDestroyed(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- GameRules.AbilitySystem:RemoveChongfengModifier(caster)
	caster:AddNewModifier(hero, nil, "modifier_movespeed_cap_522", {})
end

function KuangfengyouxiaKnockback(keys)
	local vCaster = keys.caster:GetAbsOrigin()
    local vTarget = keys.target:GetAbsOrigin()
    local target = keys.target

    if target.GetUnitName and target:GetUnitName() == "bom_xiaolu" then return end

    local len = ( vTarget - vCaster ):Length2D()
    len = keys.distance - keys.distance * ( len / keys.range )

    local knockbackModifierTable =
    {
        should_stun = 0,
        knockback_duration = keys.duration,
        duration = keys.duration,
        knockback_distance = len,
        knockback_height = 0,
        center_x = keys.caster:GetAbsOrigin().x,
        center_y = keys.caster:GetAbsOrigin().y,
        center_z = keys.caster:GetAbsOrigin().z
    }
    target:AddNewModifier( keys.caster, nil, "modifier_knockback", knockbackModifierTable )
end
