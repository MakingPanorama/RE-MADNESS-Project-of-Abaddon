LinkLuaModifier('modifier_ancient_global_bonus_attackspeed', 'abilities/npc/ancient/upgrades/global_bonus_attack_speed.lua', LUA_MODIFIER_MOTION_NONE)
ancient_global_bonus_attack_speed = class({})

function ancient_global_bonus_attack_speed:GetIntrinsicModifierName()
    return 'modifier_ancient_global_bonus_attackspeed'
end

modifier_ancient_global_bonus_attackspeed = class({})

function modifier_ancient_global_bonus_attackspeed:IsAura()
    return true
end

function modifier_ancient_global_bonus_attackspeed:GetAuraRadius()
    return 99999
end

function modifier_ancient_global_bonus_attackspeed:GetModifierAura()
    return 'modifier_ancient_global_bonus_attackspeed'
end

function modifier_ancient_global_bonus_attackspeed:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ancient_global_bonus_attackspeed:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_ancient_global_bonus_attackspeed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_ancient_global_bonus_attackspeed:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end