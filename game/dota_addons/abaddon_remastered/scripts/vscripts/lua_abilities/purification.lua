function damage (keys)
    local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local targetLocation = target:GetAbsOrigin()
	local min_damage = ability:GetLevelSpecialValueFor("min_damage", (ability:GetLevel() - 1))
    local max_damage = ability:GetLevelSpecialValueFor("max_damage", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local summon_duration = ability:GetLevelSpecialValueFor("summon_duration", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), targetLocation, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local damageTable = {}
	damageTable.attacker = caster
	damageTable.ability = ability
	damageTable.damage_type = ability:GetAbilityDamageType()
    for _,unit in ipairs(units) do
		damageTable.victim = unit
        damageTable.damage = RandomInt(min_damage,max_damage)
		ApplyDamage(damageTable)
        unit:EmitSound(keys.sound_name)
        if not unit:IsAlive() then
            local summon = CreateUnitByName( unit:GetUnitName(), unit:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
            summon:SetControllableByPlayer(caster:GetPlayerOwner():GetPlayerID(),true)
            summon:CreatureLevelUp(unit:GetLevel()-1)
            summon:EmitSound(keys.sound_name)
            for i = 0, unit:GetAbilityCount()-1 do
                local orginal_ability = unit:GetAbilityByIndex(i)
                if orginal_ability ~=nil then
                    local current_ability = summon:GetAbilityByIndex(i)
                    current_ability:SetLevel(orginal_ability:GetLevel())   
                end  
            end
            summon:AddNewModifier(summon, nil, "modifier_kill", {duration = summon_duration})
	    end
	end
end