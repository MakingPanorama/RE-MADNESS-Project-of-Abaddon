function Spawn( entityKeyValues )
	Timers:CreateTimer(function()
        if not thisEntity:IsAlive() then return
        else ability_usage_1() ability_usage_2() ability_usage_3() ability_usage_4() return 1                --Repeat
        end
    end
    )
    Timers:CreateTimer(function()
        if not thisEntity:IsAlive() then return
        elseif thisEntity:GetTeam() == DOTA_TEAM_BADGUYS then attack () return 5
        else return                --Repeat
        end
    end
    )  
end

function ability_usage_1 ()
    local caster = thisEntity
    local ability = caster:FindAbilityByName("antimage_blink")
    local target = caster:GetAttackTarget()
    if target == nil then
        local pos =  caster:GetAbsOrigin()
        local range = ability:GetLevelSpecialValueFor("blink_range", ability:GetLevel() - 1)
        local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
        for _,unit in pairs(units) do
            if unit:IsRealHero() then
                target = unit
                break  
            end   
        end
    end
    if target ~= nil then
        local distance = CalcDistanceBetweenEntityOBB(target, caster)  
        if distance > 600 then
            local enemy_pos = target:GetAbsOrigin()
            caster:CastAbilityOnPosition(enemy_pos, ability, caster:GetPlayerOwnerID())
        end   
    end 
end

function ability_usage_2 ()
    local caster = thisEntity
    local ability = caster:FindAbilityByName("axe_berserkers_call")
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local pos =  caster:GetAbsOrigin()
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
    for _,unit in pairs(units) do
        if unit:IsRealHero() and ability:IsCooldownReady() then
            caster:CastAbilityNoTarget(ability, caster:GetPlayerOwnerID())
            break     
        end 
    end 
end

function ability_usage_3 ()
    local caster = thisEntity
    local ability = caster:FindAbilityByName("axe_battle_hunger")
    local range = ability:GetCastRange()
    local pos =  caster:GetAbsOrigin()
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
    for _,unit in pairs(units) do
        if unit:IsRealHero() and ability:IsCooldownReady() then
            caster:CastAbilityOnTarget(unit, ability, caster:GetPlayerOwnerID())
            break     
        end 
    end 
end
    
    
    

function ability_usage_4 ()
    local caster = thisEntity
    local ability = caster:FindAbilityByName("axe_culling_blade")
    local range = ability:GetCastRange()
    local pos =  caster:GetAbsOrigin()
    local threshold = ability:GetLevelSpecialValueFor("kill_threshold", ability:GetLevel() - 1)
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
    for _,unit in pairs(units) do
        if unit:IsRealHero() and unit:GetHealth() <= threshold and ability:IsCooldownReady() then
            caster:CastAbilityOnTarget(unit, ability, caster:GetPlayerOwnerID())
            break     
        end 
    end 
end

function attack ()
    local caster = thisEntity
    local base_location=Entities:FindByName( nil, "base_location"):GetAbsOrigin()
    ExecuteOrderFromTable({
                UnitIndex = caster:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                Position  = base_location,
                Queue     = true 
    })  
end