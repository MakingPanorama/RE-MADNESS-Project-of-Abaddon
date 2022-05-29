--------------------------------
--         HEADSHOT           --
--------------------------------
item_imba_sniper_headshot = class({})
LinkLuaModifier("modifier_imba_headshot_attacks", "lua_abilities/head_shot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headshot_slow", "lua_abilities/head_shot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_perfectshot_stun", "lua_abilities/head_shot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headshot_eyeshot", "lua_abilities/head_shot.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_sniper_headshot:GetAbilityTextureName()
	return "sniper_headshot"
end

function item_imba_sniper_headshot:GetIntrinsicModifierName()
	return "modifier_imba_headshot_attacks"
end

function item_imba_sniper_headshot:IsHiddenWhenStolen()
	return true
end

-- Attacks counter
modifier_imba_headshot_attacks = class({})

function modifier_imba_headshot_attacks:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.modifier_headshot_counter = "modifier_imba_headshot_counter"
		self.modifier_imba_headshot_slow = "modifier_imba_headshot_slow"
		self.modifier_imba_perfectshot_stun = "modifier_imba_perfectshot_stun"
		self.ability_aim = "imba_sniper_take_aim"

		-- Ability specials
		self.headshot_attacks = self.ability:GetSpecialValueFor("headshot_attacks")
		self.headshot_damage = self.ability:GetSpecialValueFor("headshot_damage")
		self.headshot_duration = self.ability:GetSpecialValueFor("headshot_duration")
		self.perfectshot_critical_dmg_pct = self.ability:GetSpecialValueFor("perfectshot_critical_dmg_pct")
		self.perfectshot_stun_duration = self.ability:GetSpecialValueFor("perfectshot_stun_duration")
		self.perfectshot_attacks = self.ability:GetSpecialValueFor("perfectshot_attacks")
		self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
		self.knockback_distance = self.ability:GetSpecialValueFor("knockback_distance")
		self.knockback_duration = self.ability:GetSpecialValueFor("knockback_duration")
		
		self.proc_chance_pseudo		= self.proc_chance_pseudo or 0
		self.PRNG_forty_pct_chance	= 20.20	-- Change this number if you change the headshot proc chance

		-- Illusion crash fix
		if self:GetAbility():GetLevel() ~= 0 then
			-- Set stack count at 1
			self:SetStackCount(1)
		end
		
		-- Seriously why does this modifier use so many god damn variables
		self.attacks = self.attacks or 0
	end
end

function modifier_imba_headshot_attacks:OnRefresh()
	self:OnCreated()
end

function modifier_imba_headshot_attacks:IsHidden() return true end
function modifier_imba_headshot_attacks:IsPurgable() return false end
function modifier_imba_headshot_attacks:IsDebuff() return false end

function modifier_imba_headshot_attacks:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
	return decFuncs
end

function modifier_imba_headshot_attacks:OnAttackStart(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		local stacks = self:GetStackCount()

		-- Only apply on caster's attacks
		if attacker == self.caster then

			-- If headshot is stolen, reset stacks to 1 over and over so it can't proc
			if self.ability:IsStolen() then
				self:SetStackCount(1)
			end

			-- Clear all marks, to start in a state of a new shot
			self:ClearAllMarks()
			self.increment_stacks = true

			-- If caster is broken or an illusion, do nothing
			if self.caster:PassivesDisabled() or self.caster:IsIllusion() then
				self.increment_stacks = false
				return nil
			end

			-- If the target is a buidling, do nothing
			if target and target:IsBuilding() or target:IsOther() or target:GetTeamNumber() == self:GetParent():GetTeamNumber() then
				return nil
			end
			
			-- Why was there no proc chance thing implemented for like the longest time...anyways gonna simulate pseudo-random here since the base function is already taken by the perfectshot one below
			-- if (RollPercentage(self.proc_chance_pseudo + self.PRNG_forty_pct_chance)) then
				-- -- #5 Talent: Normal headshots have a chance to become Perfectshots
				-- if self.caster:HasTalent("special_bonus_imba_sniper_5") and RollPseudoRandom(self.caster:FindTalentValue("special_bonus_imba_sniper_5"), self) then
					-- self:ApplyAllMarks()
				-- else
					-- self:ApplyHeadshotMarks()
				-- end	

				-- self.proc_chance_pseudo = 0
			-- else
				-- self.proc_chance_pseudo = self.proc_chance_pseudo + self.PRNG_forty_pct_chance
			-- end

			-- Decide if this attack should be a perfectshot
			if stacks % self.perfectshot_attacks == 0 then
				self:ApplyAllMarks()
				self.increment_stacks = true
			end

			-- Take Aim guaranteed Perfectshot
			if self.caster:HasAbility(self.ability_aim) and self.caster:IsRealHero() then
				local ability_aim_handler = self.caster:FindAbilityByName(self.ability_aim)

				-- Check if Take Aim was found and is learned
				if ability_aim_handler and ability_aim_handler:GetLevel() > 0 then

					-- Check if the Take Aim is ready to be shot
					local modifier_aim_stacks
					local modifier_aim_handler = self.caster:FindModifierByName("modifier_imba_take_aim_range")

					if modifier_aim_handler then
						modifier_aim_stacks = modifier_aim_handler:GetStackCount()
					end

					if modifier_aim_handler and modifier_aim_stacks == 0 then

						-- Proc a Perfect Shot, but do not count a stack
						self:ApplyAllMarks(true)
						self.increment_stacks = false
					end
				end
			end
		end
	end
end

function modifier_imba_headshot_attacks:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if attacker == self.caster and not target:IsBuilding() and not target:IsOther() and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then

			-- Increment stack count as soon as the attack fires
			if self.increment_stacks then
				self:IncrementStackCount()
			end

			-- Apply the relevant stats for the attack that is flying towards the enemy
			if self.enable_headshot_bonus_damage then
				self.attack_headshot_slow = true
			end

			if self.enable_critical_damage then
				self.attack_perfectshot_stun = true
			end

			-- A moment after the attack is fired, reset attack marks (so next shots wouldn't benefit from them)
			Timers:CreateTimer(FrameTime(), function()
				self:ClearAllMarks()
			end)

			-- Clear forced mark
			local modifier_aim_handler = self.caster:FindModifierByName("modifier_imba_take_aim_range")

			if modifier_aim_handler then
				modifier_aim_handler.forced_aimed_assault = nil
			end
		end
	end
end

function modifier_imba_headshot_attacks:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if attacker == self.caster and not keys.no_attack_cooldown and not target:IsBuilding() and not target:IsOther() and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			self.attacks = self.attacks + 1
			
			-- If target is magic immune, we won't get any headshot or perfectshot, because fuck logic
			if target:IsMagicImmune() then
				if self.attacks > self.perfectshot_attacks then
					self.attacks = 0
				end
				
				return nil
			end

			-- If a Perfectshot is marked, headshot and stun the target
			-- if self.attack_perfectshot_stun then
			if self.attacks > self.perfectshot_attacks then
				target:AddNewModifier(self.caster, self.ability, self.modifier_imba_headshot_slow, {duration = self.headshot_duration})
				target:AddNewModifier(self.caster, self.ability, self.modifier_imba_perfectshot_stun, {duration = self.perfectshot_stun_duration})

				-- Knocknback enemy
				local knockback = {
					center_x = self.caster:GetAbsOrigin()[1]+1,
					center_y = self.caster:GetAbsOrigin()[2]+1,
					center_z = self.caster:GetAbsOrigin()[3],
					duration = self.knockback_duration,
					knockback_duration = self.knockback_duration,
					knockback_distance = self.knockback_distance,
					knockback_height = 0,
					should_stun = 0
				}

				local knockback_modifier = target:AddNewModifier(self.caster, self.ability, "modifier_knockback", knockback)

				if knockback_modifier then
					knockback_modifier:SetDuration(self.knockback_duration * (1 - target:GetStatusResistance()), true)
				end

				if self.attacks > self.perfectshot_attacks then
					self.attacks = 0
				end

				-- Not a Perfectshot, but might be a Headshot
			elseif RollPseudoRandom(self.proc_chance, self) then
				target:AddNewModifier(self.caster, self.ability, self.modifier_imba_headshot_slow, {duration = self.headshot_duration})

				-- Knocknback enemy
				local knockback = {
					center_x = self.caster:GetAbsOrigin()[1]+1,
					center_y = self.caster:GetAbsOrigin()[2]+1,
					center_z = self.caster:GetAbsOrigin()[3],
					duration = self.knockback_duration,
					knockback_duration = self.knockback_duration,
					knockback_distance = self.knockback_distance,
					knockback_height = 0,
					should_stun = 0
				}

				local knockback_modifier = target:AddNewModifier(self.caster, self.ability, "modifier_knockback", knockback)

				if knockback_modifier then
					knockback_modifier:SetDuration(self.knockback_duration * (1 - target:GetStatusResistance()), true)
				end
			end

			-- #7 Talent: Take Aim's Aimed Assaults cause the target to bleed and lose vision
			if self.caster:HasTalent("special_bonus_imba_sniper_7") and self.aimed_assault and target:GetTeamNumber() ~= self.caster:GetTeamNumber() then
				local eyeshot_duration = self.caster:FindTalentValue("special_bonus_imba_sniper_7", "duration")
				target:AddNewModifier(self.caster, self.ability, "modifier_imba_headshot_eyeshot", {duration = eyeshot_duration})
			end
		end
	end
end

function modifier_imba_headshot_attacks:OnAttackFinished(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if attacker == self.caster then
			-- No matter what happened, clear stats in the next frame
			Timers:CreateTimer(FrameTime(), function()
				self.attack_perfectshot_stun = false
				self.attack_headshot_slow = false

				-- Clear Aimed Assault, in case it's marked
				self.aimed_assault = false
			end)
		end
	end
end

function modifier_imba_headshot_attacks:ApplyHeadshotMarks()
	-- Apply marks associated with headshots
	self.enable_headshot_bonus_damage = true
end

function modifier_imba_headshot_attacks:ApplyAllMarks(aimed_assault)
	-- Apply marks
	self.enable_headshot_bonus_damage = true
	self.enable_critical_damage = true

	if aimed_assault then
		self.aimed_assault = true
	end

	-- Set the projectile to be used
	self.caster:SetRangedProjectileName("particles/units/heroes/hero_sniper/sniper_assassinate.vpcf")
end

function modifier_imba_headshot_attacks:ClearAllMarks()
	-- Clear all marks
	self.enable_headshot_bonus_damage = false
	self.enable_critical_damage = false

	if not self.ability:IsStolen() then
		-- Clear projectile
		self.caster:SetRangedProjectileName("particles/units/heroes/hero_sniper/sniper_base_attack.vpcf")
	else
		-- Retrieve Rubick's projectile in case of stolen spell
		self.caster:SetRangedProjectileName("particles/units/heroes/hero_rubick/rubick_base_attack.vpcf")
	end
end

function modifier_imba_headshot_attacks:GetModifierPreAttack_BonusDamage()
	if IsServer() then
		-- Only apply if the next shot is going to be a headshot
		if self.enable_headshot_bonus_damage then
			return self.headshot_damage
		end

		return false
	end
end

function modifier_imba_headshot_attacks:GetModifierPreAttack_CriticalStrike()
	if IsServer() then
		-- Only apply if the next shot is going to be a perfect shot
		if self.enable_critical_damage then
			return self.perfectshot_critical_dmg_pct
		end
	end
end

function modifier_imba_headshot_attacks:OnStackCountChanged(old_stack_count)
	if IsServer() then
		-- If we're past the perfect shot count, reset stacks
		if old_stack_count >= self.perfectshot_attacks then
			self:SetStackCount(1)
		end
	end
end

-- Headshot slow modifier
modifier_imba_headshot_slow = class({})

function modifier_imba_headshot_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.headshot_ms_slow_pct = self.ability:GetSpecialValueFor("headshot_ms_slow_pct")
	self.headshot_as_slow = self.ability:GetSpecialValueFor("headshot_as_slow")
	
	if not IsServer() then return end
	
	-- Add Headshot particle effects
	local particle_slow_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_slow_fx, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(particle_slow_fx, false, false, -1, false, true)
end

function modifier_imba_headshot_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_headshot_slow:GetModifierAttackSpeedBonus_Constant()
	return self.headshot_as_slow * (-1)
end

function modifier_imba_headshot_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.headshot_ms_slow_pct * (-1)
end

function modifier_imba_headshot_slow:IsHidden() return false end
function modifier_imba_headshot_slow:IsPurgable() return true end
function modifier_imba_headshot_slow:IsDebuff() return true end


-- Perfectshot stun modifier
modifier_imba_perfectshot_stun = class({})

function modifier_imba_perfectshot_stun:OnCreated()
	-- Ability properties
	self.ability = self:GetAbility()

	-- Ability specials
	self.perfectshot_stun_duration = self.ability:GetSpecialValueFor("perfectshot_stun_duration")
	
	if not IsServer() then return end
	
	-- Add Perfectshot particle effects
	local particle_stun_fx = ParticleManager:CreateParticle("particles/hero/sniper/perfectshot_stun.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_stun_fx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_stun_fx, 1, self:GetParent():GetAbsOrigin())
	self:AddParticle(particle_stun_fx, false, false, -1, false, true)
end

function modifier_imba_perfectshot_stun:CheckState()
	local state
	-- Get remaining time, compare it to how long the stun is supposed to go on
	local time_remaining = self:GetRemainingTime()
	local modifier_duration = self:GetDuration()

	if self.perfectshot_stun_duration and (modifier_duration - time_remaining) > self.perfectshot_stun_duration then
		state = nil
	else
		state = {[MODIFIER_STATE_STUNNED] = true}
	end

	return state
end

function modifier_imba_perfectshot_stun:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_perfectshot_stun:IsHidden() return false end
function modifier_imba_perfectshot_stun:IsPurgeException() return true end
function modifier_imba_perfectshot_stun:IsStunDebuff() return true end


modifier_imba_headshot_eyeshot = modifier_imba_headshot_eyeshot or class({})

function modifier_imba_headshot_eyeshot:IsHidden() return false end
function modifier_imba_headshot_eyeshot:IsPurgable() return true end
function modifier_imba_headshot_eyeshot:IsDebuff() return true end

function modifier_imba_headshot_eyeshot:OnCreated()
	-- Talent properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Talent specials
	self.damage_per_second = self.caster:FindTalentValue("special_bonus_imba_sniper_7", "damage_per_second")
	self.vision_loss = self.caster:FindTalentValue("special_bonus_imba_sniper_7", "vision_loss")
	self.damage_interval = self.caster:FindTalentValue("special_bonus_imba_sniper_7", "damage_interval")

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_headshot_eyeshot:OnIntervalThink()
	local damage = self.damage_per_second * self.damage_interval

	-- Deal damage to the parent
	local damageTable = {victim = self.parent,
		attacker = self.caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability
	}

	local actual_damage = ApplyDamage(damageTable)

	-- Show bleed notification
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, self.parent, actual_damage, nil)
end

function modifier_imba_headshot_eyeshot:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION}

	return decFuncs
end

function modifier_imba_headshot_eyeshot:GetBonusDayVision()
	return self.vision_loss * (-1)
end

function modifier_imba_headshot_eyeshot:GetBonusNightVision()
	return self.vision_loss * (-1)
end