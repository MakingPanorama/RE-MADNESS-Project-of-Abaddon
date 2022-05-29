function create (keys)
    local caster = keys.caster
    local target = keys.target
    local targetLocation = target:GetAbsOrigin()
    local ability = keys.ability
    local projectile = keys.projectile_name
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability:GetLevel() - 1)
    
    local units = FindUnitsInRadius(caster:GetTeam(), targetLocation, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    
    local projectile_info = 
    {
				EffectName = projectile,
				Ability = ability,
				vSpawnOrigin = caster:GetAbsOrigin(),
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = true
    }
    for _,unit in pairs(units) do
        projectile_info.Target = unit
        ProjectileManager:CreateTrackingProjectile(projectile_info)	
	end
end

function damage (keys)
    local caster = keys.caster
    local target = keys.target
    local modifier = keys.modifier_name
    local ability = keys.ability
    local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel() - 1)
    local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability:GetLevel() - 1)
    local bonus_percentage = ability:GetLevelSpecialValueFor("bonus_percentage", ability:GetLevel() - 1)
    local total_damage = base_damage + ( caster:GetStrength() * bonus_percentage / 100 )
    ability:ApplyDataDrivenModifier( caster, target, modifier, { Duration = stun_duration } )
    local damage_table={
        attacker = caster,
        victim = target,
        ability = ability,
        damage = total_damage,
        damage_type = ability:GetAbilityDamageType() 
    }
    ApplyDamage(damage_table)
end