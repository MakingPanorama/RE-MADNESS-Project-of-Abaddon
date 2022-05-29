function OnChihunSuccess(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local level = ability:GetLevel() - 1
    local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", level)

    local currentStack = caster:GetModifierStackCount("modifier_chihun", caster) or 0
    local nowStack = math.min(currentStack + 1, max_stacks)

    caster:SetModifierStackCount("modifier_chihun", caster, nowStack)
    caster:SetModifierStackCount("modifier_chihun_applier", caster, nowStack)

end

function OnChihunExpired(keys)
    local caster = keys.caster
    caster:SetModifierStackCount("modifier_chihun_applier", caster, 0)
end

function OnChihunHitUnit(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local level = ability:GetLevel() - 1
    local int_multipler = ability:GetLevelSpecialValueFor("int_multipler", level) * 0.01

    local dmg_value = caster:GetBaseDamageMax()

    ApplyDamage({
        attacker = caster,
        victim = target,
        ability = ability,
        damage_flags = 0,
        damage_type = DAMAGE_TYPE_PURE,
        damage = int_multipler * dmg_value,
    })
end