function OnAttackStart(event)
    local caster = event.caster
    local ability = event.ability
	local level = ability:GetLevel()
	local chance_2 = ability:GetLevelSpecialValueFor( "chance_2" , level - 1  )
	local chance_3 = ability:GetLevelSpecialValueFor( "chance_3" , level - 1  )
    local chance_4 = ability:GetLevelSpecialValueFor( "chance_4" , level - 1  )
    local random = RandomInt(1, 100)
    if random <= chance_2 then
        local mod = ability:ApplyDataDrivenModifier(caster,caster,"modifier_geminate_attack",{})
        if random <= chance_3 then
            if random <= chance_4 then
                mod:SetStackCount(3)
            else
                mod:SetStackCount(2)
            end
        else
            mod:SetStackCount(1)
        end
    end
end

function OnAttackLanded(event)
    local caster = event.caster
    local ability = event.ability
    local mod = caster:FindModifierByName("modifier_geminate_attack")
    local newstack = mod:GetStackCount()-1
    if newstack <= 0 then
        caster:RemoveModifierByName("modifier_geminate_attack")
    else
        mod:SetStackCount(newstack)
    end
end