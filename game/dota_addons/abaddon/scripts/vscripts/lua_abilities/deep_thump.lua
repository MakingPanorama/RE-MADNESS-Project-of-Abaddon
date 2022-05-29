function effect (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle1 = keys.particle1
    local particle2 = keys.particle2
    local position = caster:GetAbsOrigin() 
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local coordinator1=	radius*math.sin(math.rad(30))
    local coordinator2=	radius*math.sin(math.rad(60))
    local coordinator3=	radius*math.sin(math.rad(30))/2
    local coordinator4=	radius*math.sin(math.rad(60))/2
    local points={
        Vector (0, 0, 0),
        Vector(radius,0,0), Vector(-radius,0,0), Vector(0,radius,0),Vector(0,-radius,0),
        Vector(coordinator1,coordinator2,0),Vector(coordinator1,-coordinator2,0), 
        Vector(-coordinator1,coordinator2,0),Vector(-coordinator1,-coordinator2,0), 
        Vector(coordinator2,coordinator1,0),Vector(-coordinator2,coordinator1,0),
        Vector(coordinator2,-coordinator1,0),Vector(-coordinator2,-coordinator1,0),
        Vector(radius/2,0,0), Vector(-radius/2,0,0), Vector(0,radius/2,0),Vector(0,-radius/2,0),
        Vector(coordinator3,coordinator4,0),Vector(coordinator3,-coordinator4,0), 
        Vector(-coordinator3,coordinator4,0),Vector(-coordinator3,-coordinator4,0), 
        Vector(coordinator4,coordinator3,0),Vector(-coordinator4,coordinator3,0),
        Vector(coordinator4,-coordinator3,0),Vector(-coordinator4,-coordinator3,0)
    }
    for i=1, 25 do
        local particleid1 = ParticleManager:CreateParticle(particle1, PATTACH_ABSORIGIN, caster)
        local particleid2 = ParticleManager:CreateParticle(particle2, PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(particleid1, 0, position+points[i])
        ParticleManager:SetParticleControl(particleid2, 0, position+points[i])
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(particleid1, false)
        end)
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(particleid2, false)
        end)
    end
end