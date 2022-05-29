LinkLuaModifier( "modifier_ancient_bonus_hp", "abilities/npc/ancient/upgrades/bonus_hp.lua", LUA_MODIFIER_MOTION_NONE )
ancient_bonus_hp = class({})

function ancient_bonus_hp:GetIntrinsicModifierName()
	return 'modifier_ancient_bonus_hp'
end

modifier_ancient_bonus_hp = class({})

function modifier_ancient_bonus_hp:IsAura()
    return true
end

function modifier_ancient_bonus_hp:GetAuraRadius()
    return 99999
end

function modifier_ancient_bonus_hp:GetModifierAura()
    return 'modifier_ancient_bonus_hp'
end

function modifier_ancient_bonus_hp:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ancient_bonus_hp:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC
end

function modifier_ancient_bonus_hp:GetAuraEntityReject(hEntity)
    if hEntity:IsRealHero() or hEntity:IsHero() or hEntity:IsIllusion() then
        return true
    end

    return false
end

function modifier_ancient_bonus_hp:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end

function modifier_ancient_bonus_hp:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_health')
end