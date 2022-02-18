-- Event Functions
function Abaddon:OnGameRulesStateChange( )
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_SCENARIO_SETUP then
        local defenseLocation = Entities:FindByName( nil, "defense_loc"):GetAbsOrigin()
        AddFOWViewer(DOTA_TEAM_BADGUYS, base_location, 30000, 10800, true) 
        
        local bossLocation = Entities:FindByName( nil, "boss_loc"):GetAbsOrigin()
        AddFOWViewer(DOTA_TEAM_GOODGUYS, nature_1, 1200, 10800, true)

        -- Begin the wave's manager
        WaveManager:Init()
    end
end
