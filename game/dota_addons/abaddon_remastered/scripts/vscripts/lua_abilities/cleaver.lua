LinkLuaModifier("modifier_war_holdout", "lua_abilities/cleaver.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_war_holdout_motion", "lua_abilities/cleaver.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
war_holdout = class({})

function war_holdout:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_war_holdout', { duration = self:GetSpecialValueFor('duration') })
end

modifier_war_holdout = class({})

function modifier_war_holdout:OnCreated()
	self.model_scale = 1.3
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self:StartIntervalThink( 1 )
end

function modifier_war_holdout:OnIntervalThink()
	if not IsServer() then return end

	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self:GetCaster():Script_GetAttackRange() * 1.5,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_ALL,
		0,
		0,
		false
	)

	local attack_range = self:GetParent():Script_GetAttackRange()
	local ring = ParticleManager:CreateParticle("particles/custom/war_holdout.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(ring, 2, Vector(self.attack_range*1.5,self.attack_range*1.5, 0))

	local ring_half = ParticleManager:CreateParticle("particles/custom/war_holdout.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(ring, 2, Vector(self.attack_range/1.5,self.attack_range/1.5, 0))

	local damage_percent = self:GetAbility():GetSpecialValueFor('strength_damage_percent')
	local damage_multiplier = self:GetAbility():GetSpecialValueFor('damage_multiplier')
	for _, unit in pairs( units ) do
		if self:GetCaster():GetRangeToUnit( unit ) < self.attack_range/1.5 then
			damage_percent = damage_percent * damage_multiplier
		end
		
		ApplyDamage({
			victim = unit,
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetStrength() * damage_percent / 100,
			damage_type = DAMAGE_TYPE_PHYSICAL
		})
	end
	EmitSoundOn("Hero_Axe.Berserkers_Call", self:GetCaster())
end

function modifier_war_holdout:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end
function modifier_war_holdout:GetModifierModelScale()
	if self:GetAbility() then
		return 50
	end
end
function modifier_war_holdout:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self.bonus_armor
	end
end
function modifier_war_holdout:GetModifierAttackRangeBonus()
	if self:GetAbility() then
		return self.bonus_attack_range
	end
end
function modifier_war_holdout:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self.bonus_str
	end
end

modifier_war_holdout_motion = class({})

function modifier_war_holdout_motion:IsHidden() return true end
function modifier_war_holdout_motion:OnCreated( kv )
	self.duration = kv.duration
	if self:ApplyHorizontalMotionController() == false then self:Destroy() end
end

function modifier_war_holdout_motion:UpdateHorizontalMotion(me, dt)
	self.vacuum = GetGroundPosition(Vector(self:GetCaster():GetAbsOrigin().x,self:GetCaster():GetAbsOrigin().y,0), nil)
	local distance = me:GetAbsOrigin() - self.vacuum
	local speed = distance:Length2D() / self:GetRemainingTime()
	local direction = ( self.vacuum - me:GetAbsOrigin() ):Normalized()

	if distance:Length2D() > 50 then
		me:SetOrigin( me:GetAbsOrigin() + direction * speed * dt )
	else
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end

function modifier_war_holdout_motion:OnDestroy()
	self:GetParent():RemoveHorizontalMotionController( self )

	-- This one line must unstuck units or units stuck in hero xD
	-- P.S: This line can crash game. Idk how it possible?!
	--self:GetParent():SetAbsOrigin(self.vacuum_pos)
	ResolveNPCPositions(self.vacuum, 128)

	ApplyDamage({
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetStrength() * 60 / 100,
		damage_type = DAMAGE_TYPE_PURE
	})
end

function modifier_war_holdout_motion:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_war_holdout_motion:OnHorizontalMotionInterrupted()
	self:Destroy()
end

LinkLuaModifier("modifier_cleaver_for_gods", "lua_abilities/cleaver.lua", LUA_MODIFIER_MOTION_NONE)

cleaver_for_gods = class({})
function cleaver_for_gods:OnSpellStart()
	self.duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_cleaver_for_gods", { duration = self.duration })

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

	EmitSoundOn("Hero_Sven.GodsStrength", self:GetCaster())
end

modifier_cleaver_for_gods = class({})

function modifier_cleaver_for_gods:OnCreated()
	self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")
	self.heal_pct = self:GetAbility():GetSpecialValueFor("heal_percentage")
	self.scale = 100
end
function modifier_cleaver_for_gods:GetEffectName() 				return "particles/customgames/capturepoints/cp_fire_captured.vpcf" end
function modifier_cleaver_for_gods:GetStatusEffectName()		return "particles/status_fx/status_effect_gods_strength.vpcf" end
function modifier_cleaver_for_gods:GetEffectAttachType()		return PATTACH_OVERHEAD_FOLLOW end
function modifier_cleaver_for_gods:StatusEffectPriority()		return 10 end

function modifier_cleaver_for_gods:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_cleaver_for_gods:GetModifierBaseDamageOutgoing_Percentage() 		return self.bonus_damage_percentage end
function modifier_cleaver_for_gods:GetModifierHealthRegenPercentage() 				return self.heal_pct end
function modifier_cleaver_for_gods:GetModifierModelScale()							return self.scale end