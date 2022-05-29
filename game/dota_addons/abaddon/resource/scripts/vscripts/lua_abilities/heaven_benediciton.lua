function heal (keys)
    local caster = keys.caster
	local ability = keys.ability
    local target = keys.target
    local base_heal = ability:GetLevelSpecialValueFor("base_heal", (ability:GetLevel() - 1))
    local bonus_heal_percentage = ability:GetLevelSpecialValueFor("bonus_heal_percentage", (ability:GetLevel() - 1))
    local loss_hp = target:GetMaxHealth() - target:GetHealth()
    local total_heal = base_heal + ( loss_hp * bonus_heal_percentage / 100 )
    target:Heal(total_heal,caster)
end

function reduce (keys)
    local damage = keys.damage
    local unit = keys.unit
    local ability = keys.ability
    local damage_reduce = ability:GetLevelSpecialValueFor("damage_reduce", (ability:GetLevel() - 1))
    local refund = damage * damage_reduce / 100
    unit:SetHealth(unit:GetHealth() + refund)
end