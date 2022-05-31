if item_alebard == nil then
	item_alebard = class({})
end

LinkLuaModifier("modifier_alebard_passive","item_abilities/item_alebard.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alebard_disarm","item_abilities/item_alebard.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alebard_traum","item_abilities/item_alebard.lua",LUA_MODIFIER_MOTION_NONE)

function item_alebard:GetIntrinsicModifierName(  )
	return "modifier_alebard_passive"
end

function item_alebard:OnSpellStart(  )
	if IsServer() then
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()
		if target:TriggerSpellAbsorb(self) then return end
		target:TriggerSpellReflect(self) 
		target:AddNewModifier(caster,self,"modifier_alebard_disarm",{duration = self:GetSpecialValueFor("duration")})
	end
end

----------------------------

if modifier_alebard_passive == nil then
	modifier_alebard_passive = class({})
end

function modifier_alebard_passive:IsHidden(  )
	return true
end

function modifier_alebard_passive:GetAttributes(  )
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_alebard_passive:DeclareFunctions(  )
	local hFuncs = { MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_EVASION_CONSTANT,MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
	return hFuncs
end

function modifier_alebard_passive:OnCreated(  )
	local ability = self:GetAbility()
	self.damage = ability:GetSpecialValueFor("damage")
	self.atk = ability:GetSpecialValueFor("atk")
	self.evasion = ability:GetSpecialValueFor("evasion")
	self.str = ability:GetSpecialValueFor("str")
	self.dmg = ability:GetSpecialValueFor("dmg")
	self.hp = ability:GetSpecialValueFor("hp")
	self.chance = ability:GetSpecialValueFor("chance")
	self.duration_r = ability:GetSpecialValueFor("duration_r")
	self.chance_t = ability:GetSpecialValueFor("chance_t")
	self.damage_c = ability:GetSpecialValueFor("damage_c")
end

function modifier_alebard_passive:OnRefresh(  )
	local ability = self:GetAbility()
	self.damage = ability:GetSpecialValueFor("damage")
	self.atk = ability:GetSpecialValueFor("atk")
	self.evasion = ability:GetSpecialValueFor("evasion")
	self.str = ability:GetSpecialValueFor("str")
	self.dmg = ability:GetSpecialValueFor("dmg")
	self.hp = ability:GetSpecialValueFor("hp")
	self.chance = ability:GetSpecialValueFor("chance")
	self.duration_r = ability:GetSpecialValueFor("duration_r")
	self.chance_t = ability:GetSpecialValueFor("chance_t")
	self.damage_c = ability:GetSpecialValueFor("damage_c")
end

function modifier_alebard_passive:GetModifierPreAttack_BonusDamage(  )
	return self.damage
end

function modifier_alebard_passive:GetModifierAttackSpeedBonus_Constant(  )
	return self.atk
end

function modifier_alebard_passive:GetModifierEvasion_Constant(  )
	return self.evasion
end

function modifier_alebard_passive:GetModifierBonusStats_Strength(  )
	return self.str
end

function modifier_alebard_passive:GetModifierDamageOutgoing_Percentage(  )
	return self.dmg
end

function modifier_alebard_passive:GetModifierHealthBonus(  )
	return self.hp
end

function modifier_alebard_passive:OnAttackLanded( params )
	local caster = self:GetParent()
	if IsServer() and params.attacker == caster then
		if RollPercentage(self.chance) and caster:IsRealHero() then
			params.target:AddNewModifier(caster,self:GetAbility(),"modifier_alebard_traum",{duration = self.duration_r})
		end

		if RollPercentage(self.chance_t) and caster:IsRealHero() then
			ApplyDamage({attacker = caster,victim = params.target, damage = self.damage_c, damage_type = DAMAGE_TYPE_PURE})
		elseif RollPercentage(self.chance_t) then
			ApplyDamage({attacker = caster,victim = params.target, damage = self.damage_c / 5, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

-----------------------------------------

if modifier_alebard_disarm == nil then
	modifier_alebard_disarm = class({})
end

function modifier_alebard_disarm:GetTexture(  )
	return "item_alebard"
end

function modifier_alebard_disarm:IsDebuff(  )
	return true
end

function modifier_alebard_disarm:CheckState()
	local states = { [ MODIFIER_STATE_DISARMED ] = true }
	return states
end

function modifier_alebard_disarm:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_fatesedict_disarm.vpcf"
end

---------------------------------------

if modifier_alebard_traum == nil then
	modifier_alebard_traum = class({})
end

function modifier_alebard_traum:GetTexture(  )
	return "item_alebard"
end

function modifier_alebard_traum:DeclareFunctions(  )
	local hFuncs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
	return hFuncs
end

function modifier_alebard_traum:IsDebuff(  )
	return true
end

function modifier_alebard_traum:OnCreated(  )
	local ability = self:GetAbility()
	self.slow = ability:GetSpecialValueFor("slow")
	self.slow_atk = ability:GetSpecialValueFor("slow_atk")
end

function modifier_alebard_traum:OnRefresh(  )
	local ability = self:GetAbility()
	self.slow = ability:GetSpecialValueFor("slow")
	self.slow_atk = ability:GetSpecialValueFor("slow_atk")
end

function modifier_alebard_traum:GetModifierMoveSpeedBonus_Percentage(  )
	if IsServer() then
		return -self.slow
	end
	return -self.slow
end

function modifier_alebard_traum:GetModifierAttackSpeedBonus_Constant(  )
	if IsServer() then
		return -self.slow_atk
	end
	return -self.slow_atk
end