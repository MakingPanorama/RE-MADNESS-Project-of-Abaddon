affixes_ability_spike = class({})
LinkLuaModifier("modifier_affixes_spike_permanent", "lua_abilities/modifier_affixes_spike_permanent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_affixes_spike_warning", "lua_abilities/modifier_affixes_spike_warning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_affixes_spike", "lua_abilities/modifier_affixes_spike", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
-- Passive Modifier
function affixes_ability_spike:GetIntrinsicModifierName()
    return "modifier_affixes_spike_permanent"
end