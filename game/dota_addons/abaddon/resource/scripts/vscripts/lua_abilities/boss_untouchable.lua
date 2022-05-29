boss_untouchable = class( {} )

LinkLuaModifier( "modifier_boss_untouchable", "lua_abilities/boss_untouchable.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_untouchable_debuff", "lua_abilities/boss_untouchable.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_untouchable:GetIntrinsicModifierName()
	return "modifier_boss_untouchable"
end

--------------------------------------------------------------------------------

modifier_boss_untouchable = class( {} )

--------------------------------------------------------------------------------

function modifier_boss_untouchable:IsDebuff()
	return false
end

function modifier_boss_untouchable:IsHidden()
	return true
end

function modifier_boss_untouchable:IsPurgable()
	return false
end

function modifier_boss_untouchable:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable:OnCreated( event )
	self:OnRefresh( event )
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable:OnRefresh( event )
	if IsServer() then
		local spell = self:GetAbility()
		
		self.targetTeam = spell:GetAbilityTargetTeam()
		self.targetType = spell:GetAbilityTargetType()
		self.targetFlags = spell:GetAbilityTargetFlags()
	end
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable:OnAttackRecord( event )
	if IsServer() then
		local parent = self:GetParent()
		
		if event.target ~= parent then
			return
		end
		
		local teamParent = parent:GetTeamNumber()
		local spell = self:GetAbility()
		local attacker = event.attacker
		
		local ufResult = UnitFilter(
			attacker,
			self.targetTeam,
			self.targetType,
			self.targetFlags,
			teamParent
		)

		if ufResult == UF_SUCCESS then
			attacker:AddNewModifier( parent, spell, "modifier_boss_untouchable_debuff", {} )
		end
	end
end

--------------------------------------------------------------------------------

modifier_boss_untouchable_debuff = class( {} )

--------------------------------------------------------------------------------

function modifier_boss_untouchable_debuff:IsDebuff()
	return true
end

function modifier_boss_untouchable_debuff:IsHidden()
	return false
end

function modifier_boss_untouchable_debuff:IsPurgable()
	return true
end

function modifier_boss_untouchable_debuff:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable_debuff:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_enchantress_untouchable.vpcf"
end

function modifier_boss_untouchable_debuff:StatusEffectPriority()
	return 9
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable_debuff:OnCreated( event )
	local caster = self:GetCaster()
	local spell = self:GetAbility()
	
	local level = math.max( math.floor( caster:GetLevel() / spell:GetSpecialValueFor( "starting_level" ) ) - 1.0, 0 )
	
	self.attackSpeed = -1.0 * ( spell:GetSpecialValueFor( "attack_speed_slow" ) + ( spell:GetSpecialValueFor( "slow_per_level" ) * level ) )
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable_debuff:GetModifierAttackSpeedBonus_Constant( event )
	local parent = self:GetParent()
	
	return self.attackSpeed * ( 1.0 - parent:GetMagicalArmorValue() )
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable_debuff:OnAttackRecord( event )
	if IsServer() then
		local parent = self:GetParent()
		
		if event.attacker ~= parent then
			return
		end
		
		local caster = self:GetCaster()
		
		if event.target ~= caster then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_untouchable_debuff:OnDeath( event )
	if IsServer() then
		if event.unit == self:GetCaster() then
			self:Destroy()
		end
	end
end