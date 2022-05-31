function owner_died (event)
    local caster = event.caster
	local ability = event.ability
	local modifierName = "sword_death_buff"
	local current_stack = caster:GetModifierStackCount( modifierName, ability )
	if current_stack then
		caster:SetModifierStackCount( modifierName, ability, math.ceil(current_stack*2/3) )
	end
    
end

function owner_killed (event)
    local caster = event.caster
	local modifierName = "sword_death_buff"
	local ability = event.ability	
	local max_stack = ability:GetLevelSpecialValueFor( "max_stack", ability:GetLevel() - 1 )    
    if caster:HasModifier( modifierName )then
        local current_stack = caster:GetModifierStackCount( modifierName, ability )     
        ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
        if current_stack < max_stack then
            caster:SetModifierStackCount( modifierName, ability, current_stack+1 )
        else
            caster:SetModifierStackCount( modifierName, ability, max_stack )
        end
    else  
        ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
        caster:SetModifierStackCount( modifierName, ability, 1 ) 
    end   
end