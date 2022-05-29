LinkLuaModifier( "modifier_magic_slayer_manabreak", "abilities/heroes/mana_slayer/magic_slayer_manabreak.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if magic_slayer_manabreak == nil then
	magic_slayer_manabreak = class({})
end
function magic_slayer_manabreak:GetIntrinsicModifierName()
	return "modifier_magic_slayer_manabreak"
end
---------------------------------------------------------------------
--Modifiers
if modifier_magic_slayer_manabreak == nil then
	modifier_magic_slayer_manabreak = class({})
end
function modifier_magic_slayer_manabreak:OnCreated(params)
	if IsServer() then
	end
end
function modifier_magic_slayer_manabreak:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_magic_slayer_manabreak:OnDestroy()
	if IsServer() then
	end
end
function modifier_magic_slayer_manabreak:DeclareFunctions()
	return {
	}
end