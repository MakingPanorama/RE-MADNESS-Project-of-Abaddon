function addparticle (keys)
    local caster = keys.caster
    local ability = keys.ability
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
    local particleid = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particleid, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particleid, 2, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particleid, 3, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
    Timers:CreateTimer(duration,function()
        ParticleManager:DestroyParticle(particleid,true) 
    end
    )
end

function damageabsorb (keys)
    local caster = keys.caster
    local ability = keys.ability
    local block_threshold = ability:GetLevelSpecialValueFor("block_threshold", ability:GetLevel() - 1 )
    local damage = keys.damage
    local sound = keys.sound
    if damage < block_threshold then
        caster:SetHealth(caster:GetHealth() + damage)
    end
    EmitSoundOn(sound, caster)
end