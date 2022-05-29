modifier_interval = modifier_interval or class({})

function modifier_interval:IsHidden()
	return 1
end

function modifier_interval:IsPassive()
	return 1 
end

function modifier_interval:OnCreated()
	self:StartIntervalThink( 12 )
end

function modifier_interval:OnIntervalThink()
	self:GetAbility():StartCooldown( 12 )
	self:GetAbility():OnSpellStart()
end

function modifier_interval:CheckState()
	return {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = false, -- Disallows denie this unit
	}
end

-- END