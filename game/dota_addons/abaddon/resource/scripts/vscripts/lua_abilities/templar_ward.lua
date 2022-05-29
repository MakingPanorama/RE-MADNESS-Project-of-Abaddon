function create (keys)
    local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local level = ability:GetLevel()

        local ward = CreateUnitByName("Tempar Ward", point, true, caster, nil, caster:GetTeam())
        ward:CreatureLevelUp(level-1)
        ward:SetControllableByPlayer(caster:GetPlayerID(), true)
        ward:SetOwner(caster)
        ward:AddNewModifier(ward, nil, "modifier_kill", {duration = duration})
        local ward_ability=ward:GetAbilityByIndex(0)
        ward_ability:SetLevel(level)
        EmitSoundOn(keys.sound, caster)
        EmitSoundOn(keys.sound2, trap)

        local owner = ward:GetOwner()

    Timers:CreateTimer(function()
        ward:SetMaxHealth( owner:GetMaxHealth() * 50 / 100 )
        ward:SetHealth( owner:GetHealth() )
        ward:SetBaseMoveSpeed( owner:GetBaseMoveSpeed() )

        print( owner:GetMaxHealth() )
        print( owner:GetBaseMoveSpeed() )
        print( owner:GetAttacksPerSecond() )
        return 0.1
    end)
    local particleid = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particleid, 0, point)
    ParticleManager:SetParticleControl(particleid, 1, point)
    ParticleManager:SetParticleControl(particleid, 2, point)
    Timers:CreateTimer(duration,function()
        ParticleManager:DestroyParticle(particleid,false) 
    end
    )
end

