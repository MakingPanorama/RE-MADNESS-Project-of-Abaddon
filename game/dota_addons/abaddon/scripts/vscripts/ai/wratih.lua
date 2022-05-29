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
    local ability = thisEntity:FindAbilityByName("necrolyte_death_pulse") 
    local loss = thisEntity:GetMaxHealth() - thisEntity:GetHealth()
    local heal = ability:GetLevelSpecialValueFor("heal", ability:GetLevel() - 1)
    local manacost = ability:GetManaCost(ability:GetLevel())
    local current_mana = thisEntity:GetMana()
    if ability:IsCooldownReady() and loss >= heal and current_mana >= manacost then
        thisEntity:CastAbilityNoTarget(ability,thisEntity:GetPlayerOwnerID())
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