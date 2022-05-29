function StackAttack( keys )
	local target = keys.target
	local caster = keys.caster
	local caster_range = caster:Script_GetAttackRange()
	local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)

	for _, unit in ipairs(units) do
		if unit == target then return end
		caster:PerformAttack(unit, true, false, true, false, true, false, true)
	end
end