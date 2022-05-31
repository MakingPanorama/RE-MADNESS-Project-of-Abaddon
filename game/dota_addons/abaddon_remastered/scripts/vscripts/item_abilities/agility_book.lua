function add (keys)
    local caster=keys.caster
    local ability=keys.ability
    local bonus_str = ability:GetLevelSpecialValueFor("bonus_agility", ability:GetLevel() - 1)
    local buff = keys.buff
    if caster:HasModifier( buff )then
        local current_stack = caster:GetModifierStackCount( buff, ability )     
        caster:SetModifierStackCount( buff, ability, current_stack+1 ) 
    else 
        ability:ApplyDataDrivenModifier( caster, caster, buff, { } )
        caster:SetModifierStackCount( buff, ability, 1 ) 
    end
    caster:EmitSound(keys.sound)
end