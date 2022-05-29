function ScpPassive1( keys )
	local caster = keys.caster

	caster.stone_gaze_table = {}
end

function invis( keys )
	local caster = keys.caster
	local ability = keys.ability
	local casterLocation = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	local enemyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

	if #enemyHeroes>0 then
		caster:RemoveModifierByName("modifier_invisible")
		caster:RemoveModifierByName("modifier_scppassive_movementspeed")
	else
		caster:AddNewModifier(caster, ability, "modifier_invisible", {})
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_scppassive_movementspeed", {})
	end
end

function ScpPassive( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local vision_cone = 85

	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()	

	local direction = (caster_location - target_location):Normalized()
	local forward_vector = target:GetForwardVector()
	local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)

	if angle <= vision_cone/2 then
		local check = false
		for _,v in ipairs(caster.stone_gaze_table) do
			if v == target then
				print(target:GetUnitName())
				if not target:IsHero() then return end
				check = true
			end
		end

		if check then
			if not target:IsHero() then return end
			caster:AddNewModifier( caster, self, "modifier_stunned", { duration = 0.5 } )
		else
			table.insert(caster.stone_gaze_table, target)
			target.stone_gaze_look = 0
			target.stone_gaze_stoned = false
			if not target:IsHero() then return end
			caster:AddNewModifier( caster, self, "modifier_stunned", { duration = 0.5 } )
		end
	end
end