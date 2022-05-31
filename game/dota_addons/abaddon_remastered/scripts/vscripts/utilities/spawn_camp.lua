if NeutralCamp == nil then
    NeutralCamp = {}
end

_G.RespawnTime = 60
_G.ThinkInterval = 1
_G.UnitCurrentLevel = 1
_G.UnitsInCamps = {
    --[[
        reabaddon = {
            units = {},
            name = "neutral_camp_loc1",
            count_min,
            count_max,
        }
    --]]
}

-- KV Files
_G.SpawnPoints = LoadKeyValues('scripts/kv/spawn_points.kv')
_G.mapList = nil

function NeutralCamp:Init()
    print('[NEUTRAL CAMP] Initialization...')
    
    -- Add to the table a spawn points for the current map
    for key, value in pairs( SpawnPoints ) do
        if key == "maps" then
            mapList = string.split( value, " " )
        end
        
        print( key, value )

        for i=1, #mapList do
            if GetMapName() == mapList[i] then
                if key == mapList[i] then
                    for _, spawn_point in pairs( value ) do
                        table.insert( UnitsInCamps, spawn_point )

                        if IsInToolsMode() then
                            DeepPrintTable( SpawnPoints )
                            DeepPrintTable( UnitsInCamps )
                        end
                    end
                end
                break
            end
        end
    end

    Timers:CreateTimer(function()
        local allDead
        local currentSpawnPoint
        for key, spawn_point in pairs( UnitsInCamps ) do
            local units = spawn_point.units
            currentSpawnPoint = spawn_point

            if IsInToolsMode() then
                print("Spawn Points KV")
                DeepPrintTable(SpawnPoints)

                print("Units In Camps")
                DeepPrintTable(UnitsInCamps)

                print( key, spawn_point )
            end

            for _, value in pairs( spawn_point ) do
                for _, unit in pairs( value.units ) do
                    self:SpawnCamps( RespawnTime, currentSpawnPoint )
                end
            end

        end
        return RespawnTime
    end)
end

function NeutralCamp:SpawnCamps( iDelay, spawn_point )
    Timers:CreateTimer(iDelay, function()
        UnitCurrentLevel = UnitCurrentLevel + 1

        for key, value in pairs( spawn_point ) do
            unit_name = value.unit_name
            count_min = value.count_min
            count_max = value.count_max
            spawn_point = Entities:FindByName(nil, value.name)
            units = value.units
            allDead = value.allDead

    
            if spawn_point and count_min and count_max and unit_name and allDead == 1 then
                local spawn_origin = spawn_point:GetAbsOrigin()
                local num_of_units = RandomInt(count_min, count_max)
            
                for i=1, num_of_units do
                    local unit = CreateUnitByName(unit_name, spawn_origin + RandomVector( 100 ), true, nil, nil, DOTA_TEAM_NEUTRALS)
                    unit.IsNeutralWaveUnit = true

                    -- Increase level of units
                    unit:CreatureLevelUp( UnitCurrentLevel )

                    -- Change color that depends from level
                    unit:SetRenderColor(0 + ( UnitCurrentLevel + 5 ), 255 - ( UnitCurrentLevel + 5 ), 255 - (UnitCurrentLevel + 5) )

                    unit.HomeOrigin = spawn_origin
                    table.insert( units, unit )
                end
            end
        end
    end)
end