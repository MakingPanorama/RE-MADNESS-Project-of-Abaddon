function Spawn( entityKeyValues )
	Timers:CreateTimer(function()
        if not thisEntity:IsAlive() then return
        else ability_usage () return 1                --Repeat
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

function ability_usage ()
    local ability = thisEntity:FindAbilityByName("centaur_double_edge") 
    if ability:IsCooldownReady() then
        local caster = thisEntity
        local pos =  caster:GetAbsOrigin()
        local range = ability:GetCastRange()
        local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, range, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
        for _,unit in pairs(units) do
            if not unit:IsInvisible() then
                caster:CastAbilityOnTarget(unit, ability, caster:GetPlayerOwnerID())
                break 
            end
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