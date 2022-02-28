LinkLuaModifier( "modifier_ancient_global_hp_regen", "abilities/npc/ancient/upgrades/bonus_hp_regen.lua", LUA_MODIFIER_MOTION_NONE )
ancient_global_bonus_hp_regen = class({})

function ancient_global_bonus_hp_regen:GetIntrinsicModifierName()
	return 'modifier_ancient_global_hp_regen'
end

modifier_ancient_global_hp_regen = class({})

function modifier_ancient_global_hp_regen:IsAura()
    return true
end

function modifier_ancient_global_hp_regen:GetAuraRadius()
    return 99999
end

function modifier_ancient_global_hp_regen:GetModifierAura()
    return 'modifier_ancient_global_hp_regen'
end

function modifier_ancient_global_hp_regen:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ancient_global_hp_regen:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_ancient_global_hp_regen:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_ancient_global_hp_regen:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor('bonus_health_regen')
end