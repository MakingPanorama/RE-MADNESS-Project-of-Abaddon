modifier_venomancer_poison_sting_debuff = class({})

function modifier_venomancer_poison_sting_debuff:IsHidden()
	return false
end

function modifier_venomancer_poison_sting_debuff:IsPurgable()
	return false
end

function modifier_venomancer_poison_sting_debuff:IsDebuff()
	return true
end

function modifier_venomancer_poison_sting_debuff:DeclareFunctions()
	return {MODIFIER_EVENT_ON_UNIT_MOVED}
end

function modifier_venomancer_poison_sting_debuff:OnCreated(kv)
	if IsServer() then
		local ability = self:GetAbility()
		local damage_interval = ability:GetSpecialValueFor("damage_interval")
		self.flDamagePerStack = ability:GetSpecialValueFor("damage_per_stack")
		self:StartIntervalThink(damage_interval)

		local parent = self:GetParent()
		local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf",PATTACH_ABSORIGIN_FOLLOW,parent)
		ParticleManager:SetParticleControlEnt(pid,0,parent,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",parent:GetOrigin(),true)
		self:AddParticle(pid,true,false,0,true,false)

		-- local stack = kv.StackCount
		-- local pid_counter = ParticleManager:CreateParticle("particles/veno/veno_poison_sting_counter.vpcf",PATTACH_OVERHEAD_FOLLOW,parent)
		-- ParticleManager:SetParticleControlEnt(pid_counter,
		-- 	0,parent,PATTACH_OVERHEAD_FOLLOW,"follow_overhead",parent:GetOrigin(),true)
		-- local stack_v = Vector(
		-- 	math.floor(stack / 10),
		-- 	stack - (math.floor(stack / 10)) * 10,
		-- 	0
		-- )
		-- print(stack_v)
		-- ParticleManager:SetParticleControl(pid_counter,1,stack_v)
		-- self:AddParticle(pid_counter,true,false,0,true,false)
	end
end

function modifier_venomancer_poison_sting_debuff:OnRefresh(kv)
	if IsServer() then
		-- local parent = self:GetParent()
		-- local stack = kv.StackCount
		-- local pid_counter = ParticleManager:CreateParticle("particles/veno/veno_poison_sting_counter.vpcf",PATTACH_OVERHEAD_FOLLOW,parent)
		-- ParticleManager:SetParticleControlEnt(pid_counter,
		-- 	0,parent,PATTACH_OVERHEAD_FOLLOW,"follow_overhead",parent:GetOrigin() + Vector(0,0,100),true)
		-- local stack_v = Vector(
		-- 	math.floor(stack / 10),
		-- 	stack - (math.floor(stack / 10)) * 10,
		-- 	0
		-- )
		-- print(stack_v)
		-- ParticleManager:SetParticleControl(pid_counter,1,stack_v)
		-- self:AddParticle(pid_counter,true,false,0,true,false)
	end
end

function modifier_venomancer_poison_sting_debuff:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local attacker = self:GetCaster()
		local victim = self:GetParent()
		local damage = self:GetStackCount() * self.flDamagePerStack
		ApplyDamage({
			attacker = attacker,
			victim = victim,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		})	
	end
end

function modifier_venomancer_poison_sting_debuff:OnUnitMoved(kv)
	if IsServer() then
 		local parent = self:GetParent()
		if kv.unit == parent then
			-- 计算移动过的距离
			if parent.flTotalMovedDistance == nil then parent.flTotalMovedDistance = 0 end

			if parent.vLastPosition == nil then parent.vLastPosition = parent:GetOrigin() end

			local pos = parent:GetOrigin()
			local distance = (pos - parent.vLastPosition):Length2D()

			if distance > self:GetAbility():GetSpecialValueFor("move_length_for_stack") then
				parent.vLastPosition = pos

				parent:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_venomancer_poison_sting_debuff",{Duration = self:GetAbility():GetSpecialValueFor("duration")})
				local stack = self:GetStackCount() + 1
				if stack > self:GetAbility():GetSpecialValueFor("max_stacks") * 2 then
					parent:SetModifierStackCount("modifier_venomancer_poison_sting_debuff",self:GetCaster(), stack)
				end
			end
		end
	end
end
