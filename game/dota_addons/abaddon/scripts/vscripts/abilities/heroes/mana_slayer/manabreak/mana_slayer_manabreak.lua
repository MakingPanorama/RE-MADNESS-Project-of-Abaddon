LinkLuaModifier('modifier_magic_slayer_manabreak_passive', 'abilities/heroes/mana_slayer/manabreak/modifiers/modifier_magic_slayer_manabreak_passive.lua', LUA_MODIFIER_MOTION_NONE)
mana_slayer_manabreak = class({})

function mana_slayer_manabreak:GetIntrinsicModifierName()
    return "modifier_magic_slayer_manabreak_passive"
end