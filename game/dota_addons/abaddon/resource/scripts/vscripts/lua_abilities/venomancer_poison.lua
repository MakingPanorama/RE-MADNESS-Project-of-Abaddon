venomancer_poison = class({})

LinkLuaModifier("modifier_venomancer_poison_sting_passive","lua_abilities/modifier_venomancer_poison_sting_passive.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_venomancer_poison_sting_debuff","lua_abilities/modifier_venomancer_poison_sting_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function venomancer_poison:GetIntrinsicModifierName()
	return "modifier_venomancer_poison_sting_passive"
end