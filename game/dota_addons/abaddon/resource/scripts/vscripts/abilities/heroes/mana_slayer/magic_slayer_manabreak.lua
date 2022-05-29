LinkLuaModifier('modifier_magic_slayer_manabreak_passive', 'abilities/heroes/mana_slayer/modifiers/modifier_magic_slayer_manabreak_passive.lua', LUA_MODIFIER_MOTION_NONE)
magic_slayer_manabreak = class({})

function magic_slayer_manabreak:GetIntrinsicModifierName()
    return "modifier_magic_slayer_manabreak_passive"
end