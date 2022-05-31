LinkLuaModifier("modifier_medusa_2", "abilities/sr/medusa/medusa_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_medusa_2_buff", "abilities/sr/medusa/medusa_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if medusa_2 == nil then
	medusa_2 = class({})
end
function medusa_2:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self.BaseClass.GetAbilityTextureName(self), self:GetCaster())
end
function medusa_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local radius = self:GetSpecialValueFor("radius")
	local snake_jumps = self:GetSpecialValueFor("snake_jumps")
	local snake_damage = self:GetSpecialValueFor("snake_damage")
	local snake_damage_scale = self:GetSpecialValueFor("snake_damage_scale")
	local initial_speed = self:GetSpecialValueFor("initial_speed")
	local tHashtable = CreateHashtable()

	hCaster:EmitSound(AssetModifiers:GetSoundReplacement("Hero_Medusa.MysticSnake.Cast", hCaster))

	tHashtable.radius = radius
	tHashtable.damage = snake_damage
	tHashtable.damage_scale = snake_damage_scale
	tHashtable.max_count = snake_jumps
	tHashtable.count = 0
	tHashtable.targets = {}

	local tInfo =
	{
		Ability = self,
		EffectName = AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_initial.vpcf", hCaster),
		iSourceAttachment = hCaster:ScriptLookupAttachment("attach_attack2"),
		iMoveSpeed = initial_speed,
		Target = hTarget,
		Source = hCaster,
		ExtraData = {
			hashtable_index = GetHashtableIndex(tHashtable),
		}
	}
	ProjectileManager:CreateTrackingProjectile(tInfo)
end
function medusa_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	local tHashtable = GetHashtableByIndex(ExtraData.hashtable_index or -1)
	local bHasScepter = hCaster:HasScepter()

	if hTarget ~= nil then
		if hTarget == hCaster then
			local snake_agility_duration = self:GetSpecialValueFor("snake_agility_duration")

			if ExtraData.count > 0 then
				hCaster:AddNewModifier(hCaster, self, "modifier_medusa_2_buff", {duration=snake_agility_duration, target_count=ExtraData.count})
			end

			hCaster:EmitSound(AssetModifiers:GetSoundReplacement("Hero_Medusa.MysticSnake.Return", hCaster))

			return true
		else
			if tHashtable == nil then return end

			if bHasScepter then
				local stone_form_scepter = self:GetSpecialValueFor("stone_form_scepter")
				local medusa_3 = hCaster:FindAbilityByName("medusa_3")
				if IsValid(medusa_3) and medusa_3:GetLevel() > 0 then
					hTarget:AddNewModifier(hCaster, medusa_3, "modifier_medusa_3_debuff", {duration=stone_form_scepter*hTarget:GetStatusResistanceFactor()})
				end
			end

			local fDamage = tHashtable.damage * math.pow(1+tHashtable.damage_scale*0.01, tHashtable.count)

			local tDamageTable =
			{
				ability = self,
				attacker = hCaster,
				victim = hTarget,
				damage = fDamage,
				damage_type = self:GetAbilityDamageType()
			}
			ApplyDamage(tDamageTable)

			EmitSoundOnLocationWithCaster(vLocation, AssetModifiers:GetSoundReplacement("Hero_Medusa.MysticSnake.Target", hCaster), hCaster)

			tHashtable.count = tHashtable.count + 1
			table.insert(tHashtable.targets, hTarget)
		end
	end

	if tHashtable.max_count > tHashtable.count then
		local hNewTarget = GetBounceTarget(hTarget, hCaster:GetTeamNumber(), vLocation, tHashtable.radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags()+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, tHashtable.targets, false)
		if hNewTarget ~= nil then
			local initial_speed = self:GetSpecialValueFor("initial_speed")

			local tInfo =
			{
				Source = hTarget,
				Ability = self,
				EffectName = AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf", hCaster),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				vSourceLoc = vLocation,
				iMoveSpeed = initial_speed,
				Target = hNewTarget,
				ExtraData = {
					hashtable_index = GetHashtableIndex(tHashtable),
				},
			}
			ProjectileManager:CreateTrackingProjectile(tInfo)

			return true
		end
	end

	if IsValid(hCaster) then
		local return_speed = self:GetSpecialValueFor("return_speed")
		local tInfo =
		{
			Source = hTarget,
			Ability = self,
			EffectName = AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf", hCaster),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			vSourceLoc = vLocation,
			iMoveSpeed = return_speed,
			Target = hCaster,
			ExtraData = {
				count = tHashtable.count,
			},
		}
		ProjectileManager:CreateTrackingProjectile(tInfo)
	end

	RemoveHashtable(tHashtable)

	return true
end
function medusa_2:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
function medusa_2:GetIntrinsicModifierName()
	return "modifier_medusa_2"
end
function medusa_2:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_medusa_2 == nil then
	modifier_medusa_2 = class({})
end
function modifier_medusa_2:IsHidden()
	return true
end
function modifier_medusa_2:IsDebuff()
	return false
end
function modifier_medusa_2:IsPurgable()
	return false
end
function modifier_medusa_2:IsPurgeException()
	return false
end
function modifier_medusa_2:IsStunDebuff()
	return false
end
function modifier_medusa_2:AllowIllusionDuplicate()
	return false
end
function modifier_medusa_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(AI_TIMER_TICK_TIME)
	end
end
function modifier_medusa_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_medusa_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_medusa_2:OnIntervalThink()
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

		local range = ability:GetCastRange(caster:GetAbsOrigin(), caster)

		-- 优先攻击目标
		local target = caster:GetAttackTarget()
		if target ~= nil and target:GetClassname() == "dota_item_drop" then target = nil end
		if target ~= nil and not target:IsPositionInRange(caster:GetAbsOrigin(), range) then
			target = nil
		end

		-- 搜索范围
		if target == nil then
			local teamFilter = ability:GetAbilityTargetTeam()
			local typeFilter = ability:GetAbilityTargetType()
			local flagFilter = ability:GetAbilityTargetFlags()+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS
			local order = FIND_CLOSEST
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, teamFilter, typeFilter, flagFilter, order, false)
			target = targets[1]
		end

		-- 施法命令
		if target ~= nil and caster:IsAbilityReady(ability) then
			ExecuteOrderFromTable({
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = target:entindex(),
				AbilityIndex = ability:entindex(),
			})
		end
	end
end
---------------------------------------------------------------------
if modifier_medusa_2_buff == nil then
	modifier_medusa_2_buff = class({})
end
function modifier_medusa_2_buff:IsHidden()
	return false
end
function modifier_medusa_2_buff:IsDebuff()
	return false
end
function modifier_medusa_2_buff:IsPurgable()
	return false
end
function modifier_medusa_2_buff:IsPurgeException()
	return false
end
function modifier_medusa_2_buff:IsStunDebuff()
	return false
end
function modifier_medusa_2_buff:AllowIllusionDuplicate()
	return false
end
function modifier_medusa_2_buff:OnCreated(params)
	self.snake_agility_gain = self:GetAbilitySpecialValueFor("snake_agility_gain")
	if IsServer() then
		self.tDatas = {}

		local hParent = self:GetParent()

		local iTargetCount = params.target_count or 0

		local iValue = self.snake_agility_gain * iTargetCount

		hParent:ModifyAgility(iValue)
		table.insert(self.tDatas, {
			iGain = iValue,
			fDieTime = self:GetDieTime()
		})
		self:SetStackCount(self:GetStackCount()+iValue)

		self:StartIntervalThink(0)
	end
end
function modifier_medusa_2_buff:OnRefresh(params)
	self.snake_agility_gain = self:GetAbilitySpecialValueFor("snake_agility_gain")
	if IsServer() then
		local hParent = self:GetParent()

		local iTargetCount = params.target_count or 0

		local iValue = self.snake_agility_gain * iTargetCount

		hParent:ModifyAgility(iValue)
		table.insert(self.tDatas, {
			iGain = iValue,
			fDieTime = self:GetDieTime()
		})
		self:SetStackCount(self:GetStackCount()+iValue)
	end
end
function modifier_medusa_2_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()

		for i = #self.tDatas, 1, -1 do
			hParent:ModifyAgility(-self.tDatas[i].iGain)
			self:SetStackCount(self:GetStackCount()-self.tDatas[i].iGain)

			table.remove(self.tDatas, i)
		end
	end
end
function modifier_medusa_2_buff:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tDatas, 1, -1 do
			if fGameTime >= self.tDatas[i].fDieTime then
				hParent:ModifyAgility(-self.tDatas[i].iGain)
				self:SetStackCount(self:GetStackCount()-self.tDatas[i].iGain)

				table.remove(self.tDatas, i)
			end
		end
	end
end
function modifier_medusa_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_medusa_2_buff:OnTooltip(params)
	return self:GetStackCount()
end