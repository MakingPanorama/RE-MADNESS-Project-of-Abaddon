LinkLuaModifier("modifier_huskar_poison_milk","lua_abilities/modifier_huskar_poison_milk.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_poison_milk_buff","lua_abilities/modifier_huskar_poison_milk_buff.lua",LUA_MODIFIER_MOTION_NONE)

huskar_poison_milk = class({})

function huskar_poison_milk:GetIntrinsicModifierName()
	return "modifier_huskar_poison_milk"
end