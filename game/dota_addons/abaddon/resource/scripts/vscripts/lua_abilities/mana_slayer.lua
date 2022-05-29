magic_seal = class({})
LinkLuaModifier("modifier_magic_sphere", "lua_abilities/mana_slayer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magic_sphere_buff", "lua_abilities/mana_slayer.lua", LUA_MODIFIER_MOTION_NONE)

function magic_seal:OnSpellStart()
	CreateModifierThinker(self:GetCaster(), self, "modifier_magic_sphere", { duration = self:GetSpecialValueFor("duration") }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

modifier_magic_sphere = class({})


function modifier_magic_sphere:OnCreated()
	local sphere = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(sphere, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"),self:GetAbility():GetSpecialValueFor("radius"),self:GetAbility():GetSpecialValueFor("radius")))

	self:StartIntervalThink( 1 )
end

function modifier_magic_sphere:OnIntervalThink()
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 0, false)

	for _,unit in pairs(units) do
		if unit:GetMana() > 1 then
			unit:SpendMana(self:GetAbility():GetSpecialValueFor("mana_burn"), self:GetAbility())
		else
			ApplyDamage({
				victim = unit,
				attacker = self:GetCaster(),
				damage = self:GetAbility():GetSpecialValueFor("health_burn"),
				damage_type = DAMAGE_TYPE_MAGICAL
			})
		end
	end
end
function modifier_magic_sphere:IsAura()
	return true
end
function modifier_magic_sphere:IsAuraActiveOnDeath()
	return false
end
function modifier_magic_sphere:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end
function modifier_magic_sphere:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end
function modifier_magic_sphere:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_magic_sphere:GetModifierAura()
return "modifier_magic_sphere_buff" end

function modifier_magic_sphere:GetAuraDuration()
return 0.1 end


modifier_magic_sphere_buff = class({})

function modifier_magic_sphere_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end

function modifier_magic_sphere_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() or self:GetParent():GetUnitName() == "Ancient Guardian" then
		state = {
			[MODIFIER_STATE_INVISIBLE] = true,
		}
	else
		state = {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_FROZEN] = true,
		}
	end
	return state
end

function modifier_magic_sphere_buff:GetModifierInvisibilityLevel()
	if self:GetParent():GetUnitName() == "npc_dota_hero_antimage" or self:GetParent():GetUnitName() == "Ancient Guardian" then
		return 1
	end
	return 0
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