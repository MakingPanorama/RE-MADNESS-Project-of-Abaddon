paw_of_lucius = class({})
LinkLuaModifier("modifier_paw_of_lucius", "lua_abilities/modifier_paw_of_lucius", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function paw_of_lucius:GetIntrinsicModifierName()
    return "modifier_paw_of_lucius"
end

--------------------------------------------------------------------------------
function paw_of_lucius:Spawn()
    self.required_level = self:GetSpecialValueFor("required_level")
end

--------------------------------------------------------------------------------
function paw_of_lucius:OnHeroLevelUp()
    if IsServer() then
        if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
            self:OnUnequip()
            self:OnEquip()
        end
    end
end

--------------------------------------------------------------------------------
function paw_of_lucius:IsMuted()
    if self.required_level > self:GetCaster():GetLevel() then
        return true
    end
    if not self:GetCaster():IsHero() then
        return true
    end

    return self.BaseClass.IsMuted(self)
end