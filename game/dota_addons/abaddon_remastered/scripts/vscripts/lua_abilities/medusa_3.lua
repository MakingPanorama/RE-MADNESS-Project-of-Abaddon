LinkLuaModifier("modifier_medusa_3", "lua_abilities/medusa_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_medusa_3_debuff", "lua_abilities/medusa_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if medusa_3 == nil then
	medusa_3 = class({})
end
function medusa_3:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self.BaseClass.GetAbilityTextureName(self), self:GetCaster())
end
function medusa_3:GetIntrinsicModifierName()
	return "modifier_medusa_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_medusa_3 == nil then
	modifier_medusa_3 = class({})
end
function modifier_medusa_3:IsHidden()
	return true
end
function modifier_medusa_3:IsDebuff()
	return false
end
function modifier_medusa_3:IsPurgable()
	return false
end
function modifier_medusa_3:IsPurgeException()
	return false
end
function modifier_medusa_3:IsStunDebuff()
	return false
end
function modifier_medusa_3:AllowIllusionDuplicate()
	return false
end
function modifier_medusa_3:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
end
function modifier_medusa_3:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_medusa_3:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
end
function modifier_medusa_3:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_medusa_3:OnTakeDamage(params)
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() and UnitFilter(params.unit, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then
		if PRD(params.attacker, self.chance, "medusa_3") then
			params.unit:AddNewModifier(params.attacker, self:GetAbility(), "modifier_medusa_3_debuff", {duration=self.duration*params.unit:GetStatusResistanceFactor()})

			-- EmitSoundOnLocationWithCaster(params.unit:GetAbsOrigin(), "Hero_Medusa.StoneGaze.Stun", params.attacker)
		end
	end
end
---------------------------------------------------------------------
if modifier_medusa_3_debuff == nil then
	modifier_medusa_3_debuff = class({})
end
function modifier_medusa_3_debuff:IsHidden()
	return false
end
function modifier_medusa_3_debuff:IsDebuff()
	return true
end
function modifier_medusa_3_debuff:IsPurgable()
	return false
end
function modifier_medusa_3_debuff:IsPurgeException()
	return true
end
function modifier_medusa_3_debuff:IsStunDebuff()
	return true
end
function modifier_medusa_3_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_medusa_3_debuff:GetStatusEffectName()
	return AssetModifiers:GetParticleReplacement("particles/status_fx/status_effect_medusa_stone_gaze.vpcf", self:GetParent())
end
function modifier_medusa_3_debuff:StatusEffectPriority()
	return 10
end
function modifier_medusa_3_debuff:OnCreated(params)
	self.bonus_physical_damage = self:GetAbilitySpecialValueFor("bonus_physical_damage")
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", self:GetParent()), PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetCaster(), PATTACH_CUSTOMORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_medusa_3_debuff:OnRefresh(params)
	self.bonus_physical_damage = self:GetAbilitySpecialValueFor("bonus_physical_damage")
end
function modifier_medusa_3_debuff:OnDestroy()
end
function modifier_medusa_3_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end
function modifier_medusa_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}
end
function modifier_medusa_3_debuff:GetModifierIncomingPhysicalDamage_Percentage(params)
	return self.bonus_physical_damage
end