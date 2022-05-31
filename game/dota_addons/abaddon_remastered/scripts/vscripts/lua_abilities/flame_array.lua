function inital (keys)
    local ability = keys.ability
    ability.pos = ability:GetCursorPosition()
end
function damage (keys)
    local caster = keys.caster
	local ability = keys.ability
    local point = ability.pos
    local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
    local bonus_duration = ability:GetLevelSpecialValueFor("bonus_duration", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local debuff = keys.modifier_1
    local buff = keys.modifier_2
    local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damageTable = {}
    damageTable.attacker = caster
    damageTable.ability = ability
    damageTable.damage_type = ability:GetAbilityDamageType()
    damageTable.damage = damage
    local count = 0
    for _,unit in ipairs(units) do
		damageTable.victim = unit
		ApplyDamage(damageTable)
        ability:ApplyDataDrivenModifier( caster, unit, debuff, { Duration = stun_duration } )
        count = count + 1
	end
    if count ~= 0 then
        if caster:HasModifier( buff )then
            local current_stack = caster:GetModifierStackCount( buff, ability )     
            ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = bonus_duration } )
            caster:SetModifierStackCount( buff, ability, current_stack + count )
        else  
            ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = bonus_duration } )
            caster:SetModifierStackCount( buff, ability, count ) 
        end 
    end
end