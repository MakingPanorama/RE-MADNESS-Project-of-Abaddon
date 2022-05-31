function effect (keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local particle = keys.particle_name
    local debuff = keys.debuff
    local buff = keys.buff
    local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
    local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local count = 0
    for _,unit in ipairs(units) do
        count = count + 1
        ability:ApplyDataDrivenModifier( caster, unit, debuff, {duration = duration} )
        unit.particle = ParticleManager:CreateParticle(particle, PATTACH_OVERHEAD_FOLLOW, unit)
        ParticleManager:SetParticleControl(unit.particle, 0, unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(unit.particle, 1, unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(unit.particle, 2, unit:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(unit.particle, 1, unit, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(unit.particle, 2, unit, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
        Timers:CreateTimer(duration,function()
            ParticleManager:DestroyParticle(unit.particle,false) 
        end
        )
    end
    if caster:HasModifier( buff )then
        local current_stack = caster:GetModifierStackCount( buff, ability )     
        ability:ApplyDataDrivenModifier( caster, caster, buff, { duration = duration } )
        caster:SetModifierStackCount( buff, ability, current_stack+count )
    else
        ability:ApplyDataDrivenModifier( caster, caster, buff, { duration = duration } )
        caster:SetModifierStackCount( buff, ability, count ) 
    end
end
    
    