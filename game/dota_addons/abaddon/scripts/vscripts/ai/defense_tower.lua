function Spawn( entityKeyValues )
    thisEntity.Tether = thisEntity:FindAbilityByName('wisp_tether')
    thisEntity:SetContextThink('TowerThinkAI', AIThink, 0.2)

    Timers:CreateTimer(function()
        if thisEntity.Tether:GetLevel() < thisEntity.Tether:GetMaxLevel() - 1 then
            thisEntity.Tether:SetLevel( thisEntity.Tether:GetLevel() + 1 )
        end
        return 240
    end)
end

function AIThink()
    local weakestTarget = AICore:WeakestAllyHeroInRange( thisEntity, 350 )
    if weakestTarget ~= nil then
        print('Ally spotted!')
        Tether( weakestTarget )
    end

    return 0.2
end

function Tether( hAlly )
    thisEntity:CastAbilityOnTarget(hAlly, thisEntity.Tether, thisEntity:GetPlayerOwnerID())

    return 0.5
end
