function CreepRegen
	local creep = self.creep
	self.ability = self.creep:FindAbilityByName("creep_ability_regen") or self.creep:FindAbilityByName("creep_ability_regen_super")
	self.maxRegen = creep:GetMaxHealth() * self.ability:GetSpecialValueFor("max_heal_pct") * 0.01
	self.healthPercent = self.ability:GetSpecialValueFor("bonus_health_regen") * 0.01
	self.tickTime = 0.5
	self.healthTick = creep:GetMaxHealth() * self.healthPercent * self.tickTime

	Timers:CreateTimer(self.tickTime, function()
		if not IsValidEntity(creep) or not creep:IsAlive() then return end
		
		if self.regenAmount <= self.maxRegen then
			if creep:GetHealth() > 0 and creep:GetHealth() ~= creep:GetMaxHealth() then
				self:RegenerateCreepHealth()
			end
			return self.tickTime
		else
			creep:RemoveModifierByName("creep_regen_modifier")
		end
	end)
end

function CreepRegen
	local creep = self.creep
	creep:Heal(self.healthTick, nil)
	self.regenAmount = self.regenAmount + self.healthTick
end