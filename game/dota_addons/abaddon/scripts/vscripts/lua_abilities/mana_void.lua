function ManaVoid( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local targetLocation = target:GetAbsOrigin()
	local damagePerMana = ability:GetLevelSpecialValueFor("mana_void_damage_per_mana", (ability:GetLevel() - 1))
	local radius = ability:GetSpecialValueFor("mana_void_aoe_radius")
    local base_coefficient = ability:GetSpecialValueFor("base_coefficient")

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.ability = ability
	damageTable.damage_type = ability:GetAbilityDamageType()
	-- Damage calculation depending on the missing mana
	damageTable.damage = (target:GetMaxMana() - target:GetMana())*damagePerMana + base_coefficient * caster:GetAgility()

	-- Finds all the enemies in a radius around the target and then deals damage to each of them
	local unitsToDamage = FindUnitsInRadius(caster:GetTeam(), targetLocation, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)

	for _,v in ipairs(unitsToDamage) do
		damageTable.victim = v
		ApplyDamage(damageTable)
	end
end