LinkLuaModifier("modifier_medusa_1", "lua_abilities/medusa_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if medusa_1 == nil then
	medusa_1 = class({})
end
function medusa_1:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self.BaseClass.GetAbilityTextureName(self), self:GetCaster())
end
function medusa_1:GetCastRange(vLocation, hTarget)
	if self:GetCaster() ~= nil then
		return self:GetCaster():Script_GetAttackRange()+self:GetCaster():GetHullRadius()+self:GetSpecialValueFor("split_shot_bonus_range")
	end
end
function medusa_1:GetIntrinsicModifierName()
	return "modifier_medusa_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_medusa_1 == nil then
	modifier_medusa_1 = class({})
end
function modifier_medusa_1:IsHidden()
	return true
end
function modifier_medusa_1:IsDebuff()
	return false
end
function modifier_medusa_1:IsPurgable()
	return false
end
function modifier_medusa_1:IsPurgeException()
	return false
end
function modifier_medusa_1:IsStunDebuff()
	return false
end
function modifier_medusa_1:AllowIllusionDuplicate()
	return false
end
function modifier_medusa_1:OnCreated(params)
	self.bonus_attack_damage = self:GetAbilitySpecialValueFor("bonus_attack_damage")
	self.arrow_count = self:GetAbilitySpecialValueFor("arrow_count")
	self.split_shot_bonus_range = self:GetAbilitySpecialValueFor("split_shot_bonus_range")
	if IsServer() then
		self.triggering = false
		
		local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_medusa/medusa_bow_split_shot.vpcf", self:GetParent()), PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_bow_top", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_bow_mid", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_bow_bottom", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_medusa_1:OnRefresh(params)
	self.bonus_attack_damage = self:GetAbilitySpecialValueFor("bonus_attack_damage")
	self.arrow_count = self:GetAbilitySpecialValueFor("arrow_count")
	self.split_shot_bonus_range = self:GetAbilitySpecialValueFor("split_shot_bonus_range")
end
function modifier_medusa_1:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_medusa_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		-- MODIFIER_EVENT_ON_ATTACK,
	}
end
function modifier_medusa_1:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_attack_damage
end
function modifier_medusa_1:GetActivityTranslationModifiers(params)
	return "split_shot"
end
function modifier_medusa_1:GetAttackSound(params)
	return AssetModifiers:GetSoundReplacement("Hero_Medusa.AttackSplit", self:GetParent())
end
function modifier_medusa_1:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end

	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		if not self.triggering then
			self.triggering = true
			local count = 0
			local targets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, params.attacker:Script_GetAttackRange()+params.attacker:GetHullRadius()+self.split_shot_bonus_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
			for n, target in pairs(targets) do
				if target ~= params.target then
					count = count + 1

					params.attacker:Attack(target, ATTACK_STATE_NOT_USECASTATTACKORB+ATTACK_STATE_NOT_PROCESSPROCS+ATTACK_STATE_SKIPCOOLDOWN+ATTACK_STATE_IGNOREINVIS+ATTACK_STATE_NO_CLEAVE+ATTACK_STATE_NO_EXTENDATTACK+ATTACK_STATE_SKIPCOUNTING)

					if count >= self.arrow_count then
						break
					end
				end
			end
			self.triggering = false
		end
	end
end