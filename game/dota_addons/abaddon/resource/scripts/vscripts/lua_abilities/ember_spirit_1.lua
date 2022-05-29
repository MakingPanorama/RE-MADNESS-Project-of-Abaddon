LinkLuaModifier("modifier_ember_spirit_1", "lua_abilities/ember_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_1_debuff", "lua_abilities/ember_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if ember_spirit_1 == nil then
	ember_spirit_1 = class({})
end
function ember_spirit_1:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self.BaseClass.GetAbilityTextureName(self), self:GetCaster())
end
function ember_spirit_1:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local unit_count = self:GetSpecialValueFor("unit_count")
	local duration = self:GetSpecialValueFor("duration")

	local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", caster), PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(particleID)

	caster:EmitSound(AssetModifiers:GetSoundReplacement("Hero_EmberSpirit.SearingChains.Cast", caster))

	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	local n = 0
	for _, target in pairs(targets) do
		target:AddNewModifier(caster, self, "modifier_ember_spirit_1_debuff", {duration=duration*target:GetStatusResistanceFactor()})

		local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", caster), PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particleID, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particleID, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particleID)

		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), AssetModifiers:GetSoundReplacement("Hero_EmberSpirit.SearingChains.Target", caster), caster)

		n = n + 1
		if n >= unit_count then
			break
		end
	end
end
function ember_spirit_1:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
function ember_spirit_1:GetIntrinsicModifierName()
	return "modifier_ember_spirit_1"
end
function ember_spirit_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_ember_spirit_1 == nil then
	modifier_ember_spirit_1 = class({})
end
function modifier_ember_spirit_1:IsHidden()
	return true
end
function modifier_ember_spirit_1:IsDebuff()
	return false
end
function modifier_ember_spirit_1:IsPurgable()
	return false
end
function modifier_ember_spirit_1:IsPurgeException()
	return false
end
function modifier_ember_spirit_1:IsStunDebuff()
	return false
end
function modifier_ember_spirit_1:AllowIllusionDuplicate()
	return false
end
function modifier_ember_spirit_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(AI_TIMER_TICK_TIME)
	end
end
function modifier_ember_spirit_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_ember_spirit_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_ember_spirit_1:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		if not IsValid(ability) then
			self:StartIntervalThink(-1)
			self:Destroy()
			return
		end

		local caster = ability:GetCaster()

		if not ability:GetAutoCastState() then
			return
		end

		if caster:IsTempestDouble() or caster:IsIllusion() then
			self:StartIntervalThink(-1)
			return
		end

		local range = ability:GetSpecialValueFor("radius")
		local teamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
		local typeFilter = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
		local flagFilter = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS
		local order = FIND_ANY_ORDER
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, teamFilter, typeFilter, flagFilter, order, false)
		if targets[1] ~= nil and caster:IsAbilityReady(ability) then
			ExecuteOrderFromTable({
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = ability:entindex(),
			})
		end
	end
end
---------------------------------------------------------------------
if modifier_ember_spirit_1_debuff == nil then
	modifier_ember_spirit_1_debuff = class({})
end
function modifier_ember_spirit_1_debuff:IsHidden()
	return false
end
function modifier_ember_spirit_1_debuff:IsDebuff()
	return true
end
function modifier_ember_spirit_1_debuff:IsPurgable()
	return true
end
function modifier_ember_spirit_1_debuff:IsPurgeException()
	return true
end
function modifier_ember_spirit_1_debuff:IsStunDebuff()
	return false
end
function modifier_ember_spirit_1_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_ember_spirit_1_debuff:GetEffectName()
	return AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf", self:GetCaster())
end
function modifier_ember_spirit_1_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_ember_spirit_1_debuff:OnCreated(params)
	self.total_damage = self:GetAbilitySpecialValueFor("total_damage")
	self.tick_interval = self:GetAbilitySpecialValueFor("tick_interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self.damage_type = self:GetAbility():GetAbilityDamageType()

		self.damage = (self.total_damage/(self.duration/self.tick_interval))*self:GetParent():GetStatusResistanceFactor()

		self:StartIntervalThink(self.tick_interval*self:GetParent():GetStatusResistanceFactor())

		self.modifier_truesight = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_truesight", {duration=self:GetDuration()})
	end
end
function modifier_ember_spirit_1_debuff:OnRefresh(params)
	self.total_damage = self:GetAbilitySpecialValueFor("total_damage")
	self.tick_interval = self:GetAbilitySpecialValueFor("tick_interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self.damage_type = self:GetAbility():GetAbilityDamageType()

		self.damage = (self.total_damage/(self.duration/self.tick_interval))*self:GetParent():GetStatusResistanceFactor()
	end
end
function modifier_ember_spirit_1_debuff:OnDestroy()
	if IsServer() then
		if IsValid(self.modifier_truesight) then
			self.modifier_truesight:Destroy()
		end
	end
end
function modifier_ember_spirit_1_debuff:OnIntervalThink()
	if IsServer() then
		local damage_table = {
			ability = self:GetAbility(),
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self.damage_type,
		}
		ApplyDamage(damage_table)
	end
end
function modifier_ember_spirit_1_debuff:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end