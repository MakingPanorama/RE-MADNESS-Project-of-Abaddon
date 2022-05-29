modifier_rebels_sword_passive = class({})


local disarmor_mname         = "modifier_rebels_sword_disarmor"
local disarmor_cd_mnamme     = "modifier_rebels_sword_disarmor_cd"

--------------------------------------------------------------------------------

function modifier_rebels_sword_passive:IsHidden()           return true;  end
function modifier_rebels_sword_passive:IsPurgable()         return false; end
function modifier_rebels_sword_passive:DestroyOnExpire()    return false; end
function modifier_rebels_sword_passive:GetAttributes()      return (MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT); end

--------------------------------------------------------------------------------

function modifier_rebels_sword_passive:OnCreated( kv )
    self.bonus_damage           = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_armor            = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_all_stats        = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    self.bonus_attack_speed     = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_health           = self:GetAbility():GetSpecialValueFor("bonus_health")

    if IsServer() then 
        self.disarmor               = self:GetAbility():GetSpecialValueFor("disarmor")          / 100
        self.disarmor_const         = self:GetAbility():GetSpecialValueFor("disarmor_const")
        self.max_disarmor_pct       = self:GetAbility():GetSpecialValueFor("max_disarmor_pct")  / 100
        self.duration               = self:GetAbility():GetSpecialValueFor("duration")
        self.cooldown               = self:GetAbility():GetCooldown(1)
    end 
end 


--------------------------------------------------------------------------------

function modifier_rebels_sword_passive:DeclareFunctions() return 
{
    -- Properties
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_BONUS,

    -- Events
    MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function modifier_rebels_sword_passive:GetModifierPreAttack_BonusDamage(kv)     return self.bonus_damage;       end 
function modifier_rebels_sword_passive:GetModifierPhysicalArmorBonus(kv)        return self.bonus_armor;        end 
function modifier_rebels_sword_passive:GetModifierBonusStats_Strength(kv)       return self.bonus_all_stats;    end 
function modifier_rebels_sword_passive:GetModifierBonusStats_Agility(kv)        return self.bonus_all_stats;    end 
function modifier_rebels_sword_passive:GetModifierBonusStats_Intellect(kv)      return self.bonus_all_stats;    end 
function modifier_rebels_sword_passive:GetModifierAttackSpeedBonus_Constant(kv) return self.bonus_attack_speed; end 
function modifier_rebels_sword_passive:GetModifierHealthBonus(kv)               return self.bonus_health;       end 

--------------------------------------------------------------------------------

function modifier_rebels_sword_passive:OnAttackLanded( kv )
    if not IsServer() then return end 
    if self:GetParent() ~= kv.attacker then return end 

    local target = kv.target 

    if target:HasModifier(disarmor_cd_mnamme) then return end 

    local stack_count       = target:GetModifierStackCount(disarmor_mname, target) 
    local armor             = target:GetPhysicalArmorValue( false ) + stack_count 
    
    local total_stack_count = stack_count + self.disarmor*armor + self.disarmor_const

    if total_stack_count > self.max_disarmor_pct * armor then
        total_stack_count = stack_count + self.disarmor_const
    end 

    local ability = self:GetAbility() 

    target:AddNewModifier(target, ability, disarmor_cd_mnamme, { duration = self.cooldown } )
    target:AddNewModifier(target, ability, disarmor_mname,     { duration = self.duration } )

    target:SetModifierStackCount(disarmor_mname, target, total_stack_count)
end 