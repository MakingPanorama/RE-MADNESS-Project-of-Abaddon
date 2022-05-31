function IronTalon( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local damage_in_health = caster:GetHealth() * 50 / 100

	local damage_table = {
		victim = target,
		attacker = caster,
		ability = ability,
		damage = damage_in_health,
		damage_type = DAMAGE_TYPE_PURE
	}
	ApplyDamage( damage_table )

	if target == GridNav:IsNearbyTree(target:GetAbsOrigin(), 15, true) then
		GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(), 15, true)
	end
end