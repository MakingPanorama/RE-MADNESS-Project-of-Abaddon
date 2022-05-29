function damage (keys)
    local caster = keys.caster
	local ability = keys.ability
    local target = keys.target
    local point = target:GetAbsOrigin()
    local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local particle = keys.particle_name
    local sound = keys.sound_name
    local debuff = keys.modifier_name
    
    local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damageTable = {}
    damageTable.attacker = caster
    damageTable.ability = ability
    damageTable.damage_type = ability:GetAbilityDamageType()
    damageTable.damage = damage
    for _,unit in ipairs(units) do
		damageTable.victim = unit
		ApplyDamage(damageTable)
        ability:ApplyDataDrivenModifier( caster, unit, debuff, { Duration = duration } )
        unit:EmitSound(sound)
        local particleid = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit)
        ParticleManager:SetParticleControl(particleid, 1, unit:GetAbsOrigin())
        Timers:CreateTimer(1.5, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)
	end
end