function OnHanshuanglingyuExplosion( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local radius = ability:GetSpecialValueFor("explode_radius")
    local int_amp = ability:GetSpecialValueFor("int_amp")
end
