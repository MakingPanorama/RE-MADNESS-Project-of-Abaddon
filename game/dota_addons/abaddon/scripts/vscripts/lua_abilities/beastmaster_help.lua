beastmaster_help = class({})
LinkLuaModifier("modifier_beastmaster_help", "lua_abilities/modifier_beastmaster_help.lua", LUA_MODIFIER_MOTION_NONE)

function beastmaster_help:GetIntrinsicModifierName() 
	return "modifier_beastmaster_help"
end