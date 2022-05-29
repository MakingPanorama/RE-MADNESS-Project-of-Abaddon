LinkLuaModifier("modifier_dovakin_lifesteal", "lua_abilities/dovakin.lua", LUA_MODIFIER_MOTION_NONE)
dovakin_lifesteal = class({})

function dovakin_lifesteal:GetIntrinsicModifierName()
	return "modifier_dovakin_lifesteal"
end

modifier_dovakin_lifesteal = class({})

function modifier_dovakin_lifesteal:IsHidden() return true end
function modifier_dovakin_lifesteal:IsPassive() return true end
function modifier_dovakin_lifesteal:AllowIllusionDuplicate() return false end

function modifier_dovakin_lifesteal:OnCreated()
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal")
end

function modifier_dovakin_lifesteal:OnRefresh()
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal")
end

function modifier_dovakin_lifesteal:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_dovakin_lifesteal:OnAttack( kv )
	if kv.attacker ~= self:GetParent() then return end
	local random = RandomInt(1, 50)

	local armor_base = 1
	local armor_value = kv.target:GetPhysicalArmorValue( false )
	local armor = ( ( 0.06 * armor_value ) * ( 1 +  0.06 * math.abs(armor_value)) )
	armor = armor * armor_base

	kv.attacker:Heal((kv.damage-kv.damage*armor) * (self.lifesteal / 100), self)
end

LinkLuaModifier("modifier_dovakin_power_of_the_light_debuff", "lua_abilities/dovakin", LUA_MODIFIER_MOTION_NONE)
dovakin_power_of_the_light = class({})

function dovakin_power_of_the_light:OnSpellStart()
	self.duration = self:GetSpecialValueFor("debuff_duration")
	self.target = self:GetCursorTarget()
	self.target:AddNewModifier(self:GetCaster(), self, "modifier_dovakin_power_of_the_light_debuff", { duration = self.duration })
	ApplyDamage({
		victim = self.target,
		attacker = self:GetCaster(),
		ability = self,
		damage = self:GetSpecialValueFor("base_damage"),
		damage_type = DAMAGE_TYPE_MAGICAL
	})
	self.target:EmitSound("Hero_Zuus.ArcLightning.Cast")
end

modifier_dovakin_power_of_the_light_debuff = class({})

function modifier_dovakin_power_of_the_light_debuff:IsHidden() return false end
function modifier_dovakin_power_of_the_light_debuff:IsPassive() return false end
function modifier_dovakin_power_of_the_light_debuff:IsPurgable() return true end

function modifier_dovakin_power_of_the_light_debuff:OnCreated()
	self.base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
	self.multiplier = self:GetAbility():GetSpecialValueFor("multiplier_damage")
end
function modifier_dovakin_power_of_the_light_debuff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_dovakin_power_of_the_light_debuff:OnTakeDamage( kv )
	if self:GetParent():GetHealth() < 1 then
		local findUnits = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self:GetAbility():GetSpecialValueFor("radius"),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC,
			0,
			0,
			false
		)

		for _,unit in pairs(findUnits) do

			local thunder = ParticleManager:CreateParticle("particles/dovakin_power_of_the_light.vpcf", PATTACH_ABSORIGIN, self:GetParent())

			-- Settings particle
			ParticleManager:SetParticleControlEnt(thunder, 0, self:GetParent(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(thunder, 1, unit, PATTACH_ABSORIGIN, "attach_attack1", unit:GetAbsOrigin(), true)

			local damageTable = {
				victim = unit,
				attacker = self:GetCaster(),
				damage = self.base_damage * self.multiplier + unit:GetHealth() * 3 / 100,
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage( damageTable )
		end

		self:GetParent():EmitSound("Hero_Zuus.ArcLightning.Cast")
	end
	return
end