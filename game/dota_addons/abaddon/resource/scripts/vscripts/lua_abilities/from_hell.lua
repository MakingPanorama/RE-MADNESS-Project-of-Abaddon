function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local point = caster:GetAbsOrigin()
    local particle_1 = keys.particle_1
    local particle_2 = keys.particle_2
    local sound_1 = keys.sound_1
    local sound_2 = keys.sound_2
    local debuff = keys.debuff
    local buff = keys.buff
    local min_damage = ability:GetLevelSpecialValueFor("min_damage", (ability:GetLevel() - 1))
    local max_damage = ability:GetLevelSpecialValueFor("max_damage", (ability:GetLevel() - 1))
    local damage = RandomInt(min_damage, max_damage)
    local min_stun = ability:GetLevelSpecialValueFor("min_stun", (ability:GetLevel() - 1))
    local max_stun = ability:GetLevelSpecialValueFor("max_stun", (ability:GetLevel() - 1))
    local debuff_duration = RandomFloat(min_stun, max_stun)
    local buff_duration = ability:GetLevelSpecialValueFor("bonus_duration", (ability:GetLevel() - 1))
    local damage_area = ability:GetLevelSpecialValueFor("damage_area", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local random_point = point + Vector(RandomInt(-radius,radius),RandomInt(-radius,radius))
    local ability_unit = CreateUnitByName( "ability_usage_unit", random_point, false, caster, caster, caster:GetTeamNumber() )
    ability_unit:AddNoDraw()
    local RANDOM = RandomInt(1, 2)
    local particle = nil
    local sound = nil
    if RANDOM == 1 then
        particle = particle_1
        sound = sound_1
    else
        particle = particle_2
        sound = sound_2
    end
    EmitSoundOn(sound , ability_unit )
    local particleid = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, ability_unit)
    ParticleManager:SetParticleControl(particleid, 0, random_point)
    Timers:CreateTimer(2, function()
         ParticleManager:DestroyParticle(particleid, false)
    end)
    ability_unit:ForceKill( true )
    local units = FindUnitsInRadius(caster:GetTeam(), random_point, nil, damage_area, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = damage
    } 
    local count = 0
    for _,unit in ipairs(units) do
        damage_table.victim = unit
        ApplyDamage(damage_table)
        ability:ApplyDataDrivenModifier( caster, unit, debuff, {Duration = debuff_duration} )
        count = count + 1
    end 
    if count~=0 then
        if caster:HasModifier( buff )then
            local current_stack = caster:GetModifierStackCount( buff, ability )     
            ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = buff_duration } )
            caster:SetModifierStackCount( buff, ability, current_stack + count )
        else  
            ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = buff_duration } )
            caster:SetModifierStackCount( buff, ability, count ) 
        end 
    end
end