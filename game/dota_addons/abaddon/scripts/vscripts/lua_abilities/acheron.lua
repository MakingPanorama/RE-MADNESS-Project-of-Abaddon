LinkLuaModifier("modifier_chaos_arrows_rain_interval", "lua_abilities/acheron.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaos_arrows_rain_debuff", "lua_abilities/acheron.lua", LUA_MODIFIER_MOTION_NONE)
-- I don't know another way to make it...
LinkLuaModifier("modifier_chaos_arrows_rain_delay", "lua_abilities/acheron.lua", LUA_MODIFIER_MOTION_NONE)
chaos_arrows_rain = class({})

function chaos_arrows_rain:OnSpellStart()
	self.cursor = self:GetCursorPosition()
	self.duration = self:GetSpecialValueFor("duration")
	CreateModifierThinker(self:GetCaster(), self, "modifier_chaos_arrows_rain_interval", { duration = self.duration }, self.cursor, self:GetCaster():GetTeamNumber(), false)
end

modifier_chaos_arrows_rain_interval = class({})

function modifier_chaos_arrows_rain_interval:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink( 0.75 )
end

function modifier_chaos_arrows_rain_interval:OnIntervalThink()
	local origin = self:GetParent():GetAbsOrigin()
	for i=1,12 do
		local randomize = Vector(RandomInt(origin.x-self.radius, origin.x+self.radius), RandomInt(origin.y-self.radius, origin.y+self.radius), origin.z)
		local rain = ParticleManager:CreateParticle("particles/custom/chaos_rain.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(rain, 0, randomize)
		ParticleManager:SetParticleControl(rain, 1, Vector(0,0,1000))
	end

	CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_chaos_arrows_rain_delay", { duration = 1 }, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	EmitSoundOn("Hero_LegionCommander.Overwhelming.Cast", self:GetCaster())
end

modifier_chaos_arrows_rain_delay = class({})

function modifier_chaos_arrows_rain_delay:OnDestroy()
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local strength_pct = self:GetAbility():GetSpecialValueFor("strength_pct")
	local result = (self:GetCaster():GetStrength() * strength_pct / 100) + damage
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_ALL,
		0,
		0,
		false
	)


	for _,unit in pairs(units) do
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaos_arrows_rain_debuff", { duration = self:GetAbility():GetSpecialValueFor("duration") * 2 })

		ApplyDamage({
			victim = unit,
			attacker = self:GetCaster(),
			ability = self:GetAbility(),
			damage = result,
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end
	EmitSoundOn("Hero_LegionCommander.Overwhelming.Location", self:GetCaster())
end

modifier_chaos_arrows_rain_debuff = class({})

function modifier_chaos_arrows_rain_debuff:OnCreated()
	self.debuff_attack_bonus = self:GetAbility():GetSpecialValueFor("debuff_attack_bonus")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_chaos_arrows_rain_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

-- Set * ( -1  ) to negative number
function modifier_chaos_arrows_rain_debuff:GetModifierAttackSpeedBonus_Constant()		return self.bonus_armor * ( -1 ) end
function modifier_chaos_arrows_rain_debuff:GetModifierPhysicalArmorBonus()				return self.debuff_attack_bonus * ( -1 ) end

LinkLuaModifier("modifier_acheron_blade_debuff", "lua_abilities/acheron.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_acheron_blade_passive", "lua_abilities/acheron.lua", LUA_MODIFIER_MOTION_NONE)

acheron_blade = class({})

function acheron_blade:GetIntrinsicModifierName()
	return "modifier_acheron_blade_passive"
end

modifier_acheron_blade_passive = class({})

function modifier_acheron_blade_passive:IsHidden() 		return true end
function modifier_acheron_blade_passive:IsPassive()		return true end
function modifier_acheron_blade_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK
	}
end
function modifier_acheron_blade_passive:GetModifierPreAttack_CriticalStrike()
	local crit = self:GetAbility():GetSpecialValueFor("crit_damage")
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(true, false, true)
		return crit
	end
end

function modifier_acheron_blade_passive:OnAttack(kv)
	if kv.attacker ~= self:GetParent() then return end

	if self:GetAbility():IsCooldownReady() then
		kv.target:AddNewModifier(self:GetCaster(), self, "modifier_acheron_blade_debuff", { duration = self:GetAbility():GetSpecialValueFor("duration") })
		self:GetAbility():UseResources(false, false, true)
	end
end

modifier_acheron_blade_debuff = class({})
function modifier_acheron_blade_debuff:OnCreated() self.attack_reduce = self:GetAbility():GetSpecialValueFor("attack_reduce") end
function modifier_acheron_blade_debuff:DeclareFunctions() return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE } end
function modifier_acheron_blade_debuff:GetModifierPreAttack_BonusDamage() return self.attack_reduce end
