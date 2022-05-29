creep_as = class( {} )

LinkLuaModifier( "modifier_creep_as", "lua_abilities/creep_as.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creep_as:GetIntrinsicModifierName()
	return "modifier_creep_as"
end

--------------------------------------------------------------------------------

modifier_creep_as = class( {} )

--------------------------------------------------------------------------------

function modifier_creep_swiftness:IsDebuff()
	return false
end

function modifier_creep_swiftness:IsHidden()
	return false
end

function modifier_creep_swiftness:IsPurgable()
	return false
end

function modifier_creep_swiftness:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_creep_swiftness:OnCreated( event )
	-- since the creeps aren't actually starting at their proper level, we need to refresh after a short delay
	self:StartIntervalThink( 1.0 / 30.0 )
end

--------------------------------------------------------------------------------

function modifier_creep_swiftness:OnRefresh( event )
	local parent = self:GetParent()
	local spell = self:GetAbility()
	
	local level = math.max( parent:GetLevel() - spell:GetSpecialValueFor( "starting_level" ), 0 )
	
	self.moveSpeed = spell:GetSpecialValueFor( "bonus_move_speed" ) + ( spell:GetSpecialValueFor( "move_speed_per_level" ) * level )
	
	self:SetStackCount( math.floor( self.moveSpeed ) )
end

--------------------------------------------------------------------------------

function modifier_creep_swiftness:OnIntervalThink()
	self:OnRefresh( event )
	
	self:StartIntervalThink( -1 )
end

--------------------------------------------------------------------------------

function modifier_creep_swiftness:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creep_swiftness:GetModifierMoveSpeedBonus_Percentage( event )
	return self.moveSpeed
end