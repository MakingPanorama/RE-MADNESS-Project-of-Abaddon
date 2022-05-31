LinkLuaModifier("modifier_bonus_attack_speed", "item_abilities/item_summon_golem.lua", LUA_MODIFIER_MOTION_NONE)
item_summon_golem = class({})

function item_summon_golem:OnSpellStart()
    if IsServer() then
        -- Variables
        local point = self:GetCursorPosition()
        local duration = self:GetSpecialValueFor("duration")
        local damage_percent = self:GetSpecialValueFor("bonus_damage_percent")
        local health_percent = self:GetSpecialValueFor("bonus_health_percent")
        local bonus_armor_percent = self:GetSpecialValueFor("bonus_armor_percent")


        local unit = CreateUnitByName("npc_dota_warlock_golem_3", point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
        
        unit:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)

        unit:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = duration }) -- Limited time of life
        unit:AddNewModifier(self:GetCaster(), self, "modifier_bonus_attack_speed", { duration = duration })


        Timers:CreateTimer(function()
            for r=0, unit:GetAbilityCount()-1 do
                local ability = unit:GetAbilityByIndex(r)
                if ability ~= nil then
                    if ability:GetLevel() < ability:GetMaxLevel() then
                        ability:SetLevel( self:GetCaster():GetLevel() * 0.3 )
                    end
                end
            end
            return 0.1
        end) 

        -- Stats
        unit:SetMaxHealth( unit:GetMaxHealth() + self:GetCaster():GetMaxHealth() * health_percent / 100  )
        unit:SetHealth( unit:GetMaxHealth() )
        unit:SetBaseDamageMin( unit:GetBaseDamageMin() + self:GetCaster():GetBaseDamageMin() * damage_percent / 100 )
        unit:SetBaseDamageMax( unit:GetBaseDamageMax() + self:GetCaster():GetBaseDamageMax() * damage_percent / 100 )
        unit:SetPhysicalArmorBaseValue( unit:GetPhysicalArmorValue( false ) + self:GetCaster():GetPhysicalArmorValue( false ) * bonus_armor_percent / 100 )
        -- Cannot change attack speed here, because function for this "Does not exist"!
    end
end

modifier_bonus_attack_speed = class({})

function modifier_bonus_attack_speed:IsHidden() return true end
function modifier_bonus_attack_speed:OnCreated()
    self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed_percent")
end
function modifier_bonus_attack_speed:DeclareFunctions() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT } end
function modifier_bonus_attack_speed:GetModifierAttackSpeedBonus_Constant()
    return self:GetCaster():GetAttackSpeed() * self.attack_speed
end