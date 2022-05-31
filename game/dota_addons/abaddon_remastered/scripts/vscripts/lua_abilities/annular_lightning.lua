function initial (keys)
    local ability = keys.ability
    ability.pos = ability:GetCursorPosition()
    ability.count = 0
end
function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle = keys.particle_name
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local interval = ability:GetLevelSpecialValueFor("interval", (ability:GetLevel() - 1))
    local debuff_duration = ability:GetLevelSpecialValueFor("debuff_duration", (ability:GetLevel() - 1))
    local particle_id = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particle_id, 0, ability.pos)
    ParticleManager:SetParticleControl(particle_id, 1, Vector(radius,radius,0))
    Timers:CreateTimer(interval*2, function()
        ParticleManager:DestroyParticle(particle_id, false)
    end)
   local ability_unit = CreateUnitByName( "ability_usage_unit", ability.pos, false, caster, caster, caster:GetTeamNumber() )
   EmitSoundOn(keys.sound_name, ability_unit )
   ability_unit:AddNoDraw()
   ability_unit:ForceKill( true )
   local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
   local amp_percent = ability:GetLevelSpecialValueFor("amp_percent", (ability:GetLevel() - 1))
   ability.count = ability.count + 1
   local amp = amp_percent / 100 * ability.count
   local true_damage = damage * (1+ amp)
   local damageTable = {
        attacker = caster,
        ability = ability,
        damage_type = ability:GetAbilityDamageType()      
   }           
   local units = FindUnitsInRadius(caster:GetTeam(), ability.pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
   for _,unit in ipairs(units) do
        damageTable.damage = true_damage
        damageTable.victim = unit
        ApplyDamage(damageTable)
        ability:ApplyDataDrivenModifier( caster, unit, keys.debuff, { Duration = debuff_duration } )
   end
end