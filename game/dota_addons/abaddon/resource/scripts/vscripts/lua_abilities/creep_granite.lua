creep_granite = class( {} )

LinkLuaModifier( "modifier_creep_granite", "lua_abilities/creep_granite.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creep_granite:GetIntrinsicModifierName()
	return "modifier_creep_granite"
end

--------------------------------------------------------------------------------

modifier_creep_granite = class( {} )

--------------------------------------------------------------------------------

function modifier_creep_granite:IsDebuff()
	return false
end

function modifier_creep_granite:IsHidden()
	return false
end

function modifier_creep_granite:IsPurgable()
	return false
end

function modifier_creep_granite:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_creep_granite:OnCreated( event )
	-- since the creeps aren't actually starting at their proper level, we need to refresh after a short delay
	self:StartIntervalThink( 1.0 / 30.0 )
end

--------------------------------------------------------------------------------

function modifier_creep_granite:OnRefresh( event )
	local parent = self:GetParent()
	local spell = self:GetAbility()
	
	local level = math.max( parent:GetLevel() - spell:GetSpecialValueFor( "starting_level" ), 0 )
	
	self.health = spell:GetSpecialValueFor( "bonus_health" ) + ( spell:GetSpecialValueFor( "health_per_level" ) * level )
	
	self:SetStackCount( math.floor( self.health ) )
	
	if IsServer() then

		parent:SetMaxHealth( parent:GetMaxHealth() + 100 )
		parent:SetBaseMaxHealth( parent:GetBaseMaxHealth() + 100)
		parent:SetHealth( parent:GetHealth() + 100 )
	end
end

--------------------------------------------------------------------------------

function modifier_creep_granite:OnIntervalThink()
	self:OnRefresh( event )
	
	self:StartIntervalThink( -1 )
end

--------------------------------------------------------------------------------

function modifier_creep_granite:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creep_granite:OnTooltip( event )
	return self.health
end