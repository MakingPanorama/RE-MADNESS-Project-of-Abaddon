-------------------------------------------
--			STARFURY
-------------------------------------------
LinkLuaModifier("modifier_imba_starfury_passive", "lua_abilities/imba_starfury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_starfury_buff_increase", "lua_abilities/imba_starfury.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
imba_starfury = imba_starfury or class({})
-------------------------------------------
function imba_starfury:GetIntrinsicModifierName()
	return "modifier_imba_starfury_passive"
end

-------------------------------------------
modifier_imba_starfury_passive = modifier_imba_starfury_passive or class({})
function modifier_imba_starfury_passive:IsDebuff() return false end
function modifier_imba_starfury_passive:IsHidden() return true end
function modifier_imba_starfury_passive:IsPermanent() return true end
function modifier_imba_starfury_passive:IsPurgable() return false end
function modifier_imba_starfury_passive:IsPurgeException() return false end
function modifier_imba_starfury_passive:IsStunDebuff() return false end
function modifier_imba_starfury_passive:RemoveOnDeath() return false end
function modifier_imba_starfury_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_starfury_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_starfury_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_agi = self.item:GetSpecialValueFor("bonus_agi")
		self.range = self.item:GetSpecialValueFor("range")
		self.proc_chance = self.item:GetSpecialValueFor("proc_chance")
		self.proc_duration = self.item:GetSpecialValueFor("proc_duration")
		self.projectile_speed = self.item:GetSpecialValueFor("projectile_speed")
		self.agility_pct = self.item:GetSpecialValueFor("agility_pct") * 0.01
		self:CheckUnique(true)
	end
end

function modifier_imba_starfury_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_EVENT_ON_ATTACK_FAIL,
		}
	return decFuns
end

function modifier_imba_starfury_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_starfury_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_starfury_passive:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_imba_starfury_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self.parent then

			if (RollPseudoRandom(self.proc_chance, self.item) and (self:CheckUniqueValue(1,{}) == 1) and (self.parent:IsClone() or self.parent:IsRealHero())) then
				self.parent:AddNewModifier(self.parent, self.item, "modifier_imba_starfury_buff_increase", {duration = self.proc_duration})
			end
			if self.item:IsCooldownReady() and (self:CheckUniqueValue(1,{}) == 1) then
				target_loc = params.target:GetAbsOrigin()
				StartSoundEventFromPosition("Ability.StarfallImpact", target_loc)
				local damage = self.parent:GetAgility() * self.agility_pct
				local damage_type = DAMAGE_TYPE_PHYSICAL
				if self.parent:HasItemInInventory("item_imba_spell_fencer") then
					damage_type = DAMAGE_TYPE_MAGICAL
				end
				local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), target_loc, nil, self.range, self.item:GetAbilityTargetTeam(), self.item:GetAbilityTargetType(), self.item:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
				-- If enemies found, start cooldown
				local bFound = false
				for _, enemy in pairs(enemies) do
					if enemy ~= params.target then
						local damager = self.parent
						projectile = {
							hTarget = enemy,
							hCaster = damager,
							vColor = self.parent:GetFittingColor(),
							vColor2 = self.parent:GetHeroColorSecondary(),
							hAbility = self.ability,
							iMoveSpeed = self.projectile_speed,
							EffectName = "particles/item/starfury/starfury_projectile.vpcf",
							flRadius = 1,
							bDodgeable = true,
							bDestroyOnDodge = true,
							vSpawnOrigin = target_loc,
							OnProjectileHitUnit = function(params, projectileID)
								params.damage = damage
								params.damage_type = damage_type
								ProjectileHit(params, projectileID, self)
							end,
						}
						TrackingProjectiles:Projectile(projectile)
						if not bFound then
							bFound = true
							self.item:UseResources(false, false, true)
						end
					end
				end
			end
		end
	end
end

function modifier_imba_starfury_passive:OnAttackFail(params)
	self:OnAttackLanded(params)
end

-------------------------------------------
modifier_imba_starfury_buff_increase = modifier_imba_starfury_buff_increase or class({})
function modifier_imba_starfury_buff_increase:IsDebuff() return false end
function modifier_imba_starfury_buff_increase:IsHidden() return false end
function modifier_imba_starfury_buff_increase:IsPurgable() return true end
function modifier_imba_starfury_buff_increase:IsStunDebuff() return false end
function modifier_imba_starfury_buff_increase:RemoveOnDeath() return true end
-------------------------------------------
function modifier_imba_starfury_buff_increase:OnCreated()
	local hItem = self:GetAbility()
	local hParent = self:GetParent()
	if hItem and hParent and IsServer() then
		local agility = hParent:GetAgility()
		self:SetStackCount(hItem:GetSpecialValueFor("proc_bonus") * 1)
	end
end

function modifier_imba_starfury_buff_increase:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
	return decFuns
end

function modifier_imba_starfury_buff_increase:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

function ProjectileHit(params, projectileID, modifier)
	-- Perform an instant attack on hit enemy
	ApplyDamage({attacker = params.hCaster, victim = params.hTarget, ability = nil, damage = params.damage, damage_type = params.damage_type, damage_flags = DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS})
end
