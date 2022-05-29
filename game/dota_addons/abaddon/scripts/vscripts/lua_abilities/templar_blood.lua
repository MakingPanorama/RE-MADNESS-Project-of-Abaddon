function check (keys)
    local caster = keys.caster
    local ability = keys.ability 
    local lose_per_health = ability:GetLevelSpecialValueFor("lose_per_health", (ability:GetLevel() - 1))
    local max_stack = ability:GetLevelSpecialValueFor("max_stack", (ability:GetLevel() - 1))
    local lose_health = caster:GetMaxHealth() - caster:GetHealth()
    local count = math.ceil(lose_health / lose_per_health)
    count = math.min(count, max_stack)
    local modifier = "templar_blood_buff"
    if count ~= 0 then
        if caster:HasModifier( modifier )then
            caster:SetModifierStackCount( modifier , ability, count)
        else  
            ability:ApplyDataDrivenModifier( caster, caster, modifier, {} )
            caster:SetModifierStackCount( modifier, ability, count ) 
        end
    else
        caster:RemoveModifierByName(modifier) 
    end
end