LinkLuaModifier('modifier_mana_slayer_mana_expeller', 'abilities/heroes/mana_slayer/mana_expeller/modifiers/modifier_mana_slayer_mana_expeller.lua', LUA_MODIFIER_MOTION_NONE)
mana_slayer_mana_expeller = class({})

function mana_slayer_mana_expeller:GetManaCost( iLevel )
	return self:GetCaster():GetMana() % self:GetSpecialValueFor('mana_percent')
end	

function mana_slayer_mana_expeller:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_mana_slayer_mana_expeller', { duration = self:GetSpecialValueFor('duration') })
	self:GetCaster():Purge(false, true, false, true, false)
end