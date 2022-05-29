function jianciReflect(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not ability then return end

	local level = ability:GetLevel()
	local damage = keys.Damage
	local casterSTR = caster:GetStrength()
	local str_return = ability:GetLevelSpecialValueFor( "strength_pct" , ability:GetLevel() - 1  ) * 0.01
	local reflect_ratio = ability:GetSpecialValueFor("reflect_ratio")
	local damage = (damage * (reflect_ratio) / 100 +  ( casterSTR * str_return ))

	local victim = keys.attacker
	
	ApplyDamage({
		attacker = target,
		victim = victim,
		ability = ability,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
	})
end