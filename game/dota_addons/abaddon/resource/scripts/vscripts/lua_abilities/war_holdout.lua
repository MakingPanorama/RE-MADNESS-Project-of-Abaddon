function effect (keys)
    local caster = keys.caster
    local particle_name = keys.particle_name
    local range = caster:Script_GetAttackRange()
    for i=1, 3 do
        local position = Vector(range/3*i, range/3*i, 0)
        local particleid = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(particleid, 2, position)
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)
    end
end