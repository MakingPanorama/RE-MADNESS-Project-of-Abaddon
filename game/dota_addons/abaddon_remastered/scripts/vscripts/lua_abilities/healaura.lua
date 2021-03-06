imba_tower_healing_tower = imba_tower_healing_tower or class({})
LinkLuaModifier("modifier_tower_healing_think", "lua_abilities/healaura", LUA_MODIFIER_MOTION_NONE)

function imba_tower_healing_tower:GetIntrinsicModifierName()
	return "modifier_tower_healing_think"
end

function imba_tower_healing_tower:GetAbilityTextureName()
	return "custom/tower_healing_wave"
end

modifier_tower_healing_think = modifier_tower_healing_think or class({})

function modifier_tower_healing_think:OnCreated()
	if IsServer() then
		-- Ability properties
		if not self:GetAbility() then
			self:Destroy()
			return nil
		end
		self.particle_heal = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf"

		-- Ability specials
		self.search_radius = self:GetAbility():GetSpecialValueFor("search_radius")
		self.bounce_delay = self:GetAbility():GetSpecialValueFor("bounce_delay")
		self.hp_threshold = self:GetAbility():GetSpecialValueFor("hp_threshold")
		self.bounce_radius = self:GetAbility():GetSpecialValueFor("bounce_radius")

		self:StartIntervalThink(0.2)
	end
end

function modifier_tower_healing_think:OnRefresh()
	self:OnCreated()
end

function modifier_tower_healing_think:OnIntervalThink()
	if IsServer() then

		-- If ability is on cooldown, do nothing
		if not self:GetAbility():IsCooldownReady() then
			return nil
		end

		-- Set variables
		local healing_in_process = false
		local current_healed_hero

		-- Clear heroes healed marker
		local heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			25000, --global
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _, hero in pairs(heroes) do
			hero.healed_by_healing_wave = false
		end

		-- Look for heroes that need healing
		heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.search_radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Find at least one hero that needs healing, and heal him
		for _, hero in pairs(heroes) do
			local hero_hp_percent = hero:GetHealthPercent()
			if hero_hp_percent <= self.hp_threshold then
				current_healed_hero = hero
				HealingWaveBounce(self:GetParent(), self:GetParent(), self:GetAbility(), hero)
				self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(-1))
				break
			end
		end

		-- If no hero was found that needed healing, do nothing
		if not current_healed_hero then
			return nil
		end

		-- Start bouncing with bounce delay
		Timers:CreateTimer(self.bounce_delay, function()
			-- If those are null then the tower most likely died during self.bounce_delay... 
			if self == nil then return nil end
			if not self:GetParent() or not self.bounce_radius or not self:GetAbility() then 
				return nil
			end
			-- Still don't know if other heroes need healing, assumes doesn't unless found
			local heroes_need_healing = false

			-- Look for other heroes nearby, regardless of if they need healing
			heroes = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),
				current_healed_hero:GetAbsOrigin(),
				nil,
				self.bounce_radius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			-- Search for a hero
			for _, hero in pairs(heroes) do
				if not hero.healed_by_healing_wave and current_healed_hero ~= hero then
					heroes_need_healing = true
					HealingWaveBounce(self:GetParent(), current_healed_hero, self:GetAbility(), hero)
					current_healed_hero = hero
					break
				end
			end

			-- If a hero was found, there might be more: repeat operation
			if heroes_need_healing then
				return bounce_delay
			else
				return nil
			end
		end)
	end
end

function HealingWaveBounce(caster, source, ability, hero)
	local sound_cast = "Greevil.Shadow_Wave"
	local particle_heal = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf"
	local heal_amount = ability:GetSpecialValueFor("heal_amount")

	-- Mark hero as healed
	hero.healed_by_healing_wave = true

	-- Apply particle effect
	local particle_heal_fx = ParticleManager:CreateParticle(particle_heal, PATTACH_ABSORIGIN, source)
	ParticleManager:SetParticleControl(particle_heal_fx, 0, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 1, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 3, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 4, source:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_heal_fx)

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Heal target
	hero:Heal(heal_amount * 10 / 100, caster)

	-- dispel
	hero:Purge(false, true, false, true, false)
end

function modifier_tower_healing_think:IsHidden()
	return true
end

function modifier_tower_healing_think:IsPurgable()
	return false
end