function initial_damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local debuff = keys.debuff
    local particle_name = keys.particle_name
    local point = ability:GetCursorPosition()
    local inital_damage = ability:GetLevelSpecialValueFor("inital_damage", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = inital_damage
    } 
    local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in ipairs(units) do
        damage_table.victim = unit
        ApplyDamage(damage_table)
        ability:ApplyDataDrivenModifier( caster, unit, debuff, {Duration = duration} )
        local particleid = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, unit)
        ParticleManager:SetParticleControl(particleid, 0, unit:GetAbsOrigin())
        ParticleManager:SetParticleControl(particleid, 1, Vector(200, 2, 400))
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)
    end
end

function bonus_damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local bonus_damage_per_second = ability:GetLevelSpecialValueFor("bonus_damage_per_second", (ability:GetLevel() - 1))
    local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = bonus_damage_per_second,
        victim = target
    } 
    ApplyDamage(damage_table)
end