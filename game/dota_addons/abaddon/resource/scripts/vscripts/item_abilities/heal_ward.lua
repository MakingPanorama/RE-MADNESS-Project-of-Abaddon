function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle = keys.particle_name
    local buff = keys.buff
    local pos = ability:GetCursorPosition()
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local ward = CreateUnitByName("Team Healing Ward", pos, true, caster, nil, caster:GetTeam())
    ward:AddNewModifier(ward, nil, "modifier_kill", {duration = duration})
    ability:ApplyDataDrivenModifier( ward, ward, buff, { } )
    local particleid = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, ward)
    ParticleManager:SetParticleControl(particleid, 1, Vector(radius,radius,pos.z))
end