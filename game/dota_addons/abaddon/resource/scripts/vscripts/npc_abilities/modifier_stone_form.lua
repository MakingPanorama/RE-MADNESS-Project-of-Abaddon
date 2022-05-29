modifier_stone_form = class({})

function modifier_stone_form:GetStatusEffectName()
	return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf"
end

function modifier_stone_form:IsHidden( ... )
	return true
end

function modifier_stone_form:IsPurgable( ... )
	return false
end

function modifier_stone_form:DeclareFunctions( ... )
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_stone_form:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_stone_form:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_stone_form:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_stone_form:GetModifierHealthRegenPercentage()
	return 1
end

function modifier_stone_form:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return state
end