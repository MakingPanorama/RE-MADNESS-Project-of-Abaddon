function modify_acquisition (keys)
    local caster = keys.caster
    local attackrange=caster:GetAttackRange()
    caster:SetAcquisitionRange(attackrange)
end

function multiple_attack (keys)
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local ability = keys.ability
    local number_attack = ability:GetLevelSpecialValueFor("number", ability:GetLevel() - 1)
    local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability:GetLevel() - 1)
	local attack_target = caster:GetAttackTarget()
    local attackrange=caster:GetAttackRange()
    local units = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, attackrange, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local projectile_info = 
    {
				EffectName = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf",
				Ability = ability,
				vSpawnOrigin = caster_location,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = true
    }
    for _,unit in pairs(units) do
		if unit ~= attack_target then
			projectile_info.Target = unit
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			number_attack = number_attack - 1
		end
		-- If we reached the maximum amount of targets then break the loop
		if number_attack == 0 then break end
	end
end

function damage (keys)
    local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local damage_table = {}
	damage_table.attacker = caster
	damage_table.victim = target
    damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = caster:GetAttackDamage()
	ApplyDamage(damage_table)
end