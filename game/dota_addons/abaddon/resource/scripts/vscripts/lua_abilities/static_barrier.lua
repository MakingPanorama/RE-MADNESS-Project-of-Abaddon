function damage (keys)
    local attacker = keys.attacker
    local target = keys.target
    if not attacker:IsMagicImmune() then
        local ability = keys.ability
        local particle = keys.particle_name
        local particle_id = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, target)
        ParticleManager:SetParticleControl(particle_id, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_id, 1, attacker:GetAbsOrigin())
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(particle_id, false)
        end)
        local base_damage = ability:GetLevelSpecialValueFor("base_damage", (ability:GetLevel() - 1))
        local bonus_damage_int_percent = ability:GetLevelSpecialValueFor("bonus_damage_int_percent", (ability:GetLevel() - 1))
        local damage = base_damage + (bonus_damage_int_percent / 100 * target:GetIntellect())
        print (damage)
        local damageTable = {
            attacker = target,
            ability = ability,
            damage_type = ability:GetAbilityDamageType(),
            damage = damage,
            victim = attacker
        }           
        ApplyDamage(damageTable)
    end 
end