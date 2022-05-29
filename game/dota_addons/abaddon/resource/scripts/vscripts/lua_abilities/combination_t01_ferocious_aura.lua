LinkLuaModifier("modifier_combination_t01_ferocious_aura", "lua_abilities/combination_t01_ferocious_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_combination_t01_ferocious_aura_effect", "lua_abilities/combination_t01_ferocious_aura.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if combination_t01_ferocious_aura == nil then
	combination_t01_ferocious_aura = class({}, nil, BaseRestrictionAbility)
end
function combination_t01_ferocious_aura:GetIntrinsicModifierName()
	return "modifier_combination_t01_ferocious_aura"
end
---------------------------------------------------------------------
--Modifiers
if modifier_combination_t01_ferocious_aura == nil then
	modifier_combination_t01_ferocious_aura = class({})
end
function modifier_combination_t01_ferocious_aura:IsHidden()
	return true
end
function modifier_combination_t01_ferocious_aura:IsDebuff()
	return false
end
function modifier_combination_t01_ferocious_aura:IsPurgable()
	return false
end
function modifier_combination_t01_ferocious_aura:IsPurgeException()
	return false
end
function modifier_combination_t01_ferocious_aura:AllowIllusionDuplicate()
	return false
end
function modifier_combination_t01_ferocious_aura:IsAura()
	return self:GetStackCount() == 0 and not self:GetCaster():IsIllusion() and not self:GetCaster():PassivesDisabled()
end
function modifier_combination_t01_ferocious_aura:GetAuraRadius()
	return self.aura_radius
end
function modifier_combination_t01_ferocious_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_combination_t01_ferocious_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end
function modifier_combination_t01_ferocious_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MELEE_ONLY
end
function modifier_combination_t01_ferocious_aura:GetModifierAura()
	return "modifier_combination_t01_ferocious_aura_effect"
end
function modifier_combination_t01_ferocious_aura:OnCreated(params)
	self.aura_radius = self:GetAbilitySpecialValueFor("aura_radius")
	if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(0)
	end
end
function modifier_combination_t01_ferocious_aura:OnRefresh(params)
	self.aura_radius = self:GetAbilitySpecialValueFor("aura_radius")
end
function modifier_combination_t01_ferocious_aura:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) and self:GetAbility():IsActivated() then
			self:SetStackCount(0)
		else
			self:SetStackCount(1)
		end
	end
end
---------------------------------------------------------------------
if modifier_combination_t01_ferocious_aura_effect == nil then
	modifier_combination_t01_ferocious_aura_effect = class({})
end
function modifier_combination_t01_ferocious_aura_effect:IsHidden()
	return false
end
function modifier_combination_t01_ferocious_aura_effect:IsDebuff()
	return false
end
function modifier_combination_t01_ferocious_aura_effect:IsPurgable()
	return false
end
function modifier_combination_t01_ferocious_aura_effect:IsPurgeException()
	return false
end
function modifier_combination_t01_ferocious_aura_effect:AllowIllusionDuplicate()
	return false
end
-- function modifier_combination_t01_ferocious_aura_effect:GetEffectName()
-- 	return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
-- end
-- function modifier_combination_t01_ferocious_aura_effect:GetEffectAttachType()
-- 	return PATTACH_OVERHEAD_FOLLOW
-- end
function modifier_combination_t01_ferocious_aura_effect:OnCreated(params)
	self.trigger_health_percent = self:GetAbilitySpecialValueFor("trigger_health_percent")
	self.bonus_damage_percent = self:GetAbilitySpecialValueFor("bonus_damage_percent")
end
function modifier_combination_t01_ferocious_aura_effect:OnRefresh(params)
	self.trigger_health_percent = self:GetAbilitySpecialValueFor("trigger_health_percent")
	self.bonus_damage_percent = self:GetAbilitySpecialValueFor("bonus_damage_percent")
end
function modifier_combination_t01_ferocious_aura_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_combination_t01_ferocious_aura_effect:GetModifierDamageOutgoing_Percentage(params)
	if IsServer() and params.target ~= nil then
		return math.floor((100 - params.target:GetHealthPercent()) / self.trigger_health_percent) * self.bonus_damage_percent
	end
end