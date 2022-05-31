function QuellingBonusDamage( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target:IsCreature() or target:IsCreep() then
		local damageTable = {
			victim = target,
			attacker = caster,
			ability = ability,
			damage_type = DAMAGE_TYPE_PHYSICAL
		}
		
		if caster:IsRangedAttacker() then
			damageTable.damage = 24
			ApplyDamage( damageTable )
		else
			damageTable.damage = 42
			ApplyDamage( damageTable )
		end
	end
end