modifier_huskar_poison_milk_buff = class({})

function modifier_huskar_poison_milk_buff:IsPurgable()
	return false
end

function modifier_huskar_poison_milk_buff:DeclareFunctions()
	return {MODIFIER_EVENT_ON_HEAL_RECEIVED}
end

function modifier_huskar_poison_milk_buff:IsDebuff()
	if self:GetParent() == self:GetCaster() then
		return false
	end
	return true
end

function modifier_huskar_poison_milk_buff:OnDestroy()
	if self:GetParent() ~= self:GetAbility():GetCaster() then
		self:GetAbility():GetCaster().__hPoisonMilkTarget = nil
	end
end

function modifier_huskar_poison_milk_buff:OnCreated(kv)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local owner = self:GetParent()
		if owner ~= caster then
			caster.__hPoisonMilkTarget = owner


			-- 添加粒子特效
			local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_poison_milk.vpcf",PATTACH_ABSORIGIN_FOLLOW,owner)
			ParticleManager:SetParticleControlEnt(pid,0,owner,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",owner:GetAbsOrigin(),true)
			self:AddParticle(pid,true,false,0,true,false)

			EmitSoundOn("Hero_Huskar.Inner_Vitality",owner)
		end
	end
end

function modifier_huskar_poison_milk_buff:OnHealReceived(keys)
	if IsServer() then
		local owner = self:GetParent()
		local healer = keys.unit
		local gain = keys.gain

		if gain < 10 then return end

		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local percentage = ability:GetSpecialValueFor("damage_percentage") / 100

		if caster.__hPoisonMilkTarget == nil and owner ~= caster then
			caster.__hPoisonMilkTarget = owner
		end

		if caster.__hPoisonMilkTarget ~= nil then
			ApplyDamage({
				attacker = caster,
				victim = caster.__hPoisonMilkTarget,
				damage_type = ability:GetAbilityDamageType(),
				damage = gain * percentage,
			})
		end
	end
end