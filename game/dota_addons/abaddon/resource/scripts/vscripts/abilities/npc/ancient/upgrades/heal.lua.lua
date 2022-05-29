LinkLuaModifier( "modifier_heal", "abilities/npc/ancient/upgrades/heal.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if heal == nil then
	heal = class({})
end
function heal:GetIntrinsicModifierName()
	return "modifier_heal"
end
---------------------------------------------------------------------
--Modifiers
if modifier_heal == nil then
	modifier_heal = class({})
end
function modifier_heal:OnCreated(params)
	if IsServer() then
	end
end
function modifier_heal:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_heal:OnDestroy()
	if IsServer() then
	end
end
function modifier_heal:DeclareFunctions()
	return {
	}
end