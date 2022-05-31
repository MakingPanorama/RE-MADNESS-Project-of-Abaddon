function damage (keys)
    local ability = keys.ability
    local caster = keys.caster
    local damage_per_tick = ability:GetLevelSpecialValueFor("damage_per_tick", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = damage_per_tick
    } 
    for _,unit in ipairs(units) do
        damage_table.victim = unit
        ApplyDamage(damage_table)
        local particleid = ParticleManager:CreateParticle(keys.particle_name, PATTACH_ABSORIGIN_FOLLOW, unit)
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)
        unit:EmitSound(keys.sound_name)
        Timers:CreateTimer(1, function()
            unit:StopSound(keys.sound_name)
        end)
    end 
end

