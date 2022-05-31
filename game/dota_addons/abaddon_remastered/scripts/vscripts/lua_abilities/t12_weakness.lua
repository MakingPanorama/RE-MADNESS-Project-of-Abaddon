LinkLuaModifier("modifier_t12_weakness", "lua_abilities/t12_weakness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_t12_weakness_effect", "lua_abilities/t12_weakness.lua", LUA_MODIFIER_MOTION_NONE)
--作祟
--Abilities
if t12_weakness == nil then
	t12_weakness = class({})
end
function t12_weakness:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius", )
end
function t12_weakness:GetIntrinsicModifierName()
	return "modifier_t12_weakness"
end
function t12_weakness:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_t12_weakness == nil then
	modifier_t12_weakness = class({})
end
function modifier_t12_weakness:IsHidden()
	return true
end
function modifier_t12_weakness:IsDebuff()
	return false
end
function modifier_t12_weakness:IsPurgable()
	return false
end
function modifier_t12_weakness:IsPurgeException()
	return false
end
function modifier_t12_weakness:IsStunDebuff()
	return false
end
function modifier_t12_weakness:AllowIllusionDuplicate()
	return false
end
function modifier_t12_weakness:IsAura()
	return not self:GetCaster():IsIllusion() and not self:GetCaster():PassivesDisabled()
end
function modifier_t12_weakness:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_t12_weakness:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end
function modifier_t12_weakness:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end
function modifier_t12_weakness:GetAuraRadius()
	return self.radius 
end
function modifier_t12_weakness:GetModifierAura()
	return "modifier_t12_weakness_effect"
end
function modifier_t12_weakness:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius", )
end
function modifier_t12_weakness:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius", )
end
-------------------------------------------------------------------
-- Modifiers
if modifier_t12_weakness_effect == nil then
	modifier_t12_weakness_effect = class({})
end
function modifier_t12_weakness_effect:IsHidden()
	return false
end
function modifier_t12_weakness_effect:IsDebuff()
	return true
end
function modifier_t12_weakness_effect:IsPurgable()
	return false
end
function modifier_t12_weakness_effect:IsPurgeException()
	return false
end
function modifier_t12_weakness_effect:IsStunDebuff()
	return false
end
function modifier_t12_weakness_effect:AllowIllusionDuplicate()
	return false
end
function modifier_t12_weakness_effect:OnCreated(params)
	self.status_resisitance = self:GetAbilitySpecialValueFor("status_resisitance", )
	self.key = SetStatusResistance(self:GetParent(), self.status_resisitance*0.01, self.key)
end
function modifier_t12_weakness_effect:OnRefresh(params)
	self.status_resisitance = self:GetAbilitySpecialValueFor("status_resisitance", )
	self.key = SetStatusResistance(self:GetParent(), self.status_resisitance*0.01, self.key)
end
function modifier_t12_weakness_effect:OnDestroy()
	self.key = SetStatusResistance(self:GetParent(), nil, self.key)
end