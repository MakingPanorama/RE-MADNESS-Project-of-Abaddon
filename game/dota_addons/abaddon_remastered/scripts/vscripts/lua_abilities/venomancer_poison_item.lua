item_venomancer_poison_item = class({})

LinkLuaModifier("modifier_venomancer_poison_sting_passive","lua_abilities/modifier_venomancer_poison_sting_passive_item.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_venomancer_poison_sting_debuff","lua_abilities/modifier_venomancer_poison_sting_debuff_item.lua",LUA_MODIFIER_MOTION_NONE)

function item_venomancer_poison_item:GetIntrinsicModifierName()
	return "modifier_venomancer_poison_sting_passive"
end