---------------------------------
-- 		   Thick Hide          --
---------------------------------

hide_boss = class({})
LinkLuaModifier("modifier_imba_thick_hide", "lua_abilities/hide_boss.lua", LUA_MODIFIER_MOTION_NONE)

function hide_boss:GetAbilityTextureName()
	return "custom/centaur_thick_hide"
end

function hide_boss:GetIntrinsicModifierName()
	return "modifier_imba_thick_hide"
end

function hide_boss:IsInnateAbility()
	return true
end

-- Thick hide modifier
modifier_imba_thick_hide = class({})

function modifier_imba_thick_hide:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.damage_reduction_pct = self.ability:GetSpecialValueFor("damage_reduction_pct")
	self.debuff_duration_red_pct = self.ability:GetSpecialValueFor("debuff_duration_red_pct")
end

function modifier_imba_thick_hide:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}

	return decFuncs
end

function modifier_imba_thick_hide:GetModifierIncomingDamage_Percentage()
	-- Does nothing if hero has break
	if self.caster:PassivesDisabled() then
		return nil
	end

	return self.damage_reduction_pct * (-1)
end

function modifier_imba_thick_hide:GetCustomTenacity()
	return self.debuff_duration_red_pct
end