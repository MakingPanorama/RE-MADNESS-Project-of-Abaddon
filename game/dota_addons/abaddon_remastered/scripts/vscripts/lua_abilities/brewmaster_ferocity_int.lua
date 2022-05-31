brewmaster_ferocity_int = class({})
LinkLuaModifier( "modifier_brewmaster_ferocity_lua_int", "lua_abilities/modifier_brewmaster_ferocity_lua_int",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function brewmaster_ferocity_int:GetIntrinsicModifierName()
	return "modifier_brewmaster_ferocity_lua_int"
end

