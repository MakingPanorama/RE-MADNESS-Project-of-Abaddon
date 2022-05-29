function damage (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle = keys.particle_name
    local sound = keys.sound_name
    local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local distance = radius - damage_radius
    local pos = caster:GetAbsOrigin() + Vector(RandomInt(-distance,distance),RandomInt(-distance,distance))
    local particle_id = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particle_id, 0, pos)
    ParticleManager:SetParticleControl(particle_id, 1, Vector(pos.x,pos.y,pos.z+1100))
    Timers:CreateTimer(1.5, function()
        ParticleManager:DestroyParticle(particle_id, false)
    end)
    local damageTable = {
        attacker = caster,
        ability = ability,
        damage_type = ability:GetAbilityDamageType(),
        damage = damage
    }
   caster:EmitSound(sound)
   local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, damage_radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
   for _,unit in ipairs(units) do
        damageTable.victim = unit 
        ApplyDamage(damageTable)
   end 
end