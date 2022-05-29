if spell_lab_souls_str == nil then
	spell_lab_souls_str = class({})
end

LinkLuaModifier("spell_lab_souls_str_modifier", "scripts/vscripts/lua_abilities/str.lua", LUA_MODIFIER_MOTION_NONE)

function spell_lab_souls_str:GetIntrinsicModifierName() return "spell_lab_souls_str_modifier" end


if spell_lab_souls_str_modifier == nil then
	spell_lab_souls_str_modifier = require "scripts/vscripts/lua_abilities/base2.lua"
end

function spell_lab_souls_str_modifier:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function spell_lab_souls_str_modifier:GetModifierBonusStats_Strength()
	return self:GetSoulsBonus() * self:GetAbility():GetSpecialValueFor("per_soul")
end

function spell_lab_souls_str_modifier:GetModifierBonusStats_Agility()
	return self:GetSoulsBonus() * self:GetAbility():GetSpecialValueFor("per_soul")
end

function spell_lab_souls_str_modifier:GetModifierBonusStats_Intellect()
	return self:GetSoulsBonus() * self:GetAbility():GetSpecialValueFor("per_soul")
end

function spell_lab_souls_str_modifier:GetColour ()
	return {255,50,50}
end
