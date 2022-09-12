magic_seal = class({})
LinkLuaModifier("modifier_magic_seal_debuff", "lua_abilities/mana_slayer.lua", LUA_MODIFIER_MOTION_NONE)
function magic_seal:OnSpellStart()
	CreateModifierThinker(self:GetCaster(), self, "modifier_magic_sphere", { duration = self:GetSpecialValueFor("duration") }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

modifier_magic_seal_debuff = class({})

function modifier_magic_seal_debuff:IsHidden() return false end
function modifier_magic_seal_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_magic_seal_debuff:GetModifierIncomingPhysicalDamage_Constant( kv )
	if params.target == self:GetParent() then
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 660, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)
		for _, foe in pairs( units ) do
			if not self:GetParent() then
				ApplyDamage({
					victim = foe,
					attacker = self:GetCaster(),
					ability = self:GetAbility(),
					damage = self:GetAbility():GetSpecialValueFor('bonus_physical_damage'),
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK
				})
			end
		end
		return self:GetAbility():GetSpecialValueFor('bonus_physical_damage') + (kv.damage * self:GetAbility():GetSpecialValueFor('divide_damage') / 100 )
	end
end

function modifier_magic_seal_debuff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbiltiy():GetSpecialValueFor('bonus_attack_speed')
end

mana_expeller = class({})
LinkLuaModifier("modifier_mana_expeller", "lua_abilities/mana_slayer.lua", LUA_MODIFIER_MOTION_NONE)

function mana_expeller:GetManaCost( iLevel )
	return self:GetCaster():GetMana() * self:GetSpecialValueFor("mana_percent") / 100
end

function mana_expeller:OnSpellStart()
	local default_scale = self:GetCaster():GetModelScale()

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mana_expeller", { duration = self:GetSpecialValueFor("duration") })
	self:GetCaster():SetRenderColor(255, 162, 0)
	self:GetCaster():EmitSound("Hero_Huskar.Life_Break")
end

modifier_mana_expeller = class({})

function modifier_mana_expeller:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.hp_regen = self:GetAbility():GetSpecialValueFor("regen_bonus")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("szName")
end
function modifier_mana_expeller:OnDestroy()
	self:GetParent():SetRenderColor(255, 255, 255)
end

function modifier_mana_expeller:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_mana_expeller:GetModifierConstantHealthRegen()
	return self.hp_regen
end
function modifier_mana_expeller:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
function modifier_mana_expeller:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end