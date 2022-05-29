LinkLuaModifier("mod__shield", "lua_abilities/mod__shield", LUA_MODIFIER_MOTION_NONE)
shield = class({})


function shield:GetIntrinsicModifierName()
    return "mod__shield"
end