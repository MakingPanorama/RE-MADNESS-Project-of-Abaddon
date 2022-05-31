modifier_heal_health_heal_mana = modifier_heal_health_heal_mana or class({})

function modifier_heal_health_heal_mana:IsBuff()
	return true
end

function modifier_heal_health_heal_mana:IsPurgable()
	return false
end

function modifier_heal_health_heal_mana:OnCreated()
	
	self.health_heal =self:GetAbility():GetSpecialValueFor( "heal_health" ) / 100
	self.mana_heal = self:GetAbility():GetSpecialValueFor( "heal_mana" ) / 100
end

function modifier_heal_health_heal_mana:OnRefresh()

	self:OnCreated()

end

function modifier_heal_health_heal_mana:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
	}
	return funcs

end

function modifier_heal_health_heal_mana:GetModifierHealth_Regen_Percentage( params )
	return	self.health_heal
end

function modifier_heal_health_heal_mana:GetModifierMana_Regen_Percentage( params )
	return self.mana_heal
end