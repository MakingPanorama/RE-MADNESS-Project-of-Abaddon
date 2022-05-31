function haste_armor(keys)
    local caster = keys.caster
    local ability = keys.ability
    print ("test")
    ability:ApplyDataDrivenModifier(caster, caster, "haste_armor_bonus", {})
    Timers:CreateTimer(0.03,function()
        if caster:IsAlive() then
            if caster:GetBaseDamageMax() ~= caster:GetModifierStackCount( "haste_armor_bonus", ability ) then
                caster:SetModifierStackCount( "haste_armor_bonus", ability, caster:GetBaseMaxHealth() )
            end
            return 0.3
        end
    end)
end

function refresh_haste_armor(keys)
    local caster = keys.caster
    local ability = keys.ability
    ability:ApplyDataDrivenModifier(caster, caster, "haste_armor_bonus", {})
    caster:SetModifierStackCount( "haste_armor_bonus", ability, caster:GetBaseMaxHealth() )
end