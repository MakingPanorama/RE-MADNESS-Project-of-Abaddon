function create (keys)
    local caster = keys.caster
	local ability = keys.ability
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local level = ability:GetLevel()
    ability.ice_ball = CreateUnitByName("Ice Ball", caster:GetAbsOrigin(), true, caster, nil, caster:GetTeam())
    ability.ice_ball:CreatureLevelUp(level-1)
    ability.ice_ball:SetControllableByPlayer(caster:GetPlayerID(), true)
    ability.ice_ball:SetOwner(caster)
    ability.ice_ball:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
    ability:ApplyDataDrivenModifier( caster, ability.ice_ball, keys.modifier_name, {} )  
end
