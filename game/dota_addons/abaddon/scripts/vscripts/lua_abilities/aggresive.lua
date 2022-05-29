function CallBerserk( keys )

	local units = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	
	for _,unit in ipairs(units) do
		if not keys.caster:IsAlive() then return end
		Timers:CreateTimer(0.1, function()
			if unit:CanEntityBeSeenByMyTeam( keys.caster ) then
				unit:SetForceAttackTarget( keys.caster )
			end

			if not keys.caster:IsAlive() or keys.caster:IsInvisible() then
				unit:SetForceAttackTarget( nil )
				return nil
			end
			return 0.1
		end)
	end
end