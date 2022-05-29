	-------------------------------------
-----        SWASHBUCKLE       ------
-------------------------------------
imba_pangolier_swashbuckle = imba_pangolier_swashbuckle or class({})
LinkLuaModifier("modifier_imba_swashbuckle_dash", "lua_abilities/imba_pangolier_swashbuckle.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_swashbuckle_slashes", "lua_abilities/imba_pangolier_swashbuckle.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pangolier_swashbuckle:GetAbilityTextureName()
   return "pangolier_swashbuckle"
end


function imba_pangolier_swashbuckle:IsHiddenWhenStolen() return false end
function imba_pangolier_swashbuckle:IsStealable() return true end
function imba_pangolier_swashbuckle:IsNetherWardStealable() return true end 

function imba_pangolier_swashbuckle:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)

    return manacost
end

function imba_pangolier_swashbuckle:GetCooldown(level)
    
    local cooldown = self.BaseClass.GetCooldown(self, level)
    local caster = self:GetCaster()
end

function imba_pangolier_swashbuckle:GetCastRange()
	return self:GetSpecialValueFor("dash_range")
end


function imba_pangolier_swashbuckle:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	return cast_point
end




function imba_pangolier_swashbuckle:OnSpellStart()
	
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local point = caster:GetCursorPosition()
    local sound_cast = "Hero_Pangolier.Swashbuckle.Cast"
    local modifier_movement = "modifier_imba_swashbuckle_dash"
    local attack_modifier = "modifier_imba_swashbuckle_slashes"
    local cast_response = {"pangolin_pangolin_ability1_01", "pangolin_pangolin_ability1_02", "pangolin_pangolin_ability1_03", "pangolin_pangolin_ability1_04", "pangolin_pangolin_ability1_05", "pangolin_pangolin_ability1_06",
						"pangolin_pangolin_ability1_07", "pangolin_pangolin_ability1_08", "pangolin_pangolin_ability1_09", "pangolin_pangolin_ability1_10", "pangolin_pangolin_ability1_11", "pangolin_pangolin_ability1_12", "pangolin_pangolin_ability1_13"}

    -- Ability specials
	local dash_range = ability:GetSpecialValueFor("dash_range")
	local range = ability:GetSpecialValueFor("range")


	
	--Cancel Rolling Thunder if he was rolling
	local rolling_thunder = "modifier_pangolier_gyroshell" --Vanilla
	--local rolling_thunder = "modifier_imba_pangolier_gyroshell_roll" --Imba
	if caster:HasModifier(rolling_thunder) then
		caster:RemoveModifierByName(rolling_thunder)
	end

	-- Turn Pangolier toward the point he will dash (fix targeting for when cast in range AND there are no nearby enemies after dash)
	local direction = (point - caster:GetAbsOrigin()):Normalized()

	caster:SetForwardVector(direction)

	-- Play cast response
    EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

    --play animation
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	
    -- Play cast sound
    EmitSoundOn(sound_cast, caster)
	
   



    --Begin moving to target point
    caster:AddNewModifier(caster, ability, modifier_movement, {})

    --Pass the targeted point to the modifier
    local modifier_movement_handler = caster:FindModifierByName(modifier_movement)
    modifier_movement_handler.target_point = point


end


--Dash movement modifier
modifier_imba_swashbuckle_dash = modifier_imba_swashbuckle_dash or class({})

function modifier_imba_swashbuckle_dash:OnCreated()
	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.attack_modifier = "modifier_imba_swashbuckle_slashes"
	self.dash_particle = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_dash.vpcf"

	--Ability specials
	self.dash_speed = self.ability:GetSpecialValueFor("dash_speed")
	self.range = self.ability:GetSpecialValueFor("range")

	if IsServer() then

		--variables
		self.time_elapsed = 0

		-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
		Timers:CreateTimer(FrameTime(), function()
			self.distance = (self.caster:GetAbsOrigin() - self.target_point):Length2D()
			self.dash_time = self.distance / self.dash_speed
			self.direction = (self.target_point - self.caster:GetAbsOrigin()):Normalized()

			--Add dash particle
			local dash = ParticleManager:CreateParticle(self.dash_particle, PATTACH_WORLDORIGIN, self.caster)
			ParticleManager:SetParticleControl(dash, 0, self.caster:GetAbsOrigin()) -- point 0: origin, point 2: sparkles, point 5: burned soil
			self:AddParticle(dash, false, false, -1, true, false)

			self.frametime = FrameTime()
			self:StartIntervalThink(self.frametime)
		end)
	end
end

--pangolier is stunned during the dash
function modifier_imba_swashbuckle_dash:CheckState()
	state = {[MODIFIER_STATE_STUNNED] = true}

	return state
end


function modifier_imba_swashbuckle_dash:IsHidden() return true end
function modifier_imba_swashbuckle_dash:IsPurgable() return false end
function modifier_imba_swashbuckle_dash:IsDebuff() return false end
function modifier_imba_swashbuckle_dash:IgnoreTenacity() return true end
function modifier_imba_swashbuckle_dash:IsMotionController() return true end
function modifier_imba_swashbuckle_dash:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_swashbuckle_dash:OnIntervalThink()

	-- Check Motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end


	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), self.frametime)


end


function modifier_imba_swashbuckle_dash:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still dashing
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.dash_time then

			-- Go forward
			local new_location = self.caster:GetAbsOrigin() + self.direction * self.dash_speed * dt
			self.caster:SetAbsOrigin(new_location)            
		else            
			self:Destroy()
		end
	end 
end










function modifier_imba_swashbuckle_dash:OnRemoved()    
	if IsServer() then
		self.caster:SetUnitOnClearGround()

		--Pangolier finished the dash: look for enemies in range starting from the nearest
   		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
										  self.caster:GetAbsOrigin(),
										  nil,
										  self.range,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
										  FIND_CLOSEST,
										  false)


   		 --Check if there is an enemy hero in range. In case there is, he will be targeted, otherwise the nearest enemy unit is targeted
		local target_unit = nil
		local target_direction = nil
		if #enemies > 0 then --In case there is no target in range, Pangolier will attack in front of him
   		 	for _,enemy in pairs(enemies) do
				target_unit = target_unit or enemy	--track the nearest unit
				if enemy:IsRealHero() then
					target_unit = enemy
					break
				end
			end
			--Turn Pangolier towards the target
			target_direction = (target_unit:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
			self.caster:SetForwardVector(target_direction)
		end



   		--plays the slash animation
   		self.caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

   		

    	--Add the attack modifier on Pangolier that will handle the slashes
    	
    	local attack_modifier_handler = self.caster:AddNewModifier(self.caster, self.ability, self.attack_modifier, {})
    	
    	--pass the target
    	attack_modifier_handler.target = target_unit
	end
end



--attack modifier: will handle the slashes
modifier_imba_swashbuckle_slashes = modifier_imba_swashbuckle_slashes or class({})

function modifier_imba_swashbuckle_slashes:OnCreated()
	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"
	self.slashing_sound = "Hero_Pangolier.Swashbuckle"
	self.hit_sound= "Hero_Pangolier.Swashbuckle.Damage"
	
	--Ability specials
	self.range = self.ability:GetSpecialValueFor("range")
	self.damage = self.ability:GetBaseDamageMax()
	self.start_radius = self.ability:GetSpecialValueFor("start_radius")
	self.end_radius = self.ability:GetSpecialValueFor("end_radius")
	self.strikes = self.ability:GetSpecialValueFor("strikes")
	self.attack_interval = self.ability:GetBaseAttackTime()

	if IsServer() then

		--variables
		self.executed_strikes = 0

		--wait one frame to acquire the target from the ability
		Timers:CreateTimer(FrameTime(), function()
			--Set the point to use for the direction. If no units were found from the ability, use Pangolier current forward vector
			local direction = nil -- needed for the particle
			if self.target then
				direction = (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
				self.fixed_target = self.caster:GetAbsOrigin() + direction * self.range -- will lock the targeting on the direction of the target on-cast
			else --no units found
				direction = self.caster:GetForwardVector():Normalized()
				self.fixed_target = self.caster:GetAbsOrigin() + direction * self.range
			end

			--play slashing particle
			local slash_particle = ParticleManager:CreateParticle(self.particle, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(slash_particle, 0, self.caster:GetAbsOrigin()) --origin of particle
			ParticleManager:SetParticleControl(slash_particle, 1, direction * self.range) --direction and range of the subparticles
            self:AddParticle(slash_particle, false, false, -1, true, false)


			--start interval thinker
			self:StartIntervalThink(self.attack_interval)
		end)

	end
end

function modifier_imba_swashbuckle_slashes:DeclareFunctions()
	local declfuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}

	return declfuncs
end


function modifier_imba_swashbuckle_slashes:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1_END
end

function modifier_imba_swashbuckle_slashes:OnIntervalThink()
	if IsServer() then
		

		--check if pangolier is done slashing
		if self.executed_strikes == self.strikes then
			
			self:Destroy()
			return nil
		end

		--plays the attack sound
  		EmitSoundOn(self.slashing_sound, self.caster)



		--Check for enemies in the direction set on cast
		local enemies = FindUnitsInLine(self.caster:GetTeamNumber(),
										 self.caster:GetAbsOrigin(),
										 self.fixed_target,
										 nil,
										 self.start_radius,
										 DOTA_UNIT_TARGET_TEAM_ENEMY,
										 DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
										 DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

		
		for _,enemy in pairs(enemies) do

			--Play damage sound effect
			EmitSoundOn(self.hit_sound, enemy)

			--can't hit Ethereal enemies
			if not enemy:IsAttackImmune() then
				--Apply the damage from the slash
				local damageTable = {victim = enemy,
               	    	    damage = self.damage,
                	        damage_type = DAMAGE_TYPE_PHYSICAL,
                      	    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                       	 	attacker = self.caster,
                       	    ability = nil
                        }



            	ApplyDamage(damageTable)
           	    --Apply on-hit effects
				self.caster:PerformAttack(enemy, true, true, true, true, false, true, true) --slashes are disguised normal attacks that never misses
			end
			
		end


		--increment the slash counter
		self.executed_strikes = self.executed_strikes + 1

	end
end

function modifier_imba_swashbuckle_slashes:CheckState()
	state = {[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_CANNOT_MISS] = true}

	return state
end