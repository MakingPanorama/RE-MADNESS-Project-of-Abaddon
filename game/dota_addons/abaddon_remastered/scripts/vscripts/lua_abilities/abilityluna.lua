function OnLuna01Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()

	OnLuna01Damage(keys,target,0.8)
	
	local targets = THTD_FindUnitsInRadius(caster,targetPoint,1000)

	if targets[1]~=nil then
		OnLuna01Damage(keys,targets[1],1.6)
	end

	if targets[2]~=nil then
		OnLuna01Damage(keys,targets[2],1.6)
	end

	local hero = caster:GetOwner()
	if hero~=nil and hero:IsNull()==false then
		local centerList = GetFairyAreaCenterAndRadiusList(hero)
		local targetsTotal = {}
		for index,centerTable in pairs(centerList) do
			local targets = THTD_FindUnitsInRadius(caster,centerTable.center,centerTable.radius)

			for k,v in pairs(targets) do
				if v~=nil and v:IsNull()==false and v:IsAlive() and IsUnitInFairyArea(hero,v) then
					targetsTotal[v:GetEntityIndex()] = v
				end
			end
		end
		for k,v in pairs(targetsTotal) do
			OnLuna01Damage(keys,v,1.6)
		end
	end
end

function OnLuna01Damage(keys,target,percentage)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local effectIndex = ParticleManager:CreateParticle("particles\custom\ability_luna_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 5, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local DamageTable = {
		ability = keys.ability,
        victim = target, 
        attacker = caster, 
        damage = caster:THTD_GetStar() * caster:THTD_GetPower() * percentage, 
        damage_type = keys.ability:GetAbilityDamageType(), 
        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end

local thtd_luna_02_bonus_table = 
{
	[3] = 100,
	[4] = 250,
	[5] = 500,
}

function OnLuna02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local foward = (targetPoint - caster:GetAbsOrigin()):Normalized()

	local targets = 
		FindUnitsInLine(
			caster:GetTeamNumber(), 
			caster:GetOrigin(), 
			caster:GetOrigin() + foward*1000, 
			nil, 
			200,
			keys.ability:GetAbilityTargetTeam(), 
			keys.ability:GetAbilityTargetType(), 
			keys.ability:GetAbilityTargetFlags()
		)

	local hero = caster:GetOwner()
	if hero~=nil and hero:IsNull()==false then
		local centerList = GetFairyAreaCenterAndRadiusList(hero)
		local targetsTotal = {}
		for index,centerTable in pairs(centerList) do
			local areatargets = THTD_FindUnitsInRadius(caster,centerTable.center,centerTable.radius)

			for k,v in pairs(areatargets) do
				if v~=nil and v:IsNull()==false and v:IsAlive() and IsUnitInFairyArea(hero,v) then
					targetsTotal[v:GetEntityIndex()] = v
				end
			end
		end
		for k,v in pairs(targetsTotal) do
			table.insert(targets,v)
		end
	end

	local bonus = thtd_luna_02_bonus_table[caster:THTD_GetStar()] * (#targets)

	if caster.thtd_luna_02_bonus == nil then
		caster.thtd_luna_02_bonus = false
	end

	if caster:THTD_IsTower() and caster.thtd_luna_02_bonus == false then
		caster:THTD_AddPower(bonus)
		caster:THTD_AddAttack(bonus)
		caster.thtd_luna_02_bonus = true

		caster:SetContextThink(DoUniqueString("thtd_luna_02_buff_remove"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				caster:THTD_AddPower(-bonus)
				caster:THTD_AddAttack(-bonus)
				caster.thtd_luna_02_bonus = false
			end,
		7.0)
	end

	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 5

	for k,v in pairs(targets) do
		local DamageTable = {
   			ability = keys.ability,
            victim = v, 
            attacker = caster, 
            damage = damage, 
            damage_type = keys.ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	end

	local effectIndex = ParticleManager:CreateParticle("particles\custom\ability_luna_02_laser.vpcf_c", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+Vector(0,0,128))
	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin() + foward*1000 + Vector(0,0,128))
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin() + foward*1000 + Vector(0,0,128))
	ParticleManager:SetParticleControl(effectIndex, 9, caster:GetOrigin() + Vector(0,0,128))
	ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)
	
end