function initial (keys)
    local caster = keys.caster
    local target = keys.target
    local pos = target:GetAbsOrigin()
    local ability = keys.ability
    ability.origin= caster:GetAbsOrigin()
    caster:AddNoDraw()
    PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
    ability.max_count = ability:GetLevelSpecialValueFor("count", (ability:GetLevel() - 1))
    ability.count = 0
    local random_pos = pos + Vector(RandomInt(-200,200),RandomInt(-200,200),0)
    caster:SetAbsOrigin(random_pos)
    caster:PerformAttack(target, true, true, true, true, true, false, false)
    caster:EmitSound(keys.sound_1)
    caster:EmitSound(keys.sound_2)
    local particle_1 = ParticleManager:CreateParticle(keys.particle_1, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle_1, 0, pos)
    Timers:CreateTimer(0.5, function()
         ParticleManager:DestroyParticle(particle_1, false)
    end)
    local particle_2 = ParticleManager:CreateParticle(keys.particle_2, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle_2, 0, pos)
    Timers:CreateTimer(0.5, function()
         ParticleManager:DestroyParticle(particle_2, false)
    end)
    ability.count = ability.count + 1
end


function nexttick (keys)
    local caster = keys.caster
    local pos = caster:GetAbsOrigin()
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor("bounce_distance", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local enemy_count = 0
    for _,unit in ipairs(units) do
        enemy_count = enemy_count + 1
    end
    if enemy_count == 0 or ability.count >= ability.max_count then
        caster:RemoveModifierByName(keys.modifier_name)
        caster:Stop()
        caster:RemoveNoDraw()
        caster:SetAbsOrigin(ability.origin)
    else
        local random = RandomInt(1, enemy_count)
        local target = units[random]
        local target_pos = target:GetAbsOrigin()
        local random_pos = target_pos + Vector(RandomInt(-200,200),RandomInt(-200,200),0)
        caster:SetAbsOrigin(random_pos)
        caster:PerformAttack(target, true, true, true, true, true, false, false)
        caster:EmitSound(keys.sound_1)
        caster:EmitSound(keys.sound_2)
        local particle = keys.particle_name
        local particle_1 = ParticleManager:CreateParticle(keys.particle_1, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle_1, 0, target_pos)
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(particle_1, false)
        end)
        local particle_2 = ParticleManager:CreateParticle(keys.particle_2, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle_2, 0, target_pos)
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(particle_2, false)
        end)
        ability.count = ability.count + 1
    end  
end