function projectile (keys)
    local caster = keys.caster
	local projectile_model = keys.particle_name
	caster:SetRangedProjectileName(projectile_model)
end

function debuff (keys)
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local pos = target:GetAbsOrigin()
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local debuff = keys.debuff
	local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	for _,unit in ipairs(units) do
        ability:ApplyDataDrivenModifier( caster, unit, debuff, {duration = duration} )
        local particleid = ParticleManager:CreateParticle(keys.particle_name, PATTACH_WORLDORIGIN, unit)
        ParticleManager:SetParticleControl(particleid, 0, unit:GetAbsOrigin())
        Timers:CreateTimer(0.6, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)
	end
end