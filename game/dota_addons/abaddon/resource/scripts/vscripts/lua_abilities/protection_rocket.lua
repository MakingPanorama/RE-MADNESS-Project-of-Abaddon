function initial (keys)
    local caster = keys.caster
    local pos = caster:GetAbsOrigin()
    local ability = keys.ability
    local debuff = keys.debuff
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in ipairs(units) do
        ability:ApplyDataDrivenModifier( caster, unit, debuff, { Duration = duration } )
    end
end

function create (keys)
    local caster = keys.caster
    local target = keys.target
    local particle = keys.particle_name
    target.protection_rocket_projectile = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, target)
    ParticleManager:SetParticleControlEnt(target.protection_rocket_projectile, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(target.protection_rocket_projectile, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function destroy (keys)
    local target = keys.target
    ParticleManager:DestroyParticle(target.protection_rocket_projectile, false)
    StopSoundEvent(keys.sound_name,target)
end

function damage (keys)
    local caster = keys.caster
    local target = keys.target
    if not caster:IsAlive() then
        target:RemoveModifierByName(keys.debuff)
    else
        local ability = keys.ability
        local damage_per_second = ability:GetLevelSpecialValueFor("damage_per_second", (ability:GetLevel() - 1))
        local interval = ability:GetLevelSpecialValueFor("interval", (ability:GetLevel() - 1))
        local damage = damage_per_second * interval
        local damageTable = {
            attacker = caster,
            ability = ability,
            damage_type = ability:GetAbilityDamageType(),
            damage = damage,
            victim = target
        }
        ApplyDamage(damageTable)
        caster:Heal(damage, caster)       
    end
end