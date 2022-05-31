LinkLuaModifier("modifier_juggernaut_3", "lua_abilities/juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_3_thinker", "lua_abilities/juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_3_delay_remove", "lua_abilities/juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_3_ignore_armor", "lua_abilities/juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if juggernaut_3 == nil then
	juggernaut_3 = class({})
end
function juggernaut_3:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self.BaseClass.GetAbilityTextureName(self), self:GetCaster())
end
function juggernaut_3:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local dummy = CreateUnitByName("npc_dota_dummy", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())

	dummy:SetOriginalModel(caster:GetModelName())
	dummy:SetModelScale(caster:GetModelScale())
	dummy:SetHullRadius(caster:GetHullRadius())

	local model = caster:FirstMoveChild()
	while model ~= nil do
		if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" and model:GetModelName() ~= "" then
			local wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model:GetModelName(), origin = dummy:GetAbsOrigin()})
			wearable:FollowEntity(dummy, true)
		end
		model = model:NextMovePeer()
	end

	dummy:AddNewModifier(caster, self, "modifier_juggernaut_3_thinker", {target_entindex=target:entindex()})
end
function juggernaut_3:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
function juggernaut_3:GetIntrinsicModifierName()
	return "modifier_juggernaut_3"
end
function juggernaut_3:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_3 == nil then
	modifier_juggernaut_3 = class({})
end
function modifier_juggernaut_3:IsHidden()
	return true
end
function modifier_juggernaut_3:IsDebuff()
	return false
end
function modifier_juggernaut_3:IsPurgable()
	return false
end
function modifier_juggernaut_3:IsPurgeException()
	return false
end
function modifier_juggernaut_3:IsStunDebuff()
	return false
end
function modifier_juggernaut_3:AllowIllusionDuplicate()
	return false
end
function modifier_juggernaut_3:OnCreated(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.scepter_damage_pct = self:GetAbilitySpecialValueFor("scepter_damage_pct")
	if IsServer() then
		self:StartIntervalThink(AI_TIMER_TICK_TIME)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_juggernaut_3:OnRefresh(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.scepter_damage_pct = self:GetAbilitySpecialValueFor("scepter_damage_pct")
	if IsServer() then
	end
end
function modifier_juggernaut_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_juggernaut_3:OnIntervalThink()
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
			local flagFilter = ability:GetAbilityTargetFlags()+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS
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
function modifier_juggernaut_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_juggernaut_3:GetModifierPreAttack_BonusDamage(params)
	if IsServer() then
		local caster = self:GetParent()
		local ability = self:GetAbility()
		if ability.hitting then
			return self.bonus_damage
		end
	end
end
function modifier_juggernaut_3:GetModifierDamageOutgoing_Percentage(params)
	if IsServer() then
		local caster = self:GetParent()
		local ability = self:GetAbility()
		if ability.hitting and caster:HasScepter() then
			return self.scepter_damage_pct - 100
		end
	end
end
function modifier_juggernaut_3:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() then
		local caster = self:GetParent()
		local ability = self:GetAbility()
		if ability.hitting and caster:HasScepter() then
			params.target:AddNewModifier(caster, self:GetAbility(), "modifier_juggernaut_3_ignore_armor", {duration=1/30})
		end
	end
end
---------------------------------------------------------------------
if modifier_juggernaut_3_thinker == nil then
	modifier_juggernaut_3_thinker = class({})
end
function modifier_juggernaut_3_thinker:IsHidden()
	return false
end
function modifier_juggernaut_3_thinker:IsDebuff()
	return false
end
function modifier_juggernaut_3_thinker:IsPurgable()
	return false
end
function modifier_juggernaut_3_thinker:IsPurgeException()
	return false
end
function modifier_juggernaut_3_thinker:IsStunDebuff()
	return false
end
function modifier_juggernaut_3_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_juggernaut_3_thinker:GetEffectName()
	return AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_omnislash_light.vpcf", self:GetCaster())
end
function modifier_juggernaut_3_thinker:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_juggernaut_3_thinker:GetStatusEffectName()
	return AssetModifiers:GetParticleReplacement("particles/status_fx/status_effect_omnislash.vpcf", self:GetCaster())
end
function modifier_juggernaut_3_thinker:StatusEffectPriority()
	return 100
end
function modifier_juggernaut_3_thinker:OnCreated(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.omni_slash_radius = self:GetAbilitySpecialValueFor("omni_slash_radius")
	self.jump_count = self:GetAbilitySpecialValueFor("jump_count")
	self.jump_delay = self:GetAbilitySpecialValueFor("jump_delay")
	self.scepter_aoe_radius = self:GetAbilitySpecialValueFor("scepter_aoe_radius")
	if IsServer() then
		local caster = self:GetCaster()
		local dummy = self:GetParent()

		local target = EntIndexToHScript(params.target_entindex)

		local vDirection = target:GetAbsOrigin() - dummy:GetAbsOrigin()
		vDirection.z = 0
		local position = target:GetAbsOrigin()+vDirection:Normalized()*(dummy:GetHullRadius()+target:GetHullRadius())

		local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_omni_dash.vpcf", caster), PATTACH_CUSTOMORIGIN, dummy)
		ParticleManager:SetParticleControl(particleID, 0, dummy:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(particleID, 0, -vDirection:Normalized())
		ParticleManager:SetParticleControlEnt(particleID, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particleID, 2, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particleID)

		EmitSoundOnLocationWithCaster(dummy:GetAbsOrigin(), AssetModifiers:GetSoundReplacement("Hero_Juggernaut.OmniSlash", caster), caster)

		AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 300, self.jump_delay, false)

		local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", caster), PATTACH_CUSTOMORIGIN, dummy)
		ParticleManager:SetParticleControl(particleID, 0, dummy:GetAbsOrigin())

		FindClearSpaceForUnit(dummy, position, true)

		ParticleManager:SetParticleControl(particleID, 1, dummy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particleID)

		dummy:SetForwardVector(-vDirection:Normalized())
		dummy:FaceTowards(target:GetAbsOrigin())

		local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", caster), PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(particleID, 0, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particleID, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particleID)

		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), AssetModifiers:GetSoundReplacement("Hero_Juggernaut.OmniSlash.Damage", caster), caster)

		self:HitTarget(target)

		self:StartIntervalThink(self.jump_delay)

		self.count = 1
	end
end
function modifier_juggernaut_3_thinker:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local dummy = self:GetParent()

		if not IsValid(ability) or not IsValid(caster) then
			self:Destroy()
			self:GetParent():RemoveSelf()
			return
		end

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, self.omni_slash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)
		local target = targets[1]
		if target ~= nil then
			local vDirection = target:GetAbsOrigin() - dummy:GetAbsOrigin()
			vDirection.z = 0
			local position = target:GetAbsOrigin()+vDirection:Normalized()*(dummy:GetHullRadius()+target:GetHullRadius())

			EmitSoundOnLocationWithCaster(dummy:GetAbsOrigin(), AssetModifiers:GetSoundReplacement("Hero_Juggernaut.OmniSlash", caster), caster)

			AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 300, self.jump_delay, false)

			local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", caster), PATTACH_CUSTOMORIGIN, dummy)
			ParticleManager:SetParticleControl(particleID, 0, dummy:GetAbsOrigin())

			FindClearSpaceForUnit(dummy, position, true)

			ParticleManager:SetParticleControl(particleID, 1, dummy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particleID)

			dummy:SetForwardVector(-vDirection:Normalized())
			dummy:FaceTowards(target:GetAbsOrigin())

			local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", caster), PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(particleID, 0, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particleID, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particleID)

			EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), AssetModifiers:GetParticleReplacement("Hero_Juggernaut.OmniSlash.Damage", caster), caster)

			self:HitTarget(target)

			self:StartIntervalThink(self.jump_delay)

			self.count = self.count + 1
			if self.count >= self.jump_count then
				self:Destroy()

				dummy:AddNewModifier(caster, ability, "modifier_juggernaut_3_delay_remove", {duration=0.5})
			end
		else
			local particleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_omni_end.vpcf", caster), PATTACH_CUSTOMORIGIN_FOLLOW, dummy)
			ParticleManager:SetParticleControlEnt(particleID, 1, dummy, PATTACH_CUSTOMORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particleID, 2, dummy, PATTACH_CUSTOMORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particleID, 3, dummy, PATTACH_CUSTOMORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particleID)

			dummy:AddNewModifier(caster, ability, "modifier_juggernaut_3_delay_remove", {duration=1.5})

			self:Destroy()
		end
	end
end
function modifier_juggernaut_3_thinker:HitTarget(target)
	if IsServer() then
		local ability = self:GetAbility()
		if not IsValid(ability) then return end
		ability.hitting = true

		local caster = self:GetCaster()

		local position = caster:GetAbsOrigin()

		if caster:HasScepter() then
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self.scepter_aoe_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
			for n, _target in pairs(targets) do
				local vDirection = _target:GetAbsOrigin() - position
				vDirection.z = 0
				caster:SetAbsOrigin(_target:GetAbsOrigin()-vDirection:Normalized())
				caster:Attack(_target, ATTACK_STATE_SKIPCOOLDOWN+ATTACK_STATE_IGNOREINVIS+ATTACK_STATE_NOT_USEPROJECTILE+ATTACK_STATE_NEVERMISS+ATTACK_STATE_NO_CLEAVE+ATTACK_STATE_NO_EXTENDATTACK+ATTACK_STATE_SKIPCOUNTING)
			end
		else
			local vDirection = target:GetAbsOrigin() - position
			vDirection.z = 0
			caster:SetAbsOrigin(target:GetAbsOrigin()-vDirection:Normalized())
			caster:Attack(target, ATTACK_STATE_NOT_USECASTATTACKORB+ATTACK_STATE_NOT_PROCESSPROCS+ATTACK_STATE_SKIPCOOLDOWN+ATTACK_STATE_IGNOREINVIS+ATTACK_STATE_NOT_USEPROJECTILE+ATTACK_STATE_NEVERMISS+ATTACK_STATE_NO_CLEAVE+ATTACK_STATE_NO_EXTENDATTACK+ATTACK_STATE_SKIPCOUNTING)
		end

		caster:SetAbsOrigin(position)

		ability.hitting = false
	end
end
function modifier_juggernaut_3_thinker:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
function modifier_juggernaut_3_thinker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	}
end
function modifier_juggernaut_3_thinker:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_damage
end
function modifier_juggernaut_3_thinker:GetOverrideAnimation(params)
	return ACT_DOTA_OVERRIDE_ABILITY_4
end
function modifier_juggernaut_3_thinker:GetModifierIgnoreCastAngle(params)
	return 1
end
---------------------------------------------------------------------
if modifier_juggernaut_3_delay_remove == nil then
	modifier_juggernaut_3_delay_remove = class({})
end
function modifier_juggernaut_3_delay_remove:IsHidden()
	return true
end
function modifier_juggernaut_3_delay_remove:IsDebuff()
	return false
end
function modifier_juggernaut_3_delay_remove:IsPurgable()
	return false
end
function modifier_juggernaut_3_delay_remove:IsPurgeException()
	return false
end
function modifier_juggernaut_3_delay_remove:IsStunDebuff()
	return false
end
function modifier_juggernaut_3_delay_remove:AllowIllusionDuplicate()
	return false
end
function modifier_juggernaut_3_delay_remove:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveSelf()
	end
end
function modifier_juggernaut_3_delay_remove:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
---------------------------------------------------------------------
if modifier_juggernaut_3_ignore_armor == nil then
	modifier_juggernaut_3_ignore_armor = class({})
end
function modifier_juggernaut_3_ignore_armor:IsHidden()
	return true
end
function modifier_juggernaut_3_ignore_armor:IsDebuff()
	return true
end
function modifier_juggernaut_3_ignore_armor:IsPurgable()
	return false
end
function modifier_juggernaut_3_ignore_armor:IsPurgeException()
	return false
end
function modifier_juggernaut_3_ignore_armor:IsStunDebuff()
	return false
end
function modifier_juggernaut_3_ignore_armor:AllowIllusionDuplicate()
	return false
end
function modifier_juggernaut_3_ignore_armor:RemoveOnDeath()
	return false
end
function modifier_juggernaut_3_ignore_armor:OnCreated(params)
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, self:GetParent())
end
function modifier_juggernaut_3_ignore_armor:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, self:GetParent())
end
function modifier_juggernaut_3_ignore_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_juggernaut_3_ignore_armor:GetModifierIgnorePhysicalArmor(params)
	return 1
end
function modifier_juggernaut_3_ignore_armor:OnTakeDamage(params)
	if params.unit == self:GetParent() and params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		self:Destroy()
	end
end