function ManaBreak( keys )
	local target = keys.target
	local caster = keys.caster
    local pos = caster:GetAbsOrigin()
	local ability = keys.ability
    local sound = keys.sound_name
    local particle = keys.particle_name
    local base_burnt= ability:GetLevelSpecialValueFor("base_burnt", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    
    local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local total_damage = base_burnt
    target:ReduceMana(total_damage)
    SendOverheadEventMessage(nil,OVERHEAD_ALERT_MANA_LOSS,target,total_damage,nil)
	local damageTable = {
        attacker = caster,
        damage_type = ability:GetAbilityDamageType(),
        ability = ability,
        damage = total_damage
    }
    for _,unit in ipairs(units) do


		damageTable.victim = unit
		ApplyDamage(damageTable)
        unit:EmitSound(sound)
        unit:ReduceMana(total_damage)

        local particleid = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit)
        ParticleManager:SetParticleControlEnt(particleid, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
        if unit == target then ParticleManager:SetParticleControlEnt(particleid, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true) end
    end
end