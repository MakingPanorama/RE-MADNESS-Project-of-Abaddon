LinkLuaModifier ("modifier_kratos_final_strike", "npc_abilities/kratos_final_strike.lua", LUA_MODIFIER_MOTION_NONE)

if kratos_final_strike == nil then kratos_final_strike = class ( {}) end
function kratos_final_strike:GetBehavior() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
function kratos_final_strike:GetIntrinsicModifierName() return "modifier_kratos_final_strike" end

if modifier_kratos_final_strike == nil then modifier_kratos_final_strike = class({}) end
function modifier_kratos_final_strike:IsHidden() return true end
function modifier_kratos_final_strike:IsPurgable() return false end
function modifier_kratos_final_strike:DeclareFunctions() return {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE} end

function modifier_kratos_final_strike:GetModifierProcAttack_BonusDamage_Pure(params)
    if IsServer() then 
    	if RollPercentage(100 - params.target:GetHealthPercent()) then
    		return self:GetAbility():GetSpecialValueFor("bonus_pure_strike")
    	end
    end 
	return
end








