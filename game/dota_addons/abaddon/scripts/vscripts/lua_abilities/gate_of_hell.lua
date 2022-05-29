function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle = keys.particle_name
    local sound = keys.sound_name
    local point = ability:GetCursorPosition()
    local pull_radius = ability:GetLevelSpecialValueFor("pull_radius", (ability:GetLevel() - 1))
    
    ability.particleid = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(ability.particleid, 0, point)
    
    ability.addition = ParticleManager:CreateParticle(keys.addition, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(ability.addition, 0, point)
    ParticleManager:SetParticleControl(ability.addition, 1, Vector(pull_radius,pull_radius,1))
    
    EmitSoundOn(sound , caster)
    local modifier_1 = keys.modifier_1
    local modifier_2 = keys.modifier_2
    ability:ApplyDataDrivenModifier( caster, caster, modifier_1, {} )
    ability:ApplyDataDrivenModifier( caster, caster, modifier_2, {} )
    ability.pos = point
    ability.times = 0
end

function delete (keys)
    local caster = keys.caster
    local ability = keys.ability
    local pull_radius = ability:GetLevelSpecialValueFor("pull_radius", (ability:GetLevel() - 1))
    local sound = keys.sound_name 
    StopSoundOn(sound, caster)
    
    ParticleManager:DestroyParticle(ability.particleid, false)
    ParticleManager:DestroyParticle(ability.addition, false)
    
    ResolveNPCPositions(ability.pos,pull_radius)
    caster:RemoveModifierByName(keys.modifier_1)
    caster:RemoveModifierByName(keys.modifier_2)
end

function pull (keys)
    local caster = keys.caster
    local ability = keys.ability
    local pos = ability.pos
    local pull_radius = ability:GetLevelSpecialValueFor("pull_radius", (ability:GetLevel() - 1))
    local pull_speed = ability:GetLevelSpecialValueFor("pull_speed", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, pull_radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in ipairs(units) do
        local location = unit:GetAbsOrigin()
        local distance = (pos - location):Length2D()
        local direction = (pos - location):Normalized()
        if distance >= pull_speed then
			unit:SetAbsOrigin(location + direction * pull_speed)
		else
			unit:SetAbsOrigin(location + direction * distance)
		end
    end 
end

function damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local pos = ability.pos
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local damage_tick = ability:GetLevelSpecialValueFor("damage_tick", (ability:GetLevel() - 1))
    local base_damage = ability:GetLevelSpecialValueFor("base_damage", (ability:GetLevel() - 1))
    local increase_dmg_percent = ability:GetLevelSpecialValueFor("increase_dmg_percent", (ability:GetLevel() - 1))
    local damage = base_damage * (1 + ability.times * increase_dmg_percent / 100)
    local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = damage
    } 
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in ipairs(units) do
        damage_table.victim = unit
        ApplyDamage(damage_table)
        ability:ApplyDataDrivenModifier( caster, unit, keys.debuff, {Duration = damage_tick} )
    end
    ability.times = ability.times + 1
end