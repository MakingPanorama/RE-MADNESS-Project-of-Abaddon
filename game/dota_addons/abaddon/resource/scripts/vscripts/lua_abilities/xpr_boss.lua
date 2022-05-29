xpr_boss=class({})
xpr_boss_op=class({})
modifier_xpr_boss = class({})
modifier_xpr_boss_op = class({})
LinkLuaModifier("modifier_xpr_boss","lua_abilities/basic_experience_bonus.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_xpr_boss_op","lua_abilities/basic_experience_bonus.lua",LUA_MODIFIER_MOTION_NONE)

function xpr_boss:OnUpgrade()
 self:GetCaster():RemoveModifierByName("modifier_xpr_boss")
 self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_xpr_boss",{})
end

function xpr_boss_op:OnUpgrade()
 self:GetCaster():RemoveModifierByName("modifier_xpr_boss_op")
 self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_xpr_boss_op",{})
end

function modifier_xpr_boss:IsPermanent() return true end
function modifier_xpr_boss:IsHidden() return true end

function modifier_xpr_boss:OnCreated() 
  if IsServer() then
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("Interval")/self:GetAbility():GetSpecialValueFor("experience_bonus"))
  end
end

function modifier_xpr_boss:OnIntervalThink()
  self:GetCaster():AddExperience(1,DOTA_ModifyXP_Unspecified,false,true)
end

function modifier_xpr_boss_op:IsPermanent() return true end
function modifier_xpr_boss_op:IsHidden() return true end

function modifier_xpr_boss_op:OnCreated() 
  if IsServer() then
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("Interval")/self:GetAbility():GetSpecialValueFor("experience_bonus"))
  end
end

function modifier_xpr_boss_op:OnIntervalThink()
  self:GetCaster():AddExperience(1,DOTA_ModifyXP_Unspecified,false,true)
end


