LinkLuaModifier( "modifier_no_attack_miss", "abilities/npc/ancient/upgrades/no_attack_miss.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if no_attack_miss == nil then
	no_attack_miss = class({})
end
function no_attack_miss:GetIntrinsicModifierName()
	return "modifier_no_attack_miss"
end
---------------------------------------------------------------------
--Modifiers
if modifier_no_attack_miss == nil then
	modifier_no_attack_miss = class({})
end
function modifier_no_attack_miss:OnCreated(params)
	if IsServer() then
	end
end
function modifier_no_attack_miss:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_no_attack_miss:OnDestroy()
	if IsServer() then
	end
end
function modifier_no_attack_miss:DeclareFunctions()
	return {
	}
end