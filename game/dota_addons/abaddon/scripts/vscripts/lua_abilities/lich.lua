---------------------------------------------------------------------
--------------------------FROZEN SKIN--------------------------------
---------------------------------------------------------------------

imba_sly_king_frozen_skin = imba_sly_king_frozen_skin or class({})

LinkLuaModifier("modifier_imba_frozen_skin_passive", "lua_abilities/lich.lua", LUA_MODIFIER_MOTION_NONE) --intrinsic modifier
LinkLuaModifier("modifier_imba_frozen_skin_debuff", "lua_abilities/lich.lua", LUA_MODIFIER_MOTION_NONE)  --frostbite debuff

function imba_sly_king_frozen_skin:GetIntrinsicModifierName()
	return "modifier_imba_frozen_skin_passive"
end

--------------------------------------------------------------
----------Frozen skin intrinsic modifier ------------------
--------------------------------------------------------------

modifier_imba_frozen_skin_passive = class({})
function modifier_imba_frozen_skin_passive:OnCreated()

	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.frostbite_modifier = "modifier_imba_frozen_skin_debuff"

	--Ability Specials
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
	self.prng = -10
end

function modifier_imba_frozen_skin_passive:OnRefresh()
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.reduction_duration = self:GetAbility():GetSpecialValueFor("reduction_duration")
end

function modifier_imba_frozen_skin_passive:IsHidden()
	return true
end

function modifier_imba_frozen_skin_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_imba_frozen_skin_passive:OnAttackLanded(params)
	if IsServer() then
		if params.target == self.parent then

			if self.caster:PassivesDisabled() or                                              -- if Sly King is broken, do nothing.
				params.attacker:IsBuilding() or	params.attacker:IsMagicImmune() then         -- if the guy attacking Sly King is a tower or spell immune, do nothing.
				return nil
			end

			--roll for a pseudo random chance: each fail will slightly increase the successive roll success chance
			if RollPseudoRandom(self.chance, self) then
				params.attacker:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = self.stun_duration}) --mini-stun
				params.attacker:AddNewModifier(self.parent, self.ability, self.frostbite_modifier, {duration = self.duration}) --frostbite
			end
		end
	end
end

------------------------------------------------------------------
---------------Frozen skin debuff modifier -----------------------
------------------------------------------------------------------

modifier_imba_frozen_skin_debuff = modifier_imba_frozen_skin_debuff or class({})

function modifier_imba_frozen_skin_debuff:IsPurgable()			return false end
function modifier_imba_frozen_skin_debuff:IsDebuff()			return true end
function modifier_imba_frozen_skin_debuff:IsHidden()			return false end
function modifier_imba_frozen_skin_debuff:IsStunDebuff()		return true end
function modifier_imba_frozen_skin_debuff:IsPurgeException()	return true end
function modifier_imba_frozen_skin_debuff:CheckState()			return {[MODIFIER_STATE_ROOTED] = true} end

function modifier_imba_frozen_skin_debuff:OnCreated( kv )
	if IsServer() then
		--Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		--Ability Specials
		self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")
		self.damage_per_second = self.ability:GetSpecialValueFor("damage_per_second")

		-- Immediately proc the first damage instance
		self:OnIntervalThink()

		--Play sound
		self:GetParent():EmitSound("Hero_Crystal.Frostbite")

		-- Get thinkin
		self:StartIntervalThink(self.damage_interval)
		self:GetParent():AddNewModifier(self.caster, nil, "modifier_rooted", {duration = self:GetAbility():GetSpecialValueFor("duration")})
	end
end

function modifier_imba_frozen_skin_debuff:OnIntervalThink()
	if IsServer() then
		local tick_damage = self.damage_per_second * self.damage_interval
		ApplyDamage({attacker = self.caster, victim = self.parent, ability = self.ability, damage = tick_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function modifier_imba_frozen_skin_debuff:GetEffectName() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end
function modifier_imba_frozen_skin_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
