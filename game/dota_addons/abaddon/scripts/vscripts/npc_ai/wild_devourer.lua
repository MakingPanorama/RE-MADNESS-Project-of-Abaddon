function Spawn( entityKeyValues )
    thisEntity:SetRenderColor(75,50,150)
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
    local ability = thisEntity:FindAbilityByName("polar_furbolg_ursa_warrior_thunder_clap") 
    if ability:IsCooldownReady() then
        local caster = thisEntity
        local pos =  caster:GetAbsOrigin()
        local range = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
        local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
        for _,unit in pairs(units) do
            if not unit:IsInvisible() then
                caster:CastAbilityNoTarget(ability,caster:GetPlayerOwnerID())
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