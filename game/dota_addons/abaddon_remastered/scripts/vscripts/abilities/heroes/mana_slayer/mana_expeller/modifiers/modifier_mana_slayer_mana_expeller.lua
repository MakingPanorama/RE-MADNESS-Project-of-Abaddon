modifier_mana_slayer_mana_expeller = class({})

function modifier_mana_slayer_mana_expeller:IsHidden() return true end
function modifier_mana_slayer_mana_expeller:OnCreated()
    self:GetParent():SetRenderColor(255, 185, 15)
end
function modifier_mana_slayer_mana_expeller:OnDestroy()
    self:GetParent():SetRenderColor(255, 255, 255)
end

function modifier_mana_slayer_mana_expeller:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_mana_slayer_mana_expeller:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor('regen_bonus')
end

function modifier_mana_slayer_mana_expeller:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end

function modifier_mana_slayer_mana_expeller:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('bonus_damage')
end

