function damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle = keys.particle_name
    local sound = keys.sound_name
    local pos = keys.target:GetAbsOrigin()
    local total_damage = ability:GetLevelSpecialValueFor("total_damage", (ability:GetLevel() - 1))
    local initial_stun = ability:GetLevelSpecialValueFor("initial_stun", (ability:GetLevel() - 1))
    local per_extra_stun = ability:GetLevelSpecialValueFor("per_extra_stun", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damageTable = {
        attacker = caster,
        ability = ability,
        damage_type = ability:GetAbilityDamageType()      
    }
    local count = 0
    for _,unit in ipairs(units) do
        count = count + 100
    end
    for _,unit in ipairs(units) do
        damageTable.damage = total_damage + count
        damageTable.victim = unit
        ApplyDamage(damageTable)
        unit:EmitSound(sound)
        local duration = initial_stun + count * per_extra_stun 
        ability:ApplyDataDrivenModifier( caster, unit, keys.debuff, { Duration = duration } )
        local particle_id = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, unit)
        local unitpos = unit:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle_id, 0, unitpos)
		ParticleManager:SetParticleControl(particle_id, 1, Vector(unitpos.x,unitpos.y,unitpos.z+500 ))
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(particle_id, false)
        end)   
    end
end