demon = class ({})
LinkLuaModifier( "demon_modifier", "lua_abilities/demon_modifier",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function demon:GetIntrinsicModifierName()
	return "demon_modifier"
end