function damage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local targetLocation = target:GetAbsOrigin()
	local damage_coefficient = ability:GetLevelSpecialValueFor("damage_coefficient", (ability:GetLevel() - 1))
	local radius = ability:GetSpecialValueFor("radius")
    local damage = damage_coefficient * caster:GetIntellect()
    local particle = keys.particle_name
    local sound = keys.sound_name
	local damageTable = {}
	damageTable.attacker = caster
	damageTable.ability = ability
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.damage = damage
	local units = FindUnitsInRadius(caster:GetTeam(), targetLocation, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
	for _,unit in ipairs(units) do
		damageTable.victim = unit
		ApplyDamage(damageTable)
        unit:EmitSound(sound)
        local particleid = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, unit)
        ParticleManager:SetParticleControlEnt(particleid, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
        ParticleManager:SetParticleControlEnt(particleid, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), false)    
        ParticleManager:SetParticleControl(particleid, 2, Vector(1000, 1000, 1000))
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)
	end
end