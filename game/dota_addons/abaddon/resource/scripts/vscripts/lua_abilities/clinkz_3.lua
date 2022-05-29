LinkLuaModifier("modifier_clinkz_3", "lua_abilities/clinkz_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_clinkz_3_summon", "lua_abilities/clinkz_3.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if clinkz_3 == nil then
	clinkz_3 = class({})
end
function clinkz_3:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self.BaseClass.GetAbilityTextureName(self), self:GetCaster())
end
function clinkz_3:ScepterSummon(iCount)
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local base_damage_percent = self:GetSpecialValueFor("base_damage_percent")
	local hHero = PlayerResource:GetSelectedHeroEntity(hCaster:GetPlayerOwnerID())

	local vDirection = hCaster:GetForwardVector()

	local iBaseMinDamage = hCaster:GetBaseDamageMin() * base_damage_percent*0.01
	local iBaseMaxDamage = hCaster:GetBaseDamageMax() * base_damage_percent*0.01

	local clinkz_2 = hCaster:FindAbilityByName("clinkz_2")
	local iAbilityLevel = IsValid(clinkz_2) and clinkz_2:GetLevel() or 0

	if self.tArmys == nil then
		self.tArmys = {}
	end

	local clinkz_1 = hCaster:FindAbilityByName("clinkz_1")
	local modifier_clinkz_1_bonus_attackspeed = IsValid(clinkz_1) and hCaster:FindModifierByName("modifier_clinkz_1_bonus_attackspeed") or nil

	for i = 1, iCount, 1 do
		local vPosition = hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(360/iCount*(i-1)))*radius

		local hArmy = CreateUnitByName("npc_dota_clinkz_skeleton_archer", vPosition, false, hHero, hHero, hCaster:GetTeamNumber())
		hArmy:SetBaseDamageMin(iBaseMinDamage)
		hArmy:SetBaseDamageMax(iBaseMaxDamage)

		local army_clinkz_2 = hArmy:FindAbilityByName("clinkz_searing_arrows")
		if army_clinkz_2 then
			army_clinkz_2:SetLevel(iAbilityLevel)
			if iAbilityLevel == 0 then
				hArmy:RemoveModifierByName(army_clinkz_2:GetIntrinsicModifierName() or "")
			else
				if not army_clinkz_2:GetAutoCastState() then
					army_clinkz_2:ToggleAutoCast()
				end
			end
		end
	
		hArmy:SetForwardVector(hCaster:GetForwardVector())
		hArmy:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
	
		hArmy:AddNewModifier(hCaster, self, "modifier_clinkz_3_summon", {duration=duration})
	
		if IsValid(modifier_clinkz_1_bonus_attackspeed) then
			hArmy:AddNewModifier(hCaster, clinkz_1, "modifier_clinkz_1_bonus_attackspeed", {duration=modifier_clinkz_1_bonus_attackspeed:GetRemainingTime()})
		end

		hArmy:FireSummonned(hCaster)
	end
end
function clinkz_3:OnSpellStart()
	local count = self:GetSpecialValueFor("count")
	self:ScepterSummon(count)
end
function clinkz_3:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
function clinkz_3:GetIntrinsicModifierName()
	return "modifier_clinkz_3"
end
function clinkz_3:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_clinkz_3 == nil then
	modifier_clinkz_3 = class({})
end
function modifier_clinkz_3:IsHidden()
	return true
end
function modifier_clinkz_3:IsDebuff()
	return false
end
function modifier_clinkz_3:IsPurgable()
	return false
end
function modifier_clinkz_3:IsPurgeException()
	return false
end
function modifier_clinkz_3:IsStunDebuff()
	return false
end
function modifier_clinkz_3:AllowIllusionDuplicate()
	return false
end
function modifier_clinkz_3:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(AI_TIMER_TICK_TIME)
	end
end
function modifier_clinkz_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_clinkz_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_clinkz_3:OnIntervalThink()
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

		local range = caster:Script_GetAttackRange()
		local teamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
		local typeFilter = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
		local flagFilter = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS
		local order = FIND_CLOSEST
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
if modifier_clinkz_3_summon == nil then
	modifier_clinkz_3_summon = class({})
end
function modifier_clinkz_3_summon:IsHidden()
	return true
end
function modifier_clinkz_3_summon:IsDebuff()
	return false
end
function modifier_clinkz_3_summon:IsPurgable()
	return false
end
function modifier_clinkz_3_summon:IsPurgeException()
	return false
end
function modifier_clinkz_3_summon:IsStunDebuff()
	return false
end
function modifier_clinkz_3_summon:AllowIllusionDuplicate()
	return false
end
function modifier_clinkz_3_summon:GetEffectName()
	return "particles/units/heroes/hero_clinkz/clinkz_burning_army.vpcf"
end
function modifier_clinkz_3_summon:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_clinkz_3_summon:OnCreated(params)
	self.attack_rate = self:GetAbilitySpecialValueFor("attack_rate")
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_burning_army_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iParticleID)

		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_building", nil)

		table.insert(self:GetAbility().tArmys, self:GetParent())
	end
end
function modifier_clinkz_3_summon:OnRefresh(params)
    self.attack_rate = self:GetAbilitySpecialValueFor("attack_rate")
end
function modifier_clinkz_3_summon:OnDestroy()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			ArrayRemove(self:GetAbility().tArmys, self:GetParent())
		end
		self:GetParent():ForceKill(false)
	end
end
function modifier_clinkz_3_summon:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end
function modifier_clinkz_3_summon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_clinkz_3_summon:GetModifierBaseAttackTimeConstant(params)
	return self.attack_rate
end
function modifier_clinkz_3_summon:GetModifierAttackRangeOverride(params)
	if IsValid(self:GetCaster()) then
		if IsServer() then
			return self:GetCaster():Script_GetAttackRange()
		else
			return self:GetCaster():GetAttackRange()
		end
	end
end
function modifier_clinkz_3_summon:GetModifierModelChange(params)
	return AssetModifiers:GetModelReplacement("models/heroes/clinkz/clinkz_archer.vmdl", self:GetCaster())
end
function modifier_clinkz_3_summon:GetUnitLifetimeFraction()
	return (self:GetDieTime()-GameRules:GetGameTime())/self:GetDuration()
end