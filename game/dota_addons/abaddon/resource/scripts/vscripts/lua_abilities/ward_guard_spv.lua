function create (keys)
    local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local level = ability:GetLevel()
    local ward = CreateUnitByName("npc_ward_aggresive", point, true, caster, nil, caster:GetTeam())
   
    ward:AddNewModifier(ward, nil, "modifier_kill", {duration = duration})
    
    EmitSoundOn(keys.sound, caster)
    EmitSoundOn(keys.sound2, trap)
    local particleid = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particleid, 0, point)
    ParticleManager:SetParticleControl(particleid, 1, point)
    ParticleManager:SetParticleControl(particleid, 2, point)
    Timers:CreateTimer(duration,function()
        ParticleManager:DestroyParticle(particleid,false) 
    end
    )
end