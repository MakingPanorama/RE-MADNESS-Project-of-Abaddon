LinkLuaModifier("modifier_mom_i_gone", "lua_abilities/elite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mom_i_hide", "lua_abilities/elite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_super_illusion", "lua_abilities/elite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attack_speed_masters", "lua_abilities/elite.lua", LUA_MODIFIER_MOTION_NONE)
elite_images_your_moms = class({})

function elite_images_your_moms:OnSpellStart()
    -- Variables
    if not IsServer() then return end
    local gone = self:GetSpecialValueFor("gone_duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mom_i_gone", { duration = gone })
    self:GetCaster():EmitSound("Hero_NagaSiren.MirrorImage")
end

modifier_mom_i_gone = class({})

function modifier_mom_i_gone:IsHidden() return true end
function modifier_mom_i_gone:IsPurgable() return false end
function modifier_mom_i_gone:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
    }
end
function modifier_mom_i_gone:OnCreated()
    if not IsServer() then return end
    self:GetCaster():AddNoDraw()
end
function modifier_mom_i_gone:OnDestroy()
    -- Creating illusions and e.t.c
    -- Trick mom
    -- Variables
    if not IsServer() then return end
    local images_count = self:GetAbility():GetSpecialValueFor("images_count")
    local duration = self:GetAbility():GetSpecialValueFor("illusion_duration")
    local angles = self:GetCaster():GetAngles()

    self:GetCaster():Stop() -- Stop yourself to not be detected
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mom_i_hide", { duration = duration })

    self:GetAbility().mirror_image_illusions = {}

    local iRandomSpawnPos = {
        Vector( -100, 0, 0 ), Vector( 100, 0, 0 ), Vector( 0, 100, 0 ), Vector( 0, -100, 0 )
    }

    for i=#iRandomSpawnPos, 2, -1 do
        local j = RandomInt(1, i)
        iRandomSpawnPos[i], iRandomSpawnPos[j] = iRandomSpawnPos[j], iRandomSpawnPos[i]
    end

    table.insert( iRandomSpawnPos, RandomInt( 1, images_count + 1 ), Vector( 0,0,0 ) )

    FindClearSpaceForUnit( self:GetCaster(), self:GetCaster():GetAbsOrigin() + RandomVector( 200 ), true )

    for i=1, images_count do
        local origin = self:GetCaster():GetAbsOrigin() + table.remove(iRandomSpawnPos, 1)
        local illusion = CreateUnitByName(self:GetCaster():GetUnitName(), self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), nil, self:GetCaster():GetTeamNumber())
        illusion:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_super_illusion", {})
        illusion:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", { duration = duration })
        illusion:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
        illusion:SetAngles( angles.x, angles.y, angles.z )

        illusion:SetBaseMoveSpeed(550)
        illusion:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_attack_speed_masters", {})

        for max=0,8 do
            local item = self:GetCaster():GetItemInSlot(max)
            if item ~= nil then
                local itemName = item:GetName()
                local newItem = CreateItem( itemName, illusion, illusion )
                illusion:AddItem(newItem)
            end
        end
        for e = 0, illusion:GetAbilityCount() do
            local id = illusion:GetAbilityByIndex( e )
            local caster = self:GetCaster():GetAbilityByIndex( e )
            if id ~= nil then
                local abilityIllusion = illusion:FindAbilityByName(id:GetAbilityName())
                abilityIllusion:SetLevel( caster:GetLevel() )
            end
        end
        local casterLevel = self:GetCaster():GetLevel()
		for i=1,casterLevel-1 do
			illusion:HeroLevelUp(false)
		end
    end
end

modifier_super_illusion = class({})

function modifier_super_illusion:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_IS_ILLUSION,
        MODIFIER_PROPERTY_SUPER_ILLUSION,
        MODIFIER_PROPERTY_ILLUSION_LABEL,
        
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end
function modifier_super_illusion:GetIsIllusion()                                return true end
function modifier_super_illusion:GetModifierSuperIllusion()                     return true end
function modifier_super_illusion:GetModifierIllusionLabel()                     return true end
function modifier_super_illusion:OnTakeDamage(kv)
    if not IsServer() then return end
    if not kv.unit:IsAlive() then
        if kv.unit == self:GetParent() then
            kv.unit:AddNoDraw()
            kv.unit:MakeIllusion()
        end
    end
end 
function modifier_super_illusion:CheckState()
    return {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
    }
end
function modifier_super_illusion:GetStatusEffectName()
    return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end

modifier_mom_i_hide = class({})

function modifier_mom_i_hide:IsHidden()                 return true end
function modifier_mom_i_hide:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
    }
end
function modifier_mom_i_hide:OnDestroy()
    if not IsServer() then return end
    self:GetCaster():RemoveNoDraw()
end

modifier_attack_speed_masters = class({})

function modifier_attack_speed_masters:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end
function modifier_attack_speed_masters:GetModifierAttackSpeedBonus_Constant()
    return self:GetCaster():GetAttackSpeed() * 100
end
