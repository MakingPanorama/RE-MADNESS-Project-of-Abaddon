creep_sanguine_aura = class( {} )

LinkLuaModifier( "modifier_creep_sanguine_aura", "lua_abilities/creep_sanguine_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_sanguine_aura_effect", "lua_abilities/creep_sanguine_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_sanguine_aura_counter", "lua_abilities/creep_sanguine_aura.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creep_sanguine_aura:GetCastRange( loc, target )
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function creep_sanguine_aura:GetIntrinsicModifierName()
	return "modifier_creep_sanguine_aura"
end

--------------------------------------------------------------------------------

modifier_creep_sanguine_aura = class( {} )

--------------------------------------------------------------------------------

function modifier_creep_sanguine_aura:IsDebuff()
	return false
end

function modifier_creep_sanguine_aura:IsHidden()
	return true
end

function modifier_creep_sanguine_aura:IsPurgable()
	return false
end

function modifier_creep_sanguine_aura:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_creep_sanguine_aura:IsAura()
	local parent = self:GetParent()
	
	return not ( parent:PassivesDisabled() or parent:IsOutOfGame() )
end

function modifier_creep_sanguine_aura:GetModifierAura()
	return "modifier_creep_sanguine_aura_effect"
end

function modifier_creep_sanguine_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_creep_sanguine_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_creep_sanguine_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_creep_sanguine_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

--------------------------------------------------------------------------------

modifier_creep_sanguine_aura_effect = class( {} )

--------------------------------------------------------------------------------

function modifier_creep_sanguine_aura_effect:IsDebuff()
	return false
end

function modifier_creep_sanguine_aura_effect:IsHidden()
	return true
end

function modifier_creep_sanguine_aura_effect:IsPurgable()
	return false
end

function modifier_creep_sanguine_aura_effect:IsPermanent()
	return false
end

function modifier_creep_sanguine_aura_effect:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_creep_sanguine_aura_effect:OnCreated( event )
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local spell = self:GetAbility()
		local mod = parent:AddNewModifier( caster, spell, "modifier_creep_sanguine_aura_counter", {} )
		
		if mod then
			mod:IncrementStackCount()
		end
	end

--------------------------------------------------------------------------------

	function modifier_creep_sanguine_aura_effect:OnRemoved( event )
		local parent = self:GetParent()
		local mod = parent:FindModifierByName( "modifier_creep_sanguine_aura_counter" )
		
		if mod then
			mod:DecrementStackCount()
		end
	end
end

--------------------------------------------------------------------------------

modifier_creep_sanguine_aura_counter = class( {} )

--------------------------------------------------------------------------------

function modifier_creep_sanguine_aura_counter:IsDebuff()
	return false
end

function modifier_creep_sanguine_aura_counter:IsHidden()
	return false
end

function modifier_creep_sanguine_aura_counter:IsPurgable()
	return false
end

function modifier_creep_sanguine_aura_counter:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_creep_sanguine_aura_counter:OnCreated( event )
	local spell = self:GetAbility()
	
	self.bat = math.max( spell:GetBaseAttackTime() )
	self.mult = math.max( spell:GetSpecialValueFor( "mult" ) )
end

--------------------------------------------------------------------------------

function modifier_creep_sanguine_aura_counter:OnRefresh( event )
	local spell = self:GetAbility()
	
	self.bat = math.max( spell:GetBaseAttackTime() )
	self.mult = math.max( spell:GetSpecialValueFor( "mult" ) )
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_creep_sanguine_aura_counter:OnStackCountChanged( countOld )		
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_creep_sanguine_aura_counter:GetModifierConstantHealthRegen( event )
	return (self.bat - ((self.bat *0.01) *self.mult)) * self:GetStackCount()
end