LinkLuaModifier("mod__shield", "lua_abilities\mod__shield.lua", LUA_MODIFIER_MOTION_NONE)
shield_tank = class({})


function shield_tank:GetIntrinsicModifierName()
    return "mod__shield"
end