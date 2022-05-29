function taken (keys)
    local unit=keys.target
    local ability = keys.ability
    local bonus_duration = ability:GetLevelSpecialValueFor("bonus_duration", ability:GetLevel() - 1)
    local max_stack = ability:GetLevelSpecialValueFor("max_stack", ability:GetLevel() - 1)
    local modifier_name = keys.modifier_name
    if unit:HasModifier( modifier_name )then
        local current_stack = unit:GetModifierStackCount( modifier_name, ability )     
        ability:ApplyDataDrivenModifier( unit, unit, modifier_name, { Duration = bonus_duration } )
        current_stack = math.min(current_stack+1,max_stack)
        unit:SetModifierStackCount( modifier_name, ability, current_stack )
    else  
        ability:ApplyDataDrivenModifier( unit, unit, modifier_name, { Duration = bonus_duration } )
        unit:SetModifierStackCount( modifier_name, ability, 1 ) 
    end
end