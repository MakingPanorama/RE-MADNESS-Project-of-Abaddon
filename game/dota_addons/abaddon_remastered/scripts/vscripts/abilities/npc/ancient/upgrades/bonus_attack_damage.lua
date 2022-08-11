LinkLuaModifier( "modifier_ancient_global_bonus_attack_damage", "abilities/npc/ancient/upgrades/bonus_attack_damage.lua", LUA_MODIFIER_MOTION_NONE )
ancient_global_bonus_attack_damage = class({})

function ancient_global_bonus_attack_damage:GetIntrinsicModifierName()
	return 'modifier_ancient_global_bonus_attack_damage'
end

modifier_ancient_global_bonus_attack_damage = class({})

function modifier_ancient_global_bonus_attack_damage:IsHidden()
    return true
end

function modifier_ancient_global_bonus_attack_damage:IsAura()
    return true
end

function modifier_ancient_global_bonus_attack_damage:GetAuraRadius()
    return 99999
end

function modifier_ancient_global_bonus_attack_damage:GetModifierAura()
    return 'modifier_ancient_global_bonus_attack_damage'
end

function modifier_ancient_global_bonus_attack_damage:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ancient_global_bonus_attack_damage:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_ancient_global_bonus_attack_damage:GetAuraEntityReject(hEntity)
    if hEntity:IsRealHero() or hEntity:IsHero() then
        return false
    end

    return true
end

function modifier_ancient_global_bonus_attack_damage:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_ancient_global_bonus_attack_damage:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('bonus_attack_damage')
end