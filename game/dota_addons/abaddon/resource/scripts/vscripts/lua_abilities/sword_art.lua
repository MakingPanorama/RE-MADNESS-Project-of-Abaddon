function sword_art_crit(keys)
    local caster=keys.caster
    local target=keys.target
    local ability=keys.ability
    local base_crit_chance = ability:GetLevelSpecialValueFor("base_crit_chance", ability:GetLevel() - 1)
    local bonus_chance_per_buff = ability:GetLevelSpecialValueFor("bonus_chance_per_buff", ability:GetLevel() - 1)
    local buff_duration = ability:GetLevelSpecialValueFor("buff_duration", ability:GetLevel() - 1)
    local max_stack = ability:GetLevelSpecialValueFor("max_stack", ability:GetLevel() - 1)
    local modifierName = "Sword_Art_Buff"
    local critmodifier = "Sword_Art_Crit"
    caster:RemoveModifierByName(critmodifier)
    if caster:HasModifier( modifierName )then
        local current_stack = caster:GetModifierStackCount( modifierName, ability )     
        ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = buff_duration } )
        if current_stack < max_stack then
            caster:SetModifierStackCount( modifierName, ability, current_stack+1 )
        else
            caster:SetModifierStackCount( modifierName, ability, max_stack )
        end
    else  
        ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = buff_duration } )
        caster:SetModifierStackCount( modifierName, ability, 1 ) 
    end   
    local stackcount = caster:GetModifierStackCount( modifierName, ability )
    local chance = base_crit_chance + stackcount * bonus_chance_per_buff
    local random = RandomFloat(1, 100)
    if random <= chance then
        ability:ApplyDataDrivenModifier( caster, caster, critmodifier, { Duration = 1 } )
    end
end