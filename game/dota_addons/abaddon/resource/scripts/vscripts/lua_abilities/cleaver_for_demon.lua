function check (keys)
    local caster = keys.caster
    local ability = keys.ability
    local buff_1 = keys.buff_1
    local buff_2 = keys.buff_2
    if caster:HasModifier("modifier_cleaver_for_gods") then
        caster:RemoveModifierByName (buff_1)
        ability:ApplyDataDrivenModifier( caster, caster, buff_2, {} )
    else
        caster:RemoveModifierByName (buff_2)
        ability:ApplyDataDrivenModifier( caster, caster, buff_1, {} )
    end
    
end