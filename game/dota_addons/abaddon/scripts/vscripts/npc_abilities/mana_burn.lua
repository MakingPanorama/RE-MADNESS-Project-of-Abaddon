function effect (keys)
    local caster = keys.caster
    local target = keys.target
    if target then
        local sound = keys.sound_name
        target:EmitSound(sound)
        local particle = keys.particle_name  
        local particleid = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
        Timers:CreateTimer(0.8, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)
    end
end