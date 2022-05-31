LinkLuaModifier("modifier_quelling_blade_passive", "item_abilities/quelling_blade.lua", LUA_MODIFIER_MOTION_NONE)
item_quelling_blade_custom = class({})

function item_quelling_blade_custom:GetIntrinsicModifierName() return "modifier_quelling_blade_passive" end
modifier_quelling_blade_passive = class({})

function modifier_quelling_blade_passive:IsHidden() return true end
function modifier_quelling_blade_passive:IsDebuff()	return false end
function modifier_quelling_blade_passive:DeclareFunctions() return { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL } end 
function modifier_quelling_blade_passive:GetModifierProcAttack_BonusDamage_Magical(kv)
	if IsServer() then
		if kv.attacker == self:GetParent() then
			if self:GetParent():IsRangedAttacker() then
				return 68
			else
				return 94
			end
		end
	end
end

