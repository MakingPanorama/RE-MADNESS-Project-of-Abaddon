item_rebels_sword = item_rebels_sword or class({}) 

LinkLuaModifier( "modifier_rebels_sword_passive", 		'lua_abilities/modifiers/modifier_rebels_sword_passive',   	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rebels_sword_disarmor", 		'lua_abilities/modifiers/modifier_rebels_sword_disarmor', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rebels_sword_disarmor_cd", 	'lua_abilities/modifiers/modifier_rebels_sword_disarmor_cd', 	LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_rebels_sword:GetIntrinsicModifierName()
	return "modifier_rebels_sword_passive"
end