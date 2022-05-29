function initial (keys)
    local caster = keys.caster
    local ability = keys.ability
    local point = ability:GetCursorPosition()
    local duration = keys.duration_time
    local modifier = keys.modifier_name
    local whole_radius = ability:GetLevelSpecialValueFor("whole_radius", (ability:GetLevel() - 1))
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    local ability_unit = CreateUnitByName( "ability_usage_unit", point, true, caster, caster, caster:GetTeamNumber() )
    ability_unit:AddNewModifier(ability_unit, nil, "modifier_kill", {duration = duration})
    ability_unit:SetDayTimeVisionRange(whole_radius)
    ability_unit:SetNightTimeVisionRange(whole_radius)
    ability:ApplyDataDrivenModifier( ability_unit, ability_unit, modifier, {} )
    ability:ApplyDataDrivenModifier( ability_unit, ability_unit, keys.ability_usage, {} )
    ability_unit:AddNoDraw()
end

function create (keys)
   local caster = keys.caster
   local ability = keys.ability
   local target = keys.target
   local point = target:GetAbsOrigin()
   local whole_radius = ability:GetLevelSpecialValueFor("whole_radius", (ability:GetLevel() - 1))
   local effect_radius = ability:GetLevelSpecialValueFor("effect_radius", (ability:GetLevel() - 1))
   local knock_duration = ability:GetLevelSpecialValueFor("knock_duration", (ability:GetLevel() - 1))
   local knock_height = ability:GetLevelSpecialValueFor("knock_height", (ability:GetLevel() - 1))
   local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
   local border = whole_radius - effect_radius
   local random1=RandomInt(-border, border)
   local random2=RandomInt(-border, border)
   local position = point + Vector(random1,random2,0)
   local ability_unit = CreateUnitByName( "ability_usage_unit", position, true, caster, caster, caster:GetTeamNumber() )
   local particleid = ParticleManager:CreateParticle(keys.particle_name, PATTACH_WORLDORIGIN, ability_unit)
   ParticleManager:SetParticleControl(particleid, 0, position)
   Timers:CreateTimer(2, function()
         ParticleManager:DestroyParticle(particleid, false)
   end)
   EmitSoundOn( "Ability.Torrent", ability_unit )
   ability_unit:AddNoDraw()
   ability:ApplyDataDrivenModifier( ability_unit, ability_unit, keys.ability_usage, {} )
   ability_unit:ForceKill(false)
   local units = FindUnitsInRadius(caster:GetTeam(), position, nil, effect_radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
   local knock={
         should_stun = 1, knockback_duration = knock_duration,
         duration = knock_duration, knockback_distance = 0, knockback_height = knock_height
   }
   local damage_table={
        attacker = caster,
	    ability = ability,
	    damage_type = ability:GetAbilityDamageType(),
        damage = damage
   } 
   for _,unit in ipairs(units) do
        local unit_pos = unit:GetAbsOrigin()
        knock.center_x = unit_pos.x
        knock.center_y = unit_pos.y
        knock.center_z = unit_pos.z
        damage_table.victim = unit
		unit:AddNewModifier( hero, nil, "modifier_knockback", knock )
        ApplyDamage(damage_table)
   end
end