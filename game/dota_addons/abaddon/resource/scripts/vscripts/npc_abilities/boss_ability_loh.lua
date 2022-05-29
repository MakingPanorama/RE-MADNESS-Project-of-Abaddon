function rage_check( keys )
	if keys.caster:GetHealth() <= keys.caster:GetMaxHealth() / 2 and not keys.caster:HasModifier("modifier_boss_ability_loh") and not keys.caster:PassivesDisabled() then
		keys.ability:ApplyDataDrivenModifier(keys.caster,keys.caster,"modifier_boss_ability_loh",{duration = -1})
	end

	if keys.caster:HasModifier("modifier_boss_ability_loh") and keys.caster:GetHealth() >= keys.caster:GetMaxHealth() / 2 then
		keys.caster:RemoveModifierByName("modifier_boss_ability_loh")
	end
end

function damage( keys )
	if not keys.caster:PassivesDisabled() then
		local target = keys.target

		local damage = target:GetMaxHealth() / 100 * 2.35
		ApplyDamage({victim = target,attacker = keys.caster, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	end
end