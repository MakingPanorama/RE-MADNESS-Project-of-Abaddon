if Events == nil then
    Events = class({})
end

--[[

 _______   ___      ___ _______   ________   _________  ________      
|\  ___ \ |\  \    /  /|\  ___ \ |\   ___  \|\___   ___\\   ____\     
\ \   __/|\ \  \  /  / | \   __/|\ \  \\ \  \|___ \  \_\ \  \___|_    
 \ \  \_|/_\ \  \/  / / \ \  \_|/_\ \  \\ \  \   \ \  \ \ \_____  \   
  \ \  \_|\ \ \    / /   \ \  \_|\ \ \  \\ \  \   \ \  \ \|____|\  \  
   \ \_______\ \__/ /     \ \_______\ \__\\ \__\   \ \__\  ____\_\  \ 
    \|_______|\|__|/       \|_______|\|__| \|__|    \|__|  |_________|


]]

--- OnGameRulesStateChange
function Events:OnGameRulesStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
        local defenseLocation = Entities:FindByName( nil, "defense_loc"):GetAbsOrigin()
        AddFOWViewer(DOTA_TEAM_BADGUYS, defenseLocation, 30000, 10800, true) 
        
        -- Init Upgrade Panel
        local upgrades = LoadKeyValues('scripts/npc/ancient/ancient_upgrades.txt')
        local abilities = {}

        CustomGameEventManager:Send_ServerToAllClients('UpdatePanel', {
            upgrades = abilities
        })
        

        --local bossLocation = Entities:FindByName( nil, "boss_loc"):GetAbsOrigin()
        --AddFOWViewer(DOTA_TEAM_GOODGUYS, nature_1, 1200, 10800, true)

        -- Init the wave's manager
        WaveManager:Init()

        -- Init the spawn camp system
        NeutralCamp:Init()
    end
end

--- OnVoteClick
function Events:OnVoteClick( tData )
	local timerTable = CustomNetTables:GetTableValue('player_table', 'timer')

	SetTimeLeft( timerTable["endTime"] - ( timerTable["endTime"] / ( PlayerResource:GetNumConnectedHumanPlayers() + 1 ) ) )
	CustomNetTables:SetTableValue('player_table', 'timer', { 
		startTime = GameRules:GetDOTATime(false, false),
		endTime = timerTable["endTime"] - ( timerTable["endTime"] / ( PlayerResource:GetNumConnectedHumanPlayers() + 1 ) )
	})
end

--- OnTimeEnd
function Events:OnTimeEnd( tData )
	if WaveManager:StateGet() == MADNESS_WAVE_STATE_WAITING_FOR_NEXT_ROUND then
		WaveManager.State = MADNESS_WAVE_STATE_ROUND_IN_PROGRESS
		WaveManager:StartNextRound()
	end
end

--- OnPlayerChatMessage
function Events:OnPlayerChatMessage( event )
    local teamonly = event.teamonly
    local userid = event.userid
    local player_id = event.playerid
    local prefix = "-"
    local text = event.text
    
    if GameRules:IsCheatMode() then
        print('yes')
        if text:find(prefix) then
            local cutText = text:sub( 2 )

            if cutText == "disablewaves" then
                WaveManager:FreezeWaveManager()
                print('Freeze')
            elseif cutText == "enablewaves" then
                WaveManager:UnfreezeWaveManager()
                print('Unfreeze')
            elseif cutText == "skipwave" then
                WaveManager:SkipWave()
                print('Skip wave')
            elseif cutText:find("setwave") then
                local arg = string.split( cutText, " " )
                if arg[2] then
                    WaveManager:SetWave( arg[2] ) -- { "setwave", "2" }
                end
                print( 'setwave' )
            end
        end
    end
end


