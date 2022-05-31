LinkLuaModifier("modifier_item_sealed_sword", "item_abilities/item_sealed_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sealed_sword_active", "item_abilities/item_sealed_sword", LUA_MODIFIER_MOTION_NONE)
item_sealed_sword = class({})

function item_sealed_sword:GetIntrinsicModifierName()       return "modifier_item_sealed_sword" end
function item_sealed_sword:OnSpellStart()
    local duration = self:GetSpecialValueFor("duration")

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_sealed_sword_active", { duration = duration  })
end

modifier_item_sealed_sword = class({})

function modifier_item_sealed_sword:IsHidden()      return true end
function modifier_item_sealed_sword:IsPassive()     return true end
function modifier_item_sealed_sword:IsDebuff()      return false end
function modifier_item_sealed_sword:OnCreated()
    local ability = self:GetAbility()

    self.add_str = ability:GetSpecialValueFor("bonus_str")
    self.add_agi = ability:GetSpecialValueFor("bonus_agility")
    self.add_int = ability:GetSpecialValueFor("bonus_int")
    self.galaxy_chance = ability:GetSpecialValueFor("galaxy_chance")
    self.procatt_bonus = ability:GetSpecialValueFor("bonus_procattack_damage")

    self.bashed = false
end
function modifier_item_sealed_sword:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
    }
end
function modifier_item_sealed_sword:GetModifierProcAttack_BonusDamage_Physical( kv )
    local attacker = kv.attacker
    local target = kv.target

    if attacker == self:GetParent() then
        if not attacker:HasModifier("modifier_item_sealed_sword_active") then
            if not self.bashed == true then
                if RollPercentage(self.galaxy_chance) then
                    target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = 0.5 })
                    self:GetCaster():EmitSound("Hero_FacelessVoid.TimeLockImpact")
                    self.bashed = true
                    self:StartIntervalThink(1.2)
                    return self.procatt_bonus
                end
            else
                return nil
            end
        end
    end
end
function modifier_item_sealed_sword:OnIntervalThink()
    self.bashed = false
    self:StartIntervalThink(-1)
end
function modifier_item_sealed_sword:GetModifierBonusStats_Strength()        return self.add_str end
function modifier_item_sealed_sword:GetModifierBonusStats_Agility()         return self.add_agi end
function modifier_item_sealed_sword:GetModifierBonusStats_Intellect()       return self.add_int end

modifier_item_sealed_sword_active = class({})

function modifier_item_sealed_sword_active:IsHidden()               return false end
function modifier_item_sealed_sword_active:IsPurgable()             return true end
function modifier_item_sealed_sword_active:IsAura()                 
    if self:GetParent() == self:GetCaster() then
        return true
    end
    return false
end
function modifier_item_sealed_sword_active:GetAuraDuration()        return 1 end
function modifier_item_sealed_sword_active:GetAuraRadius()          return self.radius end
function modifier_item_sealed_sword_active:GetModifierAura()        return "modifier_item_sealed_sword_active" end
function modifier_item_sealed_sword_active:GetAuraSearchTeam()      return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_sealed_sword_active:GetAuraSearchType()      return DOTA_UNIT_TARGET_ALL end
function modifier_item_sealed_sword_active:DeclareFunctions()       return { MODIFIER_PROPERTY_MISS_PERCENTAGE } end
function modifier_item_sealed_sword_active:GetModifierMiss_Percentage()     return self.miss_percent end
function modifier_item_sealed_sword_active:GetEffectName()
    if self:GetParent() == self:GetCaster() then
        return "particles/items2_fx/radiance_owner.vpcf"
    end
    return "particles/items2_fx/radiance.vpcf"
end
function modifier_item_sealed_sword_active:OnCreated()
    local ability = self:GetAbility()

    self.miss_percent = ability:GetSpecialValueFor("miss_percentage")
    self.damage_per_second = ability:GetSpecialValueFor("damage_per_second")
    self.damage_health_per_second = ability:GetSpecialValueFor("damage_health_per_second")
    self.radius = ability:GetSpecialValueFor("radius_aura")

    self:StartIntervalThink(1)
end
function modifier_item_sealed_sword_active:OnIntervalThink()
    if self:GetParent() ~= self:GetCaster() then
        local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)

        for _,unit in pairs(units) do
            ApplyDamage({
                victim = unit,
                attacker = self:GetCaster(),
                ability = self:GetAbility(),
                damage = self.damage_per_second + unit:GetHealth() * self.damage_health_per_second / 100,
                damage_type = DAMAGE_TYPE_PURE
            })
        end
    end
end