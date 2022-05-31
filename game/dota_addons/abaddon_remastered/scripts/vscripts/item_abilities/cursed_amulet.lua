cursed_amulet = class({})

function cursed_amulet:GetIntrinsicModifierName()
	return "modifier_cursed_amulet"
end

modifier_cursed_amulet = class(itemBaseClass)
LinkLuaModifier( "modifier_cursed_amulet", "item_abilities/cursed_amulet.lua", LUA_MODIFIER_MOTION_NONE )

function modifier_cursed_amulet:OnCreated()
	self.duration = self:GetSpecialValueFor("duration")
	self.chance = self:GetSpecialValueFor("chance")
end

function modifier_cursed_amulet:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_cursed_amulet:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and self:RollPRNG( self.chance ) then
			params.target:DisableHealing(self.duration)
		end
	end
end