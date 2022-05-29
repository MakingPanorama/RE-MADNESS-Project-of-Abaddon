function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in ipairs(units) do
        unit:EmitSound(keys.sound_name)
        ability:ApplyDataDrivenModifier( caster, unit, keys.debuff, {Duration = duration} )
    end 
end


function damage (keys)
     local caster = keys.caster
     local ability = keys.ability
     local target = keys.target
     local damage_per_second = ability:GetLevelSpecialValueFor("damage_per_second", (ability:GetLevel() - 1))
     local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = damage_per_second,
        victim = target
    } 
    ApplyDamage(damage_table)
end

function amp (keys)
    local attacker = keys.attacker
    local target = keys.target
    local ability = keys.ability
    local attacked_amp_percent = ability:GetLevelSpecialValueFor("attacked_amp_percent", (ability:GetLevel() - 1))
    local damage = keys.damage * attacked_amp_percent / 100 
    local damage_table={
        attacker = attacker,
	    ability = ability,
	    damage_type = DAMAGE_TYPE_PHYSICAL,
        damage = damage,
        victim = target
    }
    ApplyDamage(damage_table)
end

function stop (keys)
    local target = keys.target
    StopSoundEvent(keys.sound_name, target)
end