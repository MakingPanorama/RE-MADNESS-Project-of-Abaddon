function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local pos = caster:GetAbsOrigin()
    local distance = ability:GetLevelSpecialValueFor("distance", (ability:GetLevel() - 1))
    local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
    local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", (ability:GetLevel() - 1))
    local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", (ability:GetLevel() - 1))
    local number = ability:GetLevelSpecialValueFor("number", (ability:GetLevel() - 1))
    local particle = keys.particle_name
    local info={     
            Ability = ability,
            EffectName = particle,
            vSpawnOrigin = pos,
            fDistance = distance,
            fStartRadius = damage_radius,
            fEndRadius = damage_radius,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = ability:GetAbilityTargetTeam(),
            iUnitTargetFlags = ability:GetAbilityTargetFlags(),
            iUnitTargetType = ability:GetAbilityTargetType(),
		    bDeleteOnHit = false,
		    bProvidesVision = true,
		    iVisionRadius = vision_radius,
		    iVisionTeamNumber = caster:GetTeamNumber()
    }
    for i=1, number do
        local angle = 360/number * i
        info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), caster:GetForwardVector()) * speed
        local projectile=ProjectileManager:CreateLinearProjectile(info) 
    end
end

function height (keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
    local height = ability:GetLevelSpecialValueFor("height", (ability:GetLevel() - 1))
    local up_down_time = 0.5
    local tick = 0.1
    local tick_time = up_down_time / tick
    local height_per_tick = height / tick_time 
    ability:ApplyDataDrivenModifier(caster, target, keys.debuff, {duration = stun_duration} )  
    local particleid = ParticleManager:CreateParticle(keys.particle_name, PATTACH_WORLDORIGIN, target)
    ParticleManager:SetParticleControl(particleid, 0, target:GetAbsOrigin())
    Timers:CreateTimer(stun_duration, function()
         ParticleManager:DestroyParticle(particleid, false)
    end)
    for i=0, tick_time-1 do
        Timers:CreateTimer(i*tick, function()
               local pos = target:GetAbsOrigin()
               target:SetAbsOrigin(Vector(pos.x,pos.y,pos.z+height_per_tick)) 
        end)
    end
    for i=tick_time-1, 1, -1 do
        Timers:CreateTimer(stun_duration-i*tick, function()
               local pos = target:GetAbsOrigin()
               target:SetAbsOrigin(Vector(pos.x,pos.y,pos.z-height_per_tick))  
        end)
    end
end

function rotate (keys)
    local target = keys.target
    local v = target:GetForwardVector()
    local x = v.x * math.cos(math.rad(10)) - v.y * math.sin(math.rad(10))
    local y = v.x * math.sin(math.rad(10)) + v.y * math.cos(math.rad(10))
    local z = v.z
    local new_vector = Vector(x, y, z):Normalized()
    target:SetForwardVector(new_vector)
end

function damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    local damageTable = {
        attacker = caster,
        ability = ability,
        victim = target,
        damage_type = ability:GetAbilityDamageType(),
        damage = damage
    }
    ApplyDamage(damageTable)
end