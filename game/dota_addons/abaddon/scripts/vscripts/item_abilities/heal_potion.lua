function heal (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local heal = ability:GetLevelSpecialValueFor("heal", (ability:GetLevel() - 1))
    local sound = keys.sound_name
    local particle = keys.particle_name
    target:EmitSound(sound)
    target:Heal(heal,caster)
    local particle_id = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
    Timers:CreateTimer(1.5, function()
          ParticleManager:DestroyParticle(particle_id, false)
    end)
    SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,target,heal,nil)
end