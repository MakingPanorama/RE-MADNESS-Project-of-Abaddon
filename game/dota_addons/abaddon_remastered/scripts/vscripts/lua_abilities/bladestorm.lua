require "../timers"
function BladestormDamage(event)
    local caster = event.caster
    local ability = event.ability
    local outermost_damage = ability:GetLevelSpecialValueFor("outermost_damage", ability:GetLevel() - 1)
    local distance_coefficient = ability:GetLevelSpecialValueFor("distance_coefficient", ability:GetLevel() - 1)
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local unitsToDamage = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damageTable={
            attacker = caster,
            ability = ability,
            damage_type = ability:GetAbilityDamageType()          
    }
    for _,target in pairs(unitsToDamage) do
        target:EmitSound("Hero_Juggernaut.BladeFury.Impact")
        local distance= radius - CalcDistanceBetweenEntityOBB(target, caster)
        damageTable.damage =  (outermost_damage + distance * distance_coefficient)/2
        damageTable.victim = target
        ApplyDamage(damageTable)
    end
end

--Stops the looping sound event
function Stop( event )
	local caster = event.caster	
	caster:StopSound("Hero_Juggernaut.BladeFuryStart")
end

function CreateParticle (event)
    local caster = event.caster
    local ability = event.ability
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local factor = radius/20
    for i=1, 20 do
        local particle_name = nil
        if i % 2 == 0 then
            particle_name = event.particle_1
        else
            particle_name = event.particle_2
        end
        local point = factor * i
        local particleid = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControl(particleid, 5, Vector(point,0,0)) 
        Timers:CreateTimer(duration,function()
            ParticleManager:DestroyParticle(particleid,false) 
        end
        )
    end
end