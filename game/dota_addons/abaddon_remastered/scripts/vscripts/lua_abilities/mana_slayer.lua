magic_seal = class({})
LinkLuaModifier("modifier_magic_seal_debuff", "lua_abilities/mana_slayer.lua", LUA_MODIFIER_MOTION_NONE)
function magic_seal:OnSpellStart()
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, 660, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for _, unit in pairs( units ) do
		unit:AddNewModifier( self:GetCaster(), self, "modifier_magic_seal_debuff", {duration = 7} )
	end
end

modifier_magic_seal_debuff = class({})

function modifier_magic_seal_debuff:IsHidden() return false end
function modifier_magic_seal_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_magic_seal_debuff:GetModifierIncomingPhysicalDamageConstant( kv )
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 660, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)
		for _, foe in pairs( units ) do
			if foe ~= self:GetParent() then
				ApplyDamage({
					victim = foe,
					attacker = kv.attacker,
					ability = self:GetAbility(),
					damage = self:GetAbility():GetSpecialValueFor('bonus_physical_damage') + ( kv.damage * self:GetAbility():GetSpecialValueFor('divide_damage') / 100 ),
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
				})
			end
			print(foe:GetUnitName())
		end
	return self:GetAbility():GetSpecialValueFor('bonus_physical_damage')
end

function modifier_magic_seal_debuff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
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

mana_slayer_manabreak = class({})

LinkLuaModifier('modifier_mana_slayer_manabreak', 'lua_abilities/mana_slayer.lua', LUA_MODIFIER_MOTION_NONE)
function mana_slayer_manabreak:GetIntrinsicModifierName()
	return "modifier_mana_slayer_manabreak"
end

modifier_mana_slayer_manabreak = class({})

function modifier_mana_slayer_manabreak:IsHidden()
	return true
end

function modifier_mana_slayer_manabreak:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end

function modifier_mana_slayer_manabreak:GetModifierProcAttack_BonusDamage_Physical( kv )
	local particleid = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, kv.target)
    ParticleManager:SetParticleControlEnt(particleid, 0, kv.target, PATTACH_POINT_FOLLOW, "attach_hitloc", kv.target:GetAbsOrigin(), true)

	kv.target:ReduceMana( self:GetAbility():GetSpecialValueFor('manaburn_per_hit') )
	return self:GetAbility():GetSpecialValueFor('manaburn_per_hit') + ( self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor('agi_damage_percent') / 100 )
end