imba_tower_replenishment = imba_tower_replenishment or class({})
LinkLuaModifier("modifier_imba_tower_replenishment_aura", "lua_abilities/replenishment", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_replenishment_aura_buff", "lua_abilities/replenishment", LUA_MODIFIER_MOTION_NONE)

function imba_tower_replenishment:GetAbilityTextureName()
	return "keeper_of_the_light_chakra_magic"
end

function imba_tower_replenishment:GetIntrinsicModifierName()
	return "modifier_imba_tower_replenishment_aura"
end

-- Tower Aura
modifier_imba_tower_replenishment_aura = modifier_imba_tower_replenishment_aura or class({})

function modifier_imba_tower_replenishment_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_replenishment_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_replenishment_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_replenishment_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_replenishment_aura:GetModifierAura()
	return "modifier_imba_tower_replenishment_aura_buff"
end

function modifier_imba_tower_replenishment_aura:IsAura()
	return true
end

function modifier_imba_tower_replenishment_aura:IsDebuff()
	return false
end

function modifier_imba_tower_replenishment_aura:IsHidden()
	return true
end

-- Cooldown reduction Modifier
modifier_imba_tower_replenishment_aura_buff = modifier_imba_tower_replenishment_aura_buff or class({})

function modifier_imba_tower_replenishment_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.cooldown_reduction_pct = self.ability:GetSpecialValueFor("cooldown_reduction_pct")
	self.bonus_cooldown_reduction = self.ability:GetSpecialValueFor("bonus_cooldown_reduction")
end

function modifier_imba_tower_replenishment_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_replenishment_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_replenishment_aura_buff:GetCustomCooldownReductionStacking()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
	return self.cooldown_reduction_pct + self.bonus_cooldown_reduction * protective_instinct_stacks
end