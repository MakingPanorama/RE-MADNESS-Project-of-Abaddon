LinkLuaModifier("modifier_passive_attack_damage_count", "lua_abilities/bear.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attack_speed_bonus", "lua_abilities/bear.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bear_jump_movement", "lua_abilities/bear.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_target_swipe", "lua_abilities/bear.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_swipe", "lua_abilities/bear.lua", LUA_MODIFIER_MOTION_NONE)

custom_swipe = class({})
function custom_swipe:GetIntrinsicModifierName()			return "modifier_passive_swipe" end

modifier_passive_swipe = class({})

function modifier_passive_swipe:IsHidden() return true end
function modifier_passive_swipe:DeclareFunctions() return { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL } end
function modifier_passive_swipe:GetModifierProcAttack_BonusDamage_Physical( kv )
	if IsServer() then
		local damage_per_stack = self:GetAbility():GetSpecialValueFor("bonus_damage_per_hit")
		local primary_damage = self:GetAbility():GetSpecialValueFor("mult_primary_attr")
		local limit = self:GetAbility():GetSpecialValueFor("limit_stack")
		local attribute =  self:GetParent():GetPrimaryAttribute() 

		if kv.attacker == self:GetParent() then
			if not self:GetCaster():PassivesDisabled() then
				local fury_swipe_modifier = kv.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_target_swipe", { duration = self:GetAbility():GetSpecialValueFor("duration") })
				local fury_swipe_stackCount = fury_swipe_modifier:GetStackCount()
				if fury_swipe_modifier then
					if fury_swipe_stackCount < limit then
						fury_swipe_modifier:IncrementStackCount()
					end
				end

				fury_swipe_modifier:ForceRefresh()

				local swipes_particle_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf", PATTACH_CENTER_FOLLOW, kv.target)
				ParticleManager:SetParticleControl(swipes_particle_fx, 1, kv.target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(swipes_particle_fx)

				local totalDamage = damage_per_stack * fury_swipe_stackCount
				if self:GetCaster():HasModifier("modifier_protect_armor") then
					totalDamage = totalDamage + self:GetCaster():FindModifierByName("modifier_protect_armor"):GetStackCount()
				end
				return totalDamage
			end
		end
	end
end

modifier_target_swipe = class({})

function modifier_target_swipe:IsPurgable() return false end
function modifier_target_swipe:DeclareFunctions() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT } end
function modifier_target_swipe:GetModifierAttackSpeedBonus_Constant()			return 2 end
function modifier_target_swipe:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end
function modifier_target_swipe:GetEffectAttachType()		return PATTACH_OVERHEAD_FOLLOW end

custom_overpower = class({})

function custom_overpower:GetIntrinsicModifierName()				return "modifier_passive_attack_damage_count" end

modifier_passive_attack_damage_count = class({})

function modifier_passive_attack_damage_count:IsHidden() return false end
function modifier_passive_attack_damage_count:IsPurgable() return false end
function modifier_passive_attack_damage_count:AllowIllusionDuplicate() return false end
function modifier_passive_attack_damage_count:OnCreated() self:SetStackCount(1) end
function modifier_passive_attack_damage_count:DeclareFunctions() return { MODIFIER_EVENT_ON_ATTACK } end
function modifier_passive_attack_damage_count:OnAttack(kv)
	if self:GetParent():HasModifier("modifier_attack_speed_bonus") then return end 
	if kv.attacker == self:GetParent() then
		self:IncrementStackCount()
	end
end
function modifier_passive_attack_damage_count:OnStackCountChanged(iStackCount)
	if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("need_stacks") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_attack_speed_bonus", { duration = -1 })
		self:Destroy()
	end
end

modifier_attack_speed_bonus = class({})

function modifier_attack_speed_bonus:IsHidden() return false end
function modifier_attack_speed_bonus:IsPurgable() return false end
function modifier_attack_speed_bonus:DeclareFunctions() return { MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT } end
function modifier_attack_speed_bonus:OnCreated() self:SetStackCount( self:GetAbility():GetSpecialValueFor("max_attacks") ) end
function modifier_attack_speed_bonus:OnAttack(kv)
	if kv.attacker == self:GetParent() then
		self:DecrementStackCount()
	end
end
function modifier_attack_speed_bonus:OnStackCountChanged(iStackCount)
	if self:GetStackCount() < 1 then
		self:Destroy()
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_passive_attack_damage_count", { duration = -1 })
	end
end
function modifier_attack_speed_bonus:GetModifierAttackSpeedBonus_Constant()				return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end


bear_jump = class({})
function bear_jump:OnSpellStart()
	-- I'm lazy
	self.height = self:GetSpecialValueFor("height") - 350
	self.motion_duration = self:GetSpecialValueFor("motion_duration") + 0.45
	self.damage = self:GetSpecialValueFor("damage")
	self.debuff_duration = 3.4
	self.cursor = self:GetCursorPosition()
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.25)
	if not self:GetCaster():HasModifier("modifier_bear_jump_movement") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bear_jump_movement", { duration = self.motion_duration, debuff_duration = self.debuff_duration, height = self.height, damage = self.damage, x = self.cursor.x, y = self.cursor.y, z = self.cursor.z })
	end
end

modifier_bear_jump_movement = class({})

function modifier_bear_jump_movement:IsHidden() return true end
function modifier_bear_jump_movement:OnCreated( kv )
	if not IsServer() then return end

	self.height = kv.height
	self.duration = self:GetRemainingTime()
	self.debuff_duration = kv.debuff_duration
	self.x = kv.x
	self.y = kv.y
	self.damage = kv.damage
	self.endPos = GetGroundPosition(Vector(self.x, self.y,self.z), nil)
	self.startPos = self:GetParent():GetAbsOrigin()

	self.distance = ( self.startPos - self.endPos ):Length()
	self.value= 0

	self.speed = self.distance / self.duration
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	if self.distance < 20 then self:Destroy() end
	if self:GetParent():IsRooted() then return end
	if self:ApplyVerticalMotionController() == false then self:Destroy() end
	if self:ApplyHorizontalMotionController() == false then self:Destroy() end
end

local function lerp(a,b,t)
	return a + t * ( b - a )
end

-- Calculation taken from angel arena
function modifier_bear_jump_movement:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end
	if not me then return end
	if not self:GetAbility() then return end

	if not me:IsAlive() then
		self:InterruptMotionControllers(true)
		self:Destroy()
	end

	local startPos = self.startPos
	local endPos = self.endPos

	local maxLength = ( startPos - endPos ):Length()
	local newLen = min(self.value + self.speed * dt, maxLength)

	self.value = newLen

	local relativeValue = newLen / maxLength
	local newHeight = self.height * math.sin( relativeValue * math.pi )
	local newPos = lerp(startPos, endPos, relativeValue) + Vector(0,0,newHeight)

	me:SetAbsOrigin(newPos)

	if newLen == maxLength then
		self:InterruptMotionControllers(true)
		self:Destroy()
	end

	print(startPos)
	print(endPos)
	print(maxLength)
	print(newLen)
	print(self.value)
	print(relativeValue)
	print(newHeight)
	print(newPos)
end

function modifier_bear_jump_movement:OnDestroy()
	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	local earthshock = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_earthshock.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(earthshock, 1, Vector(self.radius,self.radius,0))
	EmitSoundOn("Hero_Ursa.Earthshock", self:GetParent())

	local units = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
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
		ApplyDamage({
			victim = unit,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end
	self:GetParent():FadeGesture( ACT_DOTA_CAST_ABILITY_1 )
end


modifier_bear_jump_movement.UpdateVerticalMotion = modifier_bear_jump_movement.UpdateHorizontalMotion
modifier_bear_jump_movement.OnVerticalMotionInterrupted = modifier_bear_jump_movement.OnHorizontalMotionInterrupted

function modifier_bear_jump_movement:OnHorizontalMotionInterrupted() self:Destroy() end
function modifier_bear_jump_movement:OnVerticalMotionInterrupted() self:Destroy() end
function modifier_bear_jump_movement:DeclareFunctions() return { MODIFIER_PROPERTY_DISABLE_TURNING } end
function modifier_bear_jump_movement:GetModifierDisableTurning() return 1 end