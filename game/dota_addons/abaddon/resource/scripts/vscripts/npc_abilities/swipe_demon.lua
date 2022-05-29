function DemonSwipes( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_target_swipe"
	local bonus_damage = ability:GetSpecialValueFor( "bonus_damage_per_hit" )
	local duration = ability:GetSpecialValueFor( "duration" )
	local all_stats = ability:GetSpecialValueFor( "multiplier_for_stats" )
	local max_stacks = ability:GetSpecialValueFor( "limit_stack" )

	local multiplier_stats = target:GetBaseDamageMax() * all_stats


	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName , ability)

		local damage_table = {}

		damage_table.victim = target
		damage_table.attacker = caster
		damage_table.damage = bonus_damage * current_stack + multiplier_stats
		damage_table.damage_type = DAMAGE_TYPE_PURE

		ApplyDamage( damage_table )
		if current_stack < max_stacks then
			ability:ApplyDataDrivenModifier(caster, target, modifierName, { Duration = duration } )
			target:SetModifierStackCount( modifierName , ability, current_stack + 1 )
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, bonus_damage * current_stack + multiplier_stats , nil)
		else
			ability:ApplyDataDrivenModifier(caster, target, modifierName, { Duration = duration } )
		end
	else
		ability:ApplyDataDrivenModifier(caster, target, modifierName, { Duration = duration })
		target:SetModifierStackCount( modifierName , ability, 1)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, bonus_damage * current_stack + multiplier_stats , nil)

		local damage_table = {}
		damage_table.victim = target
		damage_table.attacker = caster
		damage_table.damage = bonus_damage
		damage_table.damage_type = DAMAGE_TYPE_PURE

		ApplyDamage( damage_table )
	end
end