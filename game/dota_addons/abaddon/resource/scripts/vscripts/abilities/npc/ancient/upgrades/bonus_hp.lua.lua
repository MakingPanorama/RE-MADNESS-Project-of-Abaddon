LinkLuaModifier( "modifier_bonus_hp", "abilities/npc/ancient/upgrades/bonus_hp.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if bonus_hp == nil then
	bonus_hp = class({})
end
function bonus_hp:GetIntrinsicModifierName()
	return "modifier_bonus_hp"
end
---------------------------------------------------------------------
--Modifiers
if modifier_bonus_hp == nil then
	modifier_bonus_hp = class({})
end
function modifier_bonus_hp:OnCreated(params)
	if IsServer() then
	end
end
function modifier_bonus_hp:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_bonus_hp:OnDestroy()
	if IsServer() then
	end
end
function modifier_bonus_hp:DeclareFunctions()
	return {
	}
end