LinkLuaModifier("modifier_item_dark_flow", "lua_abilities/item_dark_flow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dark_flow_buff", "lua_abilities/item_dark_flow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dark_flow_debuff", "lua_abilities/item_dark_flow.lua", LUA_MODIFIER_MOTION_NONE)

item_dark_flow = class({})
function item_dark_flow:GetIntrinsicModifierName() return "modifier_item_dark_flow" end

modifier_item_dark_flow = class({})

function modifier_item_dark_flow:OnCreated()
  self.duration = self:GetAbility():GetSpecialValueFor("duration")
  self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
  self.damage_per_hit = self:GetAbility():GetSpecialValueFor("damage_per_hit")
  self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_strength")
  self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_intellect")
  self.bonus_mana_reg = self:GetAbility():GetSpecialValueFor("mana_regen")
  self.block_amount = self:GetAbility():GetSpecialValueFor("block_amount")
end

function modifier_item_dark_flow:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
  }
  return funcs
end

function modifier_item_dark_flow:GetModifierPhysical_ConstantBlock() return self.block_amount end
function modifier_item_dark_flow:GetModifierBonusStats_Strength() return self.bonus_str end
function modifier_item_dark_flow:GetModifierBonusStats_Intellect() return self.bonus_int end
function modifier_item_dark_flow:GetModifierPercentageManaRegen() return self.bonus_mana_reg end
function modifier_item_dark_flow:GetModifierPreAttack_BonusDamage()   return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_dark_flow:GetModifierProcAttack_BonusDamage_Pure(kv)
  local target = kv.target
  local attacker = kv.attacker
  local parent = self:GetParent()
  local ability = self:GetAbility()
  local damage = kv.damage

  if attacker == parent then
    local modifier_dark_flow_debuff = target:AddNewModifier(self:GetCaster(), ability, "modifier_item_dark_flow_debuff", { duration = self.duration })
    local modifier_dark_flow_buff = parent:AddNewModifier(self:GetCaster(), ability, "modifier_item_dark_flow_buff", { duration = self.duration })
    
    local buff_stack = modifier_dark_flow_buff:GetStackCount()
    local stacks = modifier_dark_flow_debuff:GetStackCount()
    if modifier_dark_flow_debuff then
      if stacks < self.max_stacks then modifier_dark_flow_debuff:IncrementStackCount() end
    end
    if modifier_dark_flow_buff then
      if buff_stack < self.max_stacks then modifier_dark_flow_buff:IncrementStackCount() end
    end

    modifier_dark_flow_buff:ForceRefresh()
    modifier_dark_flow_debuff:ForceRefresh()

    totalDamage = self.damage_per_hit * stacks

    if attacker:GetName() ~= "npc_dota_hero_ursa" then
      EmitSoundOn("Hero_TrollWarlord.BerserkersRage.Stun", target)
      print(totalDamage)
      return totalDamage
      else
      print("Attacker will not gain damage")
      return nil
    end
  end
  return nil
end

modifier_item_dark_flow_debuff = class({})

function modifier_item_dark_flow_debuff:GetTexture() return "custom/silencer_bloodthorn" end

function modifier_item_dark_flow_debuff:IsDebuff()
    return true
end

function modifier_item_dark_flow_debuff:IsPurgable()
  return false
end

function modifier_item_dark_flow_debuff:DeclareFunctions()
  local decFuns = {}
    decFuns = {
      MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
      MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
  return decFuns
end

function modifier_item_dark_flow_debuff:OnCreated()
  self.caster = self:GetCaster()
  self.ability = self:GetAbility()
  self.parent = self:GetParent()

  self.armor_reduction = self.ability:GetSpecialValueFor("armor_reduction")
  self.attackspeed_bonus = self.ability:GetSpecialValueFor("attackspeed_per_hit")
end

function modifier_item_dark_flow_debuff:GetModifierPhysicalArmorBonus()
  return self.armor_reduction * self:GetStackCount()
end
function modifier_item_dark_flow_debuff:GetModifierAttackSpeedBonus_Constant()
  return self.attackspeed_bonus * ( -1 ) * self:GetStackCount()
end
function modifier_item_dark_flow_debuff:GetEffectName()
  return "particles/units/heroes/hero_slardar/slardar_broken_shield.vpcf"
end
function modifier_item_dark_flow_debuff:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end

modifier_item_dark_flow_buff = class({})

function modifier_item_dark_flow_buff:GetTexture() return "custom/silencer_bloodthorn" end

function modifier_item_dark_flow_buff:IsDebuff()
    return false
end

function modifier_item_dark_flow_buff:IsPurgable()
  return false
end

function modifier_item_dark_flow_buff:DeclareFunctions()
  local decFuns = {}
    decFuns = {
      MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
      MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
  return decFuns
end

function modifier_item_dark_flow_buff:OnCreated()
  self.caster = self:GetCaster()
  self.ability = self:GetAbility()
  self.parent = self:GetParent()

  self.armor_reduction = self.ability:GetSpecialValueFor("armor_reduction")
  self.attackspeed_bonus = self.ability:GetSpecialValueFor("attackspeed_per_hit")
end

function modifier_item_dark_flow_buff:GetModifierPhysicalArmorBonus()
  return self.armor_reduction * (-1) * self:GetStackCount() * 20 / 100
end
function modifier_item_dark_flow_buff:GetModifierAttackSpeedBonus_Constant()
  return self.attackspeed_bonus * self:GetStackCount() * 60 / 100
end
function modifier_item_dark_flow_buff:GetEffectName()
  return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end