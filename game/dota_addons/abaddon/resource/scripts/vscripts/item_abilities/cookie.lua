function use (keys)
    local caster = keys.caster
    local ability = keys.ability
    local hp = ability:GetLevelSpecialValueFor("tooltip_hp", (ability:GetLevel() - 1))
    local mp = ability:GetLevelSpecialValueFor("tooltip_mp", (ability:GetLevel() - 1))
    local sound = keys.sound_name
    caster:EmitSound(sound)
    caster:Heal(hp,caster)
    local current_mana = caster:GetMana()
    caster:SetMana(current_mana + mp)
end