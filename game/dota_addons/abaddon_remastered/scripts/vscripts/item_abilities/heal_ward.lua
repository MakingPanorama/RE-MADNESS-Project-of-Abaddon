function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle = keys.particle_name
    local buff = keys.buff
    local pos = ability:GetCursorPosition()
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local player_id = caster:GetPlayerID()
    local ward = CreateUnitByName("healing_ward", pos, true, caster, nil, caster:GetTeam())
    ward:SetControllableByPlayer(player_id, true)

    ability:ApplyDataDrivenModifier( ward, ward, buff, { } )
    local particleid = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, ward)
    ParticleManager:SetParticleControl(particleid, 1, Vector(radius,radius,pos.z))

    Timers:CreateTimer(12, function()
        ward:ForceKill( true )
        ParticleManager:DestroyParticle(particleid, true)
    end)

end