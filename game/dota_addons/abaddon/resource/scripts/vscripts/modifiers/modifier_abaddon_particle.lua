modifier_developer_creator = modifier_developer_creator or class({})

function modifier_developer_creator:IsHidden()
	return true
end

function modifier_developer_creator:IsPassive()
	return 1
end

function modifier_developer_creator:RemoveOnDeath()
	return 0
end

function modifier_developer_creator:GetEffectName()
	return "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf"
end

function modifier_developer_creator:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_developer_creator:GetModifierProjectileName()
	return "particles/econ/events/snowball/snowball_projectile.vpcf"
end

-------------------------------------------------------------------------------------------

modifier_developer_creator_2 = modifier_developer_creator_2 or class({})

function modifier_developer_creator_2:IsHidden()
	return true
end

function modifier_developer_creator_2:IsPassive()
	return 1
end

function modifier_developer_creator_2:RemoveOnDeath()
	return 0
end

function modifier_developer_creator_2:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
end

-------------------------------------------------------------------------------------------

modifier_developer_creator_3 = modifier_developer_creator_3 or class({})

function modifier_developer_creator_3:IsHidden()
	return true
end

function modifier_developer_creator_3:IsPassive()
	return 1
end

function modifier_developer_creator_3:RemoveOnDeath()
	return 0
end

function modifier_developer_creator_3:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf"
end