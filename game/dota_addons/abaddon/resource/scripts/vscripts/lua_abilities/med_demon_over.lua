LinkLuaModifier("modifier_med_demon_over", "lua_abilities/med_demon_over.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_med_demon_over_bonus_attackspeed", "lua_abilities/med_demon_over.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if med_demon_over == nil then
	med_demon_over = class({})
end
function med_demon_over:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self.BaseClass.GetAbilityTextureName(self), self:GetCaster())
end
function med_demon_over:GetIntrinsicModifierName()
	return "modifier_med_demon_over"
end
function med_demon_over:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_med_demon_over == nil then
	modifier_med_demon_over = class({})
end
function modifier_med_demon_over:IsHidden()
	return true
end
function modifier_med_demon_over:IsDebuff()
	return false
end
function modifier_med_demon_over:IsPurgable()
	return false
end
function modifier_med_demon_over:IsPurgeException()
	return false
end
function modifier_med_demon_over:IsStunDebuff()
	return false
end
function modifier_med_demon_over:AllowIllusionDuplicate()
	return false
end
function modifier_med_demon_over:OnCreated(params)
    self.duration = self:GetAbilitySpecialValueFor("duration")
    self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_med_demon_over:OnRefresh(params)
    self.duration = self:GetAbilitySpecialValueFor("duration")
    self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_med_demon_over:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_med_demon_over:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_med_demon_over:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

	local attacker = params.attacker
	if attacker ~= nil and attacker == self:GetParent() and not attacker:PassivesDisabled() then
		if not attacker:HasModifier("modifier_med_demon_over_bonus_attackspeed") or attacker:HasScepter() then
			if PRD(attacker, self.chance, "med_demon_over") then
				attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_med_demon_over_bonus_attackspeed", {duration=self.duration})
				attacker:EmitSound(AssetModifiers:GetSoundReplacement("Hero_Ursa.Overpower", attacker))
				attacker:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_med_demon_over_bonus_attackspeed == nil then
	modifier_med_demon_over_bonus_attackspeed = class({})
end
function modifier_med_demon_over_bonus_attackspeed:IsHidden()
	return false
end
function modifier_med_demon_over_bonus_attackspeed:IsDebuff()
	return false
end
function modifier_med_demon_over_bonus_attackspeed:IsPurgable()
	return false
end
function modifier_med_demon_over_bonus_attackspeed:IsPurgeException()
	return false
end
function modifier_med_demon_over_bonus_attackspeed:IsStunDebuff()
	return false
end
function modifier_med_demon_over_bonus_attackspeed:AllowIllusionDuplicate()
	return false
end
function modifier_med_demon_over_bonus_attackspeed:GetStatusEffectName()
	return AssetModifiers:GetParticleReplacement("particles/status_fx/status_effect_overpower.vpcf", self:GetParent())
end
function modifier_med_demon_over_bonus_attackspeed:OnCreated(params)
    self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
    if IsServer() then
        local caster = self:GetParent()
        local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf", caster), PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(particleID, 0, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particleID, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		self:AddParticle(particleID, false, false, -1, false, false)
	end
end
function modifier_med_demon_over_bonus_attackspeed:OnRefresh(params)
    self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
	end
end
function modifier_med_demon_over_bonus_attackspeed:OnDestroy()
	if IsServer() then
	end
end
function modifier_med_demon_over_bonus_attackspeed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_med_demon_over_bonus_attackspeed:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackspeed
end