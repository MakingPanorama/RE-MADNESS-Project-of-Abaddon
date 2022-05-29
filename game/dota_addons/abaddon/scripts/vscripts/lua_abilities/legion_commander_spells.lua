function DamageInPure( keys )
	local caster = keys.caster
	local target = keys.target

	local damage = keys.attack_damage

	local damage_table = {
		victim = target,
		attacker = caster,
		ability = keys.ability,
		damage = damage * 5 / 100,
		damage_type = DAMAGE_TYPE_PURE
	}
	ApplyDamage( damage_table )
end