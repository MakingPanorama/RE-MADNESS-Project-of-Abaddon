imba_tower_barrier = imba_tower_barrier or class({})
LinkLuaModifier("modifier_imba_tower_barrier_aura", "lua_abilities/barrier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_barrier_aura_buff", "lua_abilities/barrier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_barrier_aura_cooldown", "lua_abilities/barrier", LUA_MODIFIER_MOTION_NONE)

function imba_tower_barrier:GetIntrinsicModifierName()
	return "modifier_imba_tower_barrier_aura"
end

function imba_tower_barrier:GetAbilityTextureName()
	return "custom/tower_barrier"
end

-- Tower Aura
modifier_imba_tower_barrier_aura = modifier_imba_tower_barrier_aura or class({})

function modifier_imba_tower_barrier_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.prevention_modifier = "modifier_imba_tower_barrier_aura_cooldown"

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_barrier_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_barrier_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_barrier_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_barrier_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_barrier_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_barrier_aura:GetAuraEntityReject(target)
	if target:HasModifier(self.prevention_modifier) then
		return true -- reject
	end

	return false
end

function modifier_imba_tower_barrier_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_barrier_aura:GetModifierAura()
	return "modifier_imba_tower_barrier_aura_buff"
end

function modifier_imba_tower_barrier_aura:IsAura()
	return true
end

function modifier_imba_tower_barrier_aura:IsDebuff()
	return false
end

function modifier_imba_tower_barrier_aura:IsHidden()
	return true
end

-- Barrier Modifier
modifier_imba_tower_barrier_aura_buff = modifier_imba_tower_barrier_aura_buff or class({})

function modifier_imba_tower_barrier_aura_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		if not self.ability then
			self:Destroy()
			return nil
		end
		self.parent = self:GetParent()
		self.prevention_modifier = "modifier_imba_tower_barrier_aura_cooldown"

		-- Ability specials
		self.base_maxdamage = self.ability:GetSpecialValueFor("base_maxdamage")
		self.maxdamage_per_protective = self.ability:GetSpecialValueFor("maxdamage_per_protective")
		self.replenish_duration = self.ability:GetSpecialValueFor("replenish_duration")

		-- Assign variables
		self.tower_barrier_damage = 0
		self.tower_barrier_max = self.base_maxdamage

		-- Calculate max damage to show on modifier creation
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
		local show_stacks = self.base_maxdamage + self.maxdamage_per_protective * protective_instinct_stacks
		self:SetStackCount(show_stacks)

		-- Start thinking
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_tower_barrier_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_barrier_aura_buff:OnIntervalThink()
	if IsServer() then
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
		self.tower_barrier_max = self.base_maxdamage + self.maxdamage_per_protective * protective_instinct_stacks

		-- If the barrier should be broken, break it
		local barrier_life = self.tower_barrier_max - self.tower_barrier_damage
		if barrier_life <= 0 then
			self.parent:AddNewModifier(self.caster, self.ability, self.prevention_modifier, {duration = self.replenish_duration})
			self:Destroy()
		end

		self:SetStackCount(barrier_life)
	end
end

function modifier_imba_tower_barrier_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_tower_barrier_aura_buff:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_tower_barrier_aura_buff:OnTakeDamage(keys)
	if IsServer() then
		local unit = keys.unit
		local damage = keys.original_damage
		local damage_type = keys.damage_type

		-- Only apply on the golem taking damage
		if unit == self.parent then

			-- Adjust damage according to armor or magic resist, if damage types match.
			if damage_type == DAMAGE_TYPE_PHYSICAL then
				damage = damage * GetReductionFromArmor(self.parent:GetPhysicalArmorValue(false))

			elseif damage_type == DAMAGE_TYPE_MAGICAL then
				damage = damage * (1- self.parent:GetMagicalArmorValue() * 0.01)
			end

			-- Increase the damage that the barrier had blocked
			self.tower_barrier_damage = self.tower_barrier_damage + damage
		end
	end
end

function modifier_imba_tower_barrier_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_barrier_aura_buff:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf"
end

function modifier_imba_tower_barrier_aura_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Barrier cooldown modifier
modifier_imba_tower_barrier_aura_cooldown = modifier_imba_tower_barrier_aura_cooldown or class({})

function modifier_imba_tower_barrier_aura_cooldown:IsHidden()
	return false
end

function modifier_imba_tower_barrier_aura_cooldown:IsPurgable()
	return false
end

function modifier_imba_tower_barrier_aura_cooldown:IsDebuff()
	return false
end
