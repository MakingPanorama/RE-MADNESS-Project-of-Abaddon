function Spawn( entityKeyValues )
    local ability = thisEntity:FindAbilityByName("legion_commander_press_the_attack")
    thisEntity:CastAbilityOnTarget(thisEntity, ability, thisEntity:GetPlayerOwnerID())
	Timers:CreateTimer(2, function()
        if not thisEntity:IsAlive() then return
        else ability_usage_1() ability_usage_2() ability_usage_3() return 1                --Repeat
        end
    end
    )
    Timers:CreateTimer(2,function()
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
            local pos = enemy_pos + Vector(RandomInt(-200,200),RandomInt(-200,200),0)
            caster:CastAbilityOnPosition(pos, ability, caster:GetPlayerOwnerID())
        end   
    end 
end

function ability_usage_2 ()
    local caster = thisEntity
    local ability = caster:FindAbilityByName("legion_commander_press_the_attack")
    local maxhp = caster:GetMaxHealth()
    local hp =  caster:GetHealth()
    local percent = hp / maxhp
    if percent <= 80 and ability:IsCooldownReady() then
        caster:CastAbilityOnTarget(caster, ability, caster:GetPlayerOwnerID())
    end
end

function ability_usage_3 ()
    local caster = thisEntity
    local ability = caster:FindAbilityByName("NPC_Duel")
    local range = ability:GetCastRange()
    local pos =  caster:GetAbsOrigin()
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
    for _,unit in pairs(units) do
        if unit:IsRealHero() and ability:IsCooldownReady() and not unit:HasModifier("NPC_duel_state") then
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