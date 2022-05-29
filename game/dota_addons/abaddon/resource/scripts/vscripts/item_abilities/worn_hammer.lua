function projectile (keys)
    local caster = keys.caster
    local target = keys.target
    local pos = caster:GetAbsOrigin()
    local ability = keys.ability
    local projectile = keys.particle_name
    local speed = ability:GetLevelSpecialValueFor("speed", ability:GetLevel() - 1)
    local projectile_info = 
    {
				EffectName = projectile,
				Ability = ability,
				vSpawnOrigin = pos,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = speed,
				bReplaceExisting = false,
				bProvidesVision = true,
                Target = target
    }
    ProjectileManager:CreateTrackingProjectile(projectile_info)
end

function hit (keys)
    local caster = keys.caster
	local target = keys.target
    local pos = target:GetAbsOrigin()
    local particle = keys.particle_name
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel() - 1)
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in pairs(units) do
		local particleid = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, unit)
        ParticleManager:SetParticleControl(particleid, 3, unit:GetAbsOrigin())
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)
        ability:ApplyDataDrivenModifier( caster, unit, keys.debuff, {Duration = stun_duration} )
	end
end