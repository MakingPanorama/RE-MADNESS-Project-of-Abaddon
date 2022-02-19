-- Internal
require('events')

-- Libraries
require('libraries/physics')
require('libraries/timers')

-- Utilities
require('utilities/wave_manager')
require('utilities/dropsystem')

if Abaddon == nil then
	Abaddon = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = Abaddon()
	GameRules.AddonTemplate:InitGameMode()
end

function Abaddon:InitGameMode()
	print( "Re-madnessed." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	-- Events
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(Abaddon, 'OnGameRulesStateChange'), self)

	-- Custom Game Events
	CustomGameEventManager:RegisterListener('VoteClick', Dynamic_Wrap(Abaddon, 'OnVoteClick'))
	CustomGameEventManager:RegisterListener('timer_stopped', Dynamic_Wrap(Abaddon, 'OnTimeEnd'))

	-- Custom Game Settings
	GameRules:SetHeroSelectionTime( 600.0 )             -- How long should we let people select their hero?
    GameRules:SetGoldPerTick(1)                         -- How much gold should players get per tick?
    GameRules:SetGoldTickTime(1)                        -- How long should we wait in seconds between gold ticks?
    GameRules:SetUseBaseGoldBountyOnHeroes( false )     -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?
    GameRules:SetFirstBloodActive( false )              -- Should we enable first blood for the first kill in this game?
    GameRules:SetCustomGameEndDelay( -1 )               -- How long should we wait after the game winner is set to display the victory banner and End Screen?  Use -1 to keep the default (about 10 seconds)   
    GameRules:SetStartingGold( 170 )                    -- How much starting gold should we give to each player?
    GameRules:SetCustomGameSetupAutoLaunchDelay( 0 ) -- How long should the default team selection launch timer be?  The default for custom games is 30
    GameRules:SetSameHeroSelectionEnabled( false )      -- Should we let people select the same hero as each other
    GameRules:SetPreGameTime(10)                      -- Set the coundown timer before game start (time = 0.00) 
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )   -- Maximum players for Team 1
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )    -- Maximum players for Team 2
    GameRules:SetFirstBloodActive(false)                             -- Do not trigger first blood event
    GameRules:SetStrategyTime(0.0)                      -- Set the time for decision phase
    GameRules:SetHideKillMessageHeaders(true)            -- Sets whether or not the kill banners should be hidden
    GameRules:SetSameHeroSelectionEnabled(false)         -- When true, players can repeatedly pick the same hero.
    GameRules:SetShowcaseTime(0)                       -- Set the duration of the 'radiant versus dire' showcase screen.
    GameRules:SetUseBaseGoldBountyOnHeroes(true)
    GameRules:SetCustomVictoryMessage("VICTORY")
    GameRules:SetCustomVictoryMessageDuration(10)
    GameRules:SetUseUniversalShopMode( true )
    GameRules:SetRuneSpawnTime(45)
end

-- Evaluate the state of the game
function Abaddon:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

-- Calls while GameRules State changes
function Abaddon:OnGameRulesStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_SCENARIO_SETUP then
        local defenseLocation = Entities:FindByName( nil, "defense_loc"):GetAbsOrigin()
        AddFOWViewer(DOTA_TEAM_BADGUYS, base_location, 30000, 10800, true) 
        
        local bossLocation = Entities:FindByName( nil, "boss_loc"):GetAbsOrigin()
        AddFOWViewer(DOTA_TEAM_GOODGUYS, nature_1, 1200, 10800, true)

        -- Begin the wave's manager
        WaveManager:Init()
    end
end

-- Calls when client clicked on vote button
function Abaddon:OnVoteClick( tData )
	Timers:SetTimeLeft( CustomNetTables:GetTableValue('player_table', 'timer') - ( 30 / PlayerResource:GetNumConnectedHumanPlayers() ) )
	CustomNetTables:SetTableValue('player_tabale', 'timer', { 
		startTime = GameRules:GetDOTATime(false, false)
		endTime = CustomNetTables:GetTableValue('player_table', 'timer') - ( 30 / PlayerResource:GetNumConnectedHumanPlayers() )
	})
end

-- Calls once timer time is out
function Abaddon:OnTimeEnd( tData )
	if WaveManager:StateGet() == MADNESS_WAVE_PRE_ROUND_TIME then
		WaveManager:StartNextRound()
	end
end