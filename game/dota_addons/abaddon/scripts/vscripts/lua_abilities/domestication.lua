function change (keys)
    local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local targetLocation = target:GetAbsOrigin()
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local modifier_name = keys.modifier_name
    local units = FindUnitsInRadius(caster:GetTeam(), targetLocation, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for _,unit in ipairs(units) do
        ability:ApplyDataDrivenModifier( caster, unit, modifier_name, { Duration = duration } ) 
        local random = RandomInt(1, 2)
        if random == 1 then
            unit:AddNewModifier(caster, ability, "modifier_shadow_shaman_voodoo", {duration = duration})
        else
            unit:AddNewModifier(caster, ability, "modifier_lion_voodoo", {duration = duration})
        end
    end
end