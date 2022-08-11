item_magic_poor_mans_shield_lua = item_magic_poor_mans_shield_lua or class({})

LinkLuaModifier("modifier_poor_mans_shield_lua","item_abilities/item_poor_mans_shield_lua.lua", LUA_MODIFIER_MOTION_NONE)


function item_magic_poor_mans_shield_lua:GetIntrinsicModifierName()
	return "modifier_poor_mans_shield_lua"
end

modifier_poor_mans_shield_lua = modifier_poor_mans_shield_lua or class({})

function modifier_poor_mans_shield_lua:IsPassive()
	return 1
end

function modifier_poor_mans_shield_lua:IsPurgable()
	return 0
end

function modifier_poor_mans_shield_lua:IsHidden()
	return true
end

function modifier_poor_mans_shield_lua:DeclareFunctions()
	local property = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK
	}

	return property
end

function modifier_poor_mans_shield_lua:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_poor_mans_shield_lua:GetModifierMagical_ConstantBlock( kv )
	if self:GetAbility():IsCooldownReady() then
		if self:GetCaster():IsRangedAttacker() then
			if kv.damage > 300 then
				self:GetAbility():StartCooldown( 3 )

				return 300
			else
				return self:GetAbility():GetSpecialValueFor("damage_block_ranged")
			end
		else
			if kv.damage > 300 then
				self:GetAbility():StartCooldown( 3 )
				return 300
			else
				return self:GetAbility():GetSpecialValueFor("damage_block_melee")
			end
		end
	end
end

LinkLuaModifier("modifier_great_shield_active", "item_abilities/item_poor_mans_shield_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_great_shield_passive", "item_abilities/item_poor_mans_shield_lua.lua", LUA_MODIFIER_MOTION_NONE)
item_great_shield_lua = class({})

function item_great_shield_lua:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_great_shield_active", { duration = self:GetSpecialValueFor("duration") })
end
function item_great_shield_lua:GetIntrinsicModifierName()		return "modifier_great_shield_passive" end

modifier_great_shield_passive = class({})

function modifier_great_shield_passive:IsHidden() return true end
function modifier_great_shield_passive:IsDebuff() return false end
function modifier_great_shield_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	}
end
function modifier_great_shield_passive:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect")  end
function modifier_great_shield_passive:GetModifierMagical_ConstantBlock()
	if self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("damage_block_ranged")
	else
		return self:GetAbility():GetSpecialValueFor("damage_block_melee")
	end
end

modifier_great_shield_active = class({})

function modifier_great_shield_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end
function modifier_great_shield_active:GetModifierTotal_ConstantBlock(kv)
	return kv.damage * 50 / 100
end
function modifier_great_shield_active:GetEffectName()			return "particles/items2_fx/vanguard_active.vpcf" end
function modifier_great_shield_active:GetEffectAttachType()			return PATTACH_POINT_FOLLOW end