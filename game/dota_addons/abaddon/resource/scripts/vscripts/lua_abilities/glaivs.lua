----------------------------------------------------
-- Glaives of Wisdom
----------------------------------------------------
imba_silencer_glaives_of_wisdom = imba_silencer_glaives_of_wisdom or class({})

function imba_silencer_glaives_of_wisdom:GetAbilityTextureName()
   return "silencer_glaives_of_wisdom"
end

function imba_silencer_glaives_of_wisdom:IsNetherWardStealable() return false end
function imba_silencer_glaives_of_wisdom:IsStealable() return false end

function imba_silencer_glaives_of_wisdom:GetCastRange()
	return self:GetCaster():GetAttackRange()
end

function imba_silencer_glaives_of_wisdom:GetIntrinsicModifierName()
	return "modifier_imba_silencer_glaives_of_wisdom"
end

function imba_silencer_glaives_of_wisdom:OnSpellStart()
	if IsServer() then
		-- Tag the current shot as a forced one
		self.force_glaive = true

		-- Force attack the target		
		self:GetCaster():MoveToTargetToAttack(self:GetCursorTarget())

		-- Replenish mana cost (since it's spent on the OnAttack function)
		self:RefundManaCost()
	end
end

---------------------------------
-- Glaives of Wisdom intrinsic modifier for attack and particle checks
-- All credit to Shush, whose code I pilfered and adapted
---------------------------------
LinkLuaModifier("modifier_imba_silencer_glaives_of_wisdom", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_glaives_of_wisdom = modifier_imba_silencer_glaives_of_wisdom or class({})

function modifier_imba_silencer_glaives_of_wisdom:IsHidden() return true end
function modifier_imba_silencer_glaives_of_wisdom:IsPurgable() return false end
function modifier_imba_silencer_glaives_of_wisdom:IsDebuff() return false end

function modifier_imba_silencer_glaives_of_wisdom:DeclareFunctions()
	local decFunc = {MODIFIER_EVENT_ON_ATTACK_START,
					MODIFIER_EVENT_ON_ATTACK,
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_EVENT_ON_ORDER}

	return decFunc
end

function modifier_imba_silencer_glaives_of_wisdom:OnCreated()
	-- Ability properties
	self.caster = self:GetParent()
	self.ability = self:GetAbility()
	self.sound_cast = "Hero_Silencer.GlaivesOfWisdom"
	self.sound_hit = "Hero_Silencer.GlaivesOfWisdom.Damage"
	self.modifier_int_damage = "modifier_imba_silencer_glaives_int_damage"
	self.modifier_hit_counter = "modifier_imba_silencer_glaives_hit_counter"
	self.scepter_damage_multiplier = self.ability:GetSpecialValueFor("scepter_damage_multiplier")
end

function modifier_imba_silencer_glaives_of_wisdom:OnAttackStart(keys)
	if IsServer() then	
		local attacker = keys.attacker
		local target = keys.target		

		-- Do absolutely nothing if the attacker is an illusion
		if attacker:IsIllusion() then return nil end

		-- Only apply on caster's attacks
		if self.caster == attacker then						
			-- Ability specials
			self.intellect_damage_pct = self.ability:GetSpecialValueFor("intellect_damage_pct")
			self.hits_to_silence = self.ability:GetSpecialValueFor("hits_to_silence")
			self.hit_count_duration = self.ability:GetSpecialValueFor("hit_count_duration")
			self.silence_duration = self.ability:GetSpecialValueFor("silence_duration")
			self.int_reduction_pct = self.ability:GetSpecialValueFor("int_reduction_pct")
			self.int_reduction_duration = self.ability:GetSpecialValueFor("int_reduction_duration")

			-- Assume it's a frost arrow unless otherwise stated
			local glaive_attack = true

			-- Initialize attack table
			if not self.attack_table then self.attack_table = {} end

			-- Get variables
			self.auto_cast = self.ability:GetAutoCastState()
			self.current_mana = self.caster:GetMana()
			self.mana_cost = self.ability:GetManaCost(-1)			

			-- If the caster is silenced, mark attack as non-frost arrow
			if self.caster:IsSilenced() then glaive_attack = false end

			-- If the target is a building or is magic immune, mark attack as non-frost arrow
			if target:IsBuilding() then glaive_attack = false end
			
			-- If the target is magic immune, and the attacker has no scepter, mark attack as non-frost arrow
			if target:IsMagicImmune() and not attacker:HasScepter() then glaive_attack = false end

			-- If it wasn't a forced frost attack (through ability cast), or
			-- auto cast is off, change projectile to non-frost and return 
			if not self.ability.force_glaive and not self.auto_cast then								
				glaive_attack = false
			end		

			-- If there isn't enough mana to cast a Frost Arrow, assign as a non-frost arrow
			if self.current_mana < self.mana_cost then
				glaive_attack = false
			end			

			if glaive_attack then
				--mark that attack as a frost arrow							
				self.glaive_attack = true
				SetGlaiveAttackProjectile(self.caster, true)		
			else
				-- Transform back to usual projectiles
				self.glaive_attack = false
				SetGlaiveAttackProjectile(self.caster, false)
			end			
		end
	end
end

function modifier_imba_silencer_glaives_of_wisdom:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if self.caster == keys.attacker then			
				
			-- Clear instance of ability's forced frost arrow
			self.ability.force_glaive = nil						

			-- If it wasn't a frost arrow, do nothing
			if not self.glaive_attack then return nil end							

			-- Emit sound
			EmitSoundOn(self.sound_cast, self.caster)

			-- Spend mana
			self.caster:SpendMana(self.mana_cost, self.ability)			
		end
	end
end

function modifier_imba_silencer_glaives_of_wisdom:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on Silencer's attacks
		if self.caster == attacker then	

			if target:IsAlive() and self.glaive_attack then 
				local glaive_pure_damage = target:GetBaseDamageMax() * self.intellect_damage_pct / 100
				
				if attacker:HasScepter() and (target:IsSilenced() or target:HasModifier("modifier_imba_silencer_global_silence")) then
					glaive_pure_damage = glaive_pure_damage * (1 + (self.scepter_damage_multiplier * 0.01))
				end
				
				local damage_table = {
					victim = target,
					attacker = attacker,
					damage = glaive_pure_damage,
					damage_type = self.ability:GetAbilityDamageType(),
					ability = self.ability
				}

				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, glaive_pure_damage, nil)
				ApplyDamage( damage_table )
				if not target:IsAlive() then return end
				
				if target:HasModifier("modifier_imba_silencer_global_silence") then
					local global_silence_duration_increase = attacker:FindTalentValue("special_bonus_imba_silencer_5")
					if global_silence_duration_increase > 0 then
						local modifier = target:FindModifierByName("modifier_imba_silencer_global_silence")
						modifier:SetDuration(modifier:GetRemainingTime() + global_silence_duration_increase, true)
					end
				end
				
				local hit_counter = target:FindModifierByName(self.modifier_hit_counter)
				if not hit_counter then
					hit_counter = target:AddNewModifier(attacker, self.ability, self.modifier_hit_counter, {req_hits = self.hits_to_silence, silence_dur = self.silence_duration})
				end

				if hit_counter then
					hit_counter:IncrementStackCount()
					hit_counter:SetDuration(self.hit_count_duration, true)
				end
				
				if attacker:HasTalent("special_bonus_imba_silencer_6") then
					if not target:HasModifier("modifier_imba_silencer_glaives_talent_effect_procced") then
						local arcaneSupremacy = attacker:FindModifierByName("modifier_imba_silencer_arcane_supremacy")
						if arcaneSupremacy then
							local stolenInt = arcaneSupremacy:GetStackCount()
							if stolenInt > 0 then
								local talentEffectModifier = target:FindModifierByName("modifier_imba_silencer_glaives_talent_effect")
								if talentEffectModifier then
									talentEffectModifier:SetStackCount(talentEffectModifier:GetStackCount() + stolenInt)
									talentEffectModifier:SetDuration(attacker:FindTalentValue("special_bonus_imba_silencer_6", "duration"), true)
								else
									talentEffectModifier = target:AddNewModifier(attacker, self.ability, "modifier_imba_silencer_glaives_talent_effect", {duration = attacker:FindTalentValue("special_bonus_imba_silencer_6", "duration")})
									talentEffectModifier:SetStackCount(stolenInt)
								end
							end
						end
					end
				else
					local int_damage = target:FindModifierByName(self.modifier_int_damage)
					if not int_damage then
						int_damage = target:AddNewModifier(attacker, self.ability, self.modifier_int_damage, {int_reduction = self.int_reduction_pct})
					end
					
					int_damage:IncrementStackCount()
					int_damage:SetDuration(self.int_reduction_duration, true)
				end
				
				EmitSoundOn(self.sound_hit, target)
			end
		end
	end
end

function modifier_imba_silencer_glaives_of_wisdom:OnOrder(keys)
	local order_type = keys.order_type	

	-- On any order apart from attacking target, clear the forced frost arrow variable.
	if order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
		self.ability.force_glaive = nil
	end 
end

function SetGlaiveAttackProjectile(caster, is_glaive_attack)
	-- modifiers
	local skadi_modifier = "modifier_item_imba_skadi_unique"
	local deso_modifier = "modifier_item_imba_desolator_unique"	
	local morbid_modifier = "modifier_item_mask_of_death"
	local mom_modifier = "modifier_imba_mask_of_madness"
	local satanic_modifier = "modifier_item_satanic"
	local vladimir_modifier = "modifier_item_imba_vladmir"
	local vladimir_2_modifier = "modifier_item_imba_vladmir_blood"

	-- normal projectiles
	local skadi_projectile = "particles/items2_fx/skadi_projectile.vpcf"
	local deso_projectile = "particles/items_fx/desolator_projectile.vpcf"	
	local deso_skadi_projectile = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"	
	local lifesteal_projectile = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"

	-- Frost arrow projectiles
	local base_attack = "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf"
	local glaive_attack = "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
	
	local glaive_lifesteal_projectile = "particles/hero/silencer/lifesteal_glaives/silencer_lifesteal_glaives_of_wisdom.vpcf"
	local glaive_skadi_projectile = "particles/hero/silencer/skadi_glaives/silencer_skadi_glaives_of_wisdom.vpcf"
	local glaive_deso_projectile = "particles/hero/silencer/deso_glaives/silencer_deso_glaives_of_wisdom.vpcf"
	local glaive_deso_skadi_projectile = "particles/hero/silencer/deso_skadi_glaives/silencer_deso_skadi_glaives_of_wisdom.vpcf"
	local glaive_lifesteal_skadi_projectile = "particles/hero/silencer/lifesteal_skadi_glaives/silencer_lifesteal_skadi_glaives_of_wisdom.vpcf"
	local glaive_lifesteal_deso_projectile = "particles/hero/silencer/lifesteal_deso_glaives/silencer_lifesteal_deso_glaives_of_wisdom.vpcf"
	local glaive_lifesteal_deso_skadi_projectile = "particles/hero/silencer/lifesteal_deso_skadi_glaives/silencer_lifesteal_deso_skadi_glaives_of_wisdom.vpcf"

	-- Set variables
	local has_lifesteal
	local has_skadi
	local has_desolator

	-- Assign variables
	-- Lifesteal
	if caster:HasModifier(morbid_modifier) or caster:HasModifier(mom_modifier) or caster:HasModifier(satanic_modifier) or caster:HasModifier(vladimir_modifier) or caster:HasModifier(vladimir_2_modifier) then
		has_lifesteal = true
	end

	-- Skadi
	if caster:HasModifier(skadi_modifier) then
		has_skadi = true
	end

	-- Desolator
	if caster:HasModifier(deso_modifier) then
		has_desolator = true
	end

	-- ASSIGN PARTICLES
	-- Frost attack
	if is_glaive_attack then
		-- Desolator + lifesteal + frost + skadi (doesn't exists yet)
		if has_desolator and has_skadi and has_lifesteal then
			caster:SetRangedProjectileName(glaive_lifesteal_deso_skadi_projectile)

		-- Desolator + lifesteal + frost
		elseif has_desolator and has_lifesteal then
			caster:SetRangedProjectileName(glaive_lifesteal_deso_projectile)

		-- Desolator + skadi + frost 
		elseif has_skadi and has_desolator then
			caster:SetRangedProjectileName(glaive_deso_skadi_projectile)

		-- Lifesteal + skadi + frost 
		elseif has_lifesteal and has_skadi then
			caster:SetRangedProjectileName(glaive_lifesteal_skadi_projectile)

		-- skadi + frost
		elseif has_skadi then
			caster:SetRangedProjectileName(glaive_skadi_projectile)

		-- lifesteal + frost
		elseif has_lifesteal then
			caster:SetRangedProjectileName(glaive_lifesteal_projectile)

		-- Desolator + frost			
		elseif has_desolator then
			caster:SetRangedProjectileName(glaive_deso_projectile)
			return

		-- Frost
		else
			caster:SetRangedProjectileName(glaive_attack)
			return
		end
	
	else -- Non frost attack
		-- Skadi + desolator
		if has_skadi and has_desolator then
			caster:SetRangedProjectileName(deso_skadi_projectile)
			return

		-- Skadi
		elseif has_skadi then
			caster:SetRangedProjectileName(skadi_projectile)

		-- Desolator
		elseif has_desolator then
			caster:SetRangedProjectileName(deso_projectile)
			return 

		 Lifesteal
		elseif has_lifesteal then
			caster:SetRangedProjectileName(lifesteal_projectile)

		-- Basic arrow
		else
			caster:SetRangedProjectileName(base_attack)
			return 
		end
	end
end