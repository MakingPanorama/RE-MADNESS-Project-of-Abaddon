function ability_executed(keys)
	local target = keys.target
    local caster = keys.caster
    if target == caster then
        local ability =target:FindAbilityByName("Mana_Hater")                     
        local bonus_duration = ability:GetLevelSpecialValueFor("buff_duration", (ability:GetLevel() - 1))
        local modifierName = "Mana_Hater_Buffs"
        if target:IsAlive() then
            local particleid = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_CENTER_FOLLOW,target)
            Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(particleid, false)
            end)
            if target:HasModifier( modifierName ) then
                local current_stack = target:GetModifierStackCount( modifierName, ability )
                ability:ApplyDataDrivenModifier( target, target, modifierName, { Duration = bonus_duration } )
                target:SetModifierStackCount( modifierName, ability, current_stack+1 )   
            else  
                ability:ApplyDataDrivenModifier( target, target, modifierName, { Duration = bonus_duration } )
                target:SetModifierStackCount( modifierName, ability, 1 ) 
            end
        end
    end
end