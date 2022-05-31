function siwangguanghuanDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = keys.Damage
	if not ability then return end

	ApplyDamage({
		attacker = caster,
		victim = target,
		ability = ability,
		damage = damage,
		damage_type = ability:GetAbilityDamageType()
	})
end