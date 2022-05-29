function knock_back (keys)
    local caster = keys.caster
    local ability = keys.ability
    local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
    local knock_back_speed = ability:GetLevelSpecialValueFor("knock_back_speed", ability:GetLevel() - 1)
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local pos = caster:GetAbsOrigin()
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damage_table ={
        attacker = caster,
        ability = ability,
        damage_type = ability:GetAbilityDamageType(),
        damage = damage
    }
    local knock= {
         should_stun = 1, knockback_height = 0
    }
    for _,unit in ipairs(units) do
        damage_table.victim = unit
        ApplyDamage(damage_table)
        local distance = radius - CalcDistanceBetweenEntityOBB(unit, caster)
        local knock_duration = distance / knock_back_speed
        local unit_pos = unit:GetAbsOrigin()
        knock.knockback_duration = knock_duration
        knock.duration = knock_duration
        knock.knockback_distance = distance
        knock.center_x = pos.x
        knock.center_y = pos.y
        knock.center_z = pos.z
        unit:AddNewModifier(caster, nil, "modifier_knockback", knock )
    end 
end