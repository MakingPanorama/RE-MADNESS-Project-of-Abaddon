function fensuiDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not ability then return end
	if caster:IsIllusion() then return end
	local damage_percentage = ability:GetSpecialValueFor("damage_percentage")
	local base_damage = ability:GetSpecialValueFor("base_damage")

	local health = target:GetHealth()
	local damage = base_damage + health * damage_percentage / 100

	ApplyDamage({
		attacker = caster,
		victim = target,
		ability = ability,
		damage = damage,
		damage_type = ability:GetAbilityDamageType()
	})

end