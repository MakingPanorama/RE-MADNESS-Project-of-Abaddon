LinkLuaModifier('modifier_ancient_bonus_armor', 'abilities/npc/ancient/upgrades/bonus_armor.lua', LUA_MODIFIER_MOTION_NONE)
ancient_bonus_armor = class({})

function ancient_bonus_armor:GetIntrinsicModifierName()
    return 'modifier_ancient_bonus_armor'
end

modifier_ancient_bonus_armor = class({})

function modifier_ancient_bonus_armor:IsAura()
    return true
end

function modifier_ancient_bonus_armor:GetAuraRadius()
    return 99999
end

function modifier_ancient_bonus_armor:GetModifierAura()
    return 'modifier_ancient_bonus_armor'
end

function modifier_ancient_bonus_armor:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ancient_bonus_armor:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC
end

function modifier_ancient_bonus_armor:GetAuraEntityReject(hEntity)
    if hEntity:IsRealHero() or hEntity:IsHero() or hEntity:IsIllusion() then
        return true
    end

    return false
end

function modifier_ancient_bonus_armor:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_ancient_bonus_armor:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_physical_armor')
end

function modifier_ancient_bonus_armor:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_magical_armor')
end