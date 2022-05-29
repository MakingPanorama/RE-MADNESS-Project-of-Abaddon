function Upgrade (keys)
    local ability = keys.ability
    local caster = keys.caster
    local level = ability:GetLevel()
    local buff = keys.buff
    local max_charge = ability:GetLevelSpecialValueFor("max_charge", (level - 1))
    ability.max_charge = max_charge
    if level == 1 then
        ability:ApplyDataDrivenModifier( caster, caster, buff, { } )
        caster:SetModifierStackCount( buff, ability, max_charge )
    else
        local pre_max_charge = ability:GetLevelSpecialValueFor("max_charge", (level - 2))
        local append = max_charge - pre_max_charge
        local current_stack = caster:GetModifierStackCount( buff, ability ) 
        caster:SetModifierStackCount( buff, ability, current_stack + append )
    end
    ability:EndCooldown()
end

function Use (keys)
    local ability = keys.ability
    local buff = keys.buff 
    local caster = keys.caster
    local pos = keys.target:GetAbsOrigin()
    local current_stack = caster:GetModifierStackCount( buff, ability ) 
    local charge_time = ability:GetLevelSpecialValueFor("charge_time", (ability:GetLevel() - 1))
    caster:SetModifierStackCount( buff, ability, current_stack - 1 )
    if current_stack == ability.max_charge then
        ability.first_use = GameRules:GetGameTime()
    end
    if current_stack == 1 then
        ability.last_use = GameRules:GetGameTime()
        local interval = ability.last_use - ability.first_use
        ability:StartCooldown(charge_time-interval)
    end    
    Timers:CreateTimer(charge_time, function()
         Recharge(keys)
    end)
    local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damageTable = {
        attacker = caster,
        ability = ability,
        damage_type = ability:GetAbilityDamageType(),
        damage = damage
    }
    for _,unit in ipairs(units) do
        damageTable.victim = unit
        ApplyDamage(damageTable)
        unit:EmitSound(keys.sound_name)
        local particle = ParticleManager:CreateParticle(keys.particle_name, PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(particle,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
		ParticleManager:SetParticleControl(particle,1,Vector(unit:GetAbsOrigin().x,unit:GetAbsOrigin().y,unit:GetAbsOrigin().z + unit:GetBoundingMaxs().z ))
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(particle, false)
        end)
    end
end

function Recharge(keys)
    local ability = keys.ability
    local buff = keys.buff 
    local caster = keys.caster
    local current_stack = caster:GetModifierStackCount( buff, ability ) 
    caster:SetModifierStackCount( buff, ability, current_stack + 1 )
end