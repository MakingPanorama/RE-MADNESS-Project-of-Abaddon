function create (keys)
    local caster=keys.caster
    local ability=keys.ability
    local debuff=keys.debuff
    local particle_name = keys.particle_name
    local self_hp_cost_per_second = ability:GetLevelSpecialValueFor("self_hp_cost_per_second", ability:GetLevel() - 1)
    local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability:GetLevel() - 1) 
    local bonus_damage_per_agility = ability:GetLevelSpecialValueFor("bonus_damage_per_agility", ability:GetLevel() - 1)
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local tick = ability:GetLevelSpecialValueFor("tick", ability:GetLevel() - 1)
    local damage_self={
            attacker = caster,
            victim = caster,
            ability = ability,
            damage = caster:GetMaxHealth()*self_hp_cost_per_second/100,
            damage_type = ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
    }
    ApplyDamage(damage_self)
    
    local damage = base_damage + caster:GetAgility() * bonus_damage_per_agility
    local damage_enemy={
            attacker = caster,
            ability = ability,
            damage = damage,
            damage_type = ability:GetAbilityDamageType() 
    }
    local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in pairs(units) do
        damage_enemy.victim = unit
        ApplyDamage(damage_enemy)
        ability:ApplyDataDrivenModifier( caster, unit, debuff, { Duration = tick } )
        unit.particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, unit)
        Timers:CreateTimer(0.5,function()
            ParticleManager:DestroyParticle(unit.particle,true) 
        end
        )
	end
end

    