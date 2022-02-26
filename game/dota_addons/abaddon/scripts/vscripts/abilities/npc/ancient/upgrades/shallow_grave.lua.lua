LinkLuaModifier( "modifier_shallow_grave", "abilities/npc/ancient/upgrades/shallow_grave.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if shallow_grave == nil then
	shallow_grave = class({})
end
function shallow_grave:GetIntrinsicModifierName()
	return "modifier_shallow_grave"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shallow_grave == nil then
	modifier_shallow_grave = class({})
end
function modifier_shallow_grave:OnCreated(params)
	if IsServer() then
	end
end
function modifier_shallow_grave:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_shallow_grave:OnDestroy()
	if IsServer() then
	end
end
function modifier_shallow_grave:DeclareFunctions()
	return {
	}
end