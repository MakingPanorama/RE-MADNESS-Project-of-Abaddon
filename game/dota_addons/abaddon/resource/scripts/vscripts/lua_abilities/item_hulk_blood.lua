LinkLuaModifier("modifier_item_hulk_blood", "lua_abilities/item_hulk_blood.lua", LUA_MODIFIER_MOTION_NONE)
if item_hulk_blood == nil then item_hulk_blood = class({}) end

function item_hulk_blood:GetIntrinsicModifierName()
   return "modifier_item_hulk_blood"
end

if modifier_item_hulk_blood == nil then modifier_item_hulk_blood = class({}) end

function modifier_item_hulk_blood:IsHidden()
   return true
end

function modifier_item_hulk_blood:IsPurgable()
   return false
end

function modifier_item_hulk_blood:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function modifier_item_hulk_blood:GetModifierBaseAttackTimeConstant( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("Health_Bonus") 
end
function modifier_item_hulk_blood:GetModifierHPRegenAmplify_Percentage( params )
	local amplify = (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("heal_amplify")
	return amplify 
end
function modifier_item_hulk_blood:GetModifierMPRegenAmplify_Percentage( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("mana_amplify")
end