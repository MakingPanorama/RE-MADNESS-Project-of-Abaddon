function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local particle = keys.particle_name
    local buff = keys.buff
    local pos = ability:GetCursorPosition()
    local ability_unit = CreateUnitByName( "ability_usage_unit", pos, false, caster, caster, caster:GetTeamNumber() )
    ability_unit:AddNoDraw()
    local particles={}
    for i=1, 1000 do
        local random_angle = RandomInt(0,360)
        local random_radius = RandomInt(0, radius)
        local random_pos_x = random_radius * math.sin(math.rad(random_angle))
        local random_pos_y = random_radius * math.cos(math.rad(random_angle))
        local random_pos = pos + Vector(random_pos_x,random_pos_y)
        particles[i] = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, ability_unit)
        ParticleManager:SetParticleControl(particles[i], 2, random_pos) 
        Timers:CreateTimer(duration, function()
            ParticleManager:DestroyParticle(particles[i], false)
        end)
    end
    
    ability_unit:AddNewModifier(ward, nil, "modifier_kill", {duration = duration})
    ability:ApplyDataDrivenModifier( caster, ability_unit, buff, {} ) 
    ability.pos = pos
end

function damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local debuff = keys.debuff
    local debuff_duration = ability:GetLevelSpecialValueFor("tick", (ability:GetLevel() - 1)) - 0.05
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local base_damage_per_second = ability:GetLevelSpecialValueFor("base_damage_per_second", (ability:GetLevel() - 1))
    local extra_damage_percent_per_second = ability:GetLevelSpecialValueFor("extra_damage_percent_per_second", (ability:GetLevel() - 1))
    local damage = base_damage_per_second + (caster:GetMaxMana() * extra_damage_percent_per_second / 100)
    local units = FindUnitsInRadius(caster:GetTeam(), ability.pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = damage
    } 
    for _,unit in ipairs(units) do
        damage_table.victim = unit
        ApplyDamage(damage_table)
        ability:ApplyDataDrivenModifier( caster, unit, debuff, {Duration = debuff_duration} )
    end 
end