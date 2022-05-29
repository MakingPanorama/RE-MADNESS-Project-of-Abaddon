function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local pos = ability:GetCursorPosition()
    ability.pos = pos
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local radius_tip = ability:GetLevelSpecialValueFor("radius_tip", ability:GetLevel() - 1)
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local animation = ability:GetLevelSpecialValueFor("animation", ability:GetLevel() - 1)
    local start_pos = Vector (-radius, -radius, 0)
    
    ability:ApplyDataDrivenModifier(caster, caster, keys.caster_modifier, { Duration = duration } )
    caster:EmitSound(keys.sound_name)
    local particle_name = keys.particle_name
    for i=1, 4 do
        local particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(particle, 0, pos)
        ParticleManager:SetParticleControl(particle, 1, Vector(radius_tip,radius_tip,0))
        ParticleManager:SetParticleControl(particle, 2, pos)
        Timers:CreateTimer(duration, function()
            ParticleManager:DestroyParticle(particle, false)
        end)    
    end
    

    for i=1, 12 do
        local angle = -360 + i * 30
        local rotate = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), start_pos)
        local create_point =  rotate + pos
        local unit = CreateUnitByName("Cleaver_Shield_Unit", create_point, false, caster, caster, caster:GetTeamNumber() )
        unit:SetAngles(-180,angle+225,-100)
        ability:ApplyDataDrivenModifier(caster, unit, keys.modifier_name, { Duration = animation } )
        unit:AddNewModifier(unit, nil, "modifier_kill", {duration = duration-6.5})   
    end
    AddFOWViewer( caster:GetTeamNumber(), pos, radius_tip, duration, false )
end

function toggle (keys)
    local unit = keys.target
    local orginal_angle = unit:GetAnglesAsVector()
    local angle = orginal_angle.x  
    if angle < -90 then
        unit:SetAngles(angle+10,orginal_angle.y,orginal_angle.z) 
    end
    local ability = keys.ability
    local pos = ability.pos
    
end

function damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local pos = ability.pos
    local radius = ability:GetLevelSpecialValueFor("radius_tip", ability:GetLevel() - 1)
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local buff_duration = ability:GetLevelSpecialValueFor("buff_duration", ability:GetLevel() - 1)
    local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local particle_1 = keys.particle_1
    local particle_2 = keys.particle_2
    local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = damage
    }
    for _,unit in ipairs(units) do
        if not unit:HasModifier(keys.modifier_1) then
            ability:ApplyDataDrivenModifier(caster, unit, keys.modifier_1, { Duration = duration } )
            local particleid = ParticleManager:CreateParticle(particle_1, PATTACH_CUSTOMORIGIN, unit)
		    ParticleManager:SetParticleControlEnt(particleid, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		    ParticleManager:SetParticleControlEnt(particleid, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		    ParticleManager:SetParticleControlEnt(particleid, 2, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		    ParticleManager:SetParticleControlEnt(particleid, 4, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		    ParticleManager:SetParticleControlEnt(particleid, 8, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		    ParticleManager:ReleaseParticleIndex(particleid)
            damage_table.victim = unit
            ApplyDamage(damage_table)
            
            local particleid = ParticleManager:CreateParticle(particle_2, PATTACH_ABSORIGIN_FOLLOW, caster)
            ability:ApplyDataDrivenModifier(caster, caster, keys.modifier_2, { Duration = buff_duration } )
            local count = caster:GetModifierStackCount( keys.modifier_2, ability )
            caster:SetModifierStackCount( keys.modifier_2, ability, 1+count ) 
            caster:EmitSound(keys.sound_name)
        end     
    end
end