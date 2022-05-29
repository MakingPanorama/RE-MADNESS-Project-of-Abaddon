function initial (keys)
    local ability = keys.ability
    ability.pos = ability:GetCursorPosition()
end

function damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle = keys.particle_name
    local pos = ability.pos
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local damage_per_second = ability:GetLevelSpecialValueFor("damage_per_second", (ability:GetLevel() - 1))
    local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
    local particle_id = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particle_id, 0, pos)
    ParticleManager:SetParticleControl(particle_id, 1, Vector(radius, radius, 0)) 
    Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle(particle_id, false)
    end)
    local damageTable = {
        attacker = caster,
        ability = ability,
        damage_type = ability:GetAbilityDamageType(),
        damage = damage_per_second
    }
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in ipairs(units) do
        damageTable.victim = unit
        ApplyDamage(damageTable)
        unit:EmitSound(keys.sound)
        ability:ApplyDataDrivenModifier( caster, unit, keys.debuff, { Duration = stun_duration } )
    end
end