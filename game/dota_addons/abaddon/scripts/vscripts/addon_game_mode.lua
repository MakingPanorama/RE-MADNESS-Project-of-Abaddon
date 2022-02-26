-- Internal
require('events')
require('hack_init')

-- Libraries
require('libraries/physics')
require('libraries/timers')

-- Utilities
require('utilities/wave_manager')
require('utilities/dropsystem')
require('utilities/string')
require('utilities/ai')

if Abaddon == nil then
	_G.Abaddon = class({})
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

	-- Global Think
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
    GameRules:SetPreGameTime(3.0)                      -- Set the coundown timer before game start (time = 0.00) 
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

	local GameMode = GameRules:GetGameModeEntity()

	-- XP Table
	XP_PER_LEVEL_TABLE = {
        0,-- 1
        200,-- 2
        500,-- 3
        900,-- 4
        1400,-- 5
        2000,-- 6
        2600,-- 7
        3200,-- 8
        4400,-- 9
        5400,-- 10
        6000,-- 11
        8200,-- 12
        9000,-- 13
        10400,-- 14
        11900,-- 15
        13500,-- 16
        15200,-- 17
        17000,-- 18
        18900,-- 19
        20900,-- 20
        23000,-- 21
        25200,-- 22
        27500,-- 23
        29900,-- 24
        32400,-- 25
        35000,-- 26
        37700,-- 27
        40500,-- 28
        43400,-- 29
        46400,-- 30
        49500,-- 31
        52700,-- 32
        56000,-- 33
        59400,-- 34
        62900,-- 35
        66500,-- 36
        70200,-- 37
        74000,-- 38
        77900,-- 39
        81900,-- 40
        86000,-- 41
        90200,-- 42
        94500,-- 43
        98900,-- 44
        103400,-- 45
        108000,-- 46
        112700,-- 47
        117500,-- 48
        122400,-- 49
        127400, -- 50
        130000,-- 1
        140000,-- 2
        150000,-- 3
        160000,-- 4
        170000,-- 5
        180000,-- 6
        190000,-- 7
        200000,-- 8
        210000,-- 9
        220000,-- 10
        230000,-- 11
        240000,-- 12
        250000,-- 13
        260000,-- 14
        270000,-- 15
        280000,-- 16
        290000,-- 17
        300000,-- 18
        310000,-- 19
        320000,-- 20
        330000,-- 21
        340000,-- 22
        350000,-- 23
        360000,-- 24
        370000,-- 25
        380000,-- 26
        390000,-- 27
        400000,-- 28
        410000,-- 29
        420000,-- 30
        430000,-- 31
        440000,-- 32
        460000,-- 33
        480000,-- 34
        500000,-- 35
        520000,-- 36
        540000,-- 37
        560000,-- 38
        580000,-- 39
        600000,-- 40
        620000,-- 41
        640000,-- 42
        680000,-- 43
        700000,-- 44
        740000,-- 45
        760000,-- 46
        780000,-- 47
        800000,-- 48
        820000,-- 49
        850000 -- 50
    }
    GameMode:SetUseCustomHeroLevels(true)                   -- Must set if use custom max level
    GameMode:SetCustomHeroMaxLevel( 100 )                    -- Custom max level
    GameMode:SetLoseGoldOnDeath(false)                      -- Set if lose gold when die
    GameMode:SetMaximumAttackSpeed(10000)                    -- Set maximum attack speed    
    --GameMode:SetCustomBuybackCooldownEnabled(true)          -- Allow or not the custom buyback cooldown 
    --GameMode:SetCustomBuybackCostEnabled(true)              -- Allow or not the custom buyback cost
    GameMode:SetFixedRespawnTime(20.0)                      -- Set respawn time for heroes
    GameMode:SetKillingSpreeAnnouncerDisabled( true )       -- Disabled the Killing Spree Announcer
    GameMode:SetAnnouncerDisabled(true)                     -- Disabled Announcer
    GameMode:SetUnseenFogOfWarEnabled(false)                 -- All dark
    GameMode:SetStashPurchasingDisabled(false)               -- Must go to shop to buy items
    GameMode:SetCameraDistanceOverride(1300)
    GameMode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )                -- Default one is 1134
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
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
        local defenseLocation = Entities:FindByName( nil, "defense_loc"):GetAbsOrigin()
        AddFOWViewer(DOTA_TEAM_BADGUYS, defenseLocation, 30000, 10800, true) 
        
        -- Init Upgrade Panel
        local upgrades = LoadKeyValues('scripts/npc/ancient/ancient_upgrades.txt')
        local abilities = {}
        for i=0, #upgrades do
            table.insert( abilities, {
                abilityName = upgrades[i]["AbilityName"],
                needPoints = upgrades[i]["NeedPoints"]
            })

            print(abilities.abilityName, abilities.needPoints)
        end

        CustomGameEventManager:Send_ServerToAllClients('UpdatePanel', {
            upgrades = abilities
        })
        

        --local bossLocation = Entities:FindByName( nil, "boss_loc"):GetAbsOrigin()
        --AddFOWViewer(DOTA_TEAM_GOODGUYS, nature_1, 1200, 10800, true)

        -- Begin the wave's manager
        WaveManager:Init()
    end
end

-- Calls when client clicked on skip button
function Abaddon:OnVoteClick( tData )
	local timerTable = CustomNetTables:GetTableValue('player_table', 'timer')

	SetTimeLeft( timerTable["endTime"] - ( timerTable["endTime"] / PlayerResource:GetNumConnectedHumanPlayers() + 1 ) )
	CustomNetTables:SetTableValue('player_tabale', 'timer', { 
		startTime = GameRules:GetDOTATime(false, false),
		endTime = timerTable["endTime"] - ( timerTable["endTime"] / PlayerResource:GetNumConnectedHumanPlayers() + 1 )
	})
end

-- Calls once timer time is out
function Abaddon:OnTimeEnd( tData )
	if WaveManager:StateGet() == MADNESS_WAVE_STATE_WAITING_FOR_NEXT_ROUND then
		WaveManager.State = MADNESS_WAVE_STATE_ROUND_IN_PROGRESS
		WaveManager:StartNextRound()
	end
end


-- Get Cast Range Bonus FIX
CDOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
    if(not self or self:IsNull() == true) then
        return 0
    end
    local caster = self:GetCaster()
    if(not caster or caster:IsNull() == true) then
        return 0
    end
    return caster:GetCastRangeBonus()
end
 
CDOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
    if(not self or self:IsNull() == true) then
        return 0
    end
    local caster = self:GetCaster()
    if(not caster or caster:IsNull() == true) then
        return 0
    end
    return caster:GetCastRangeBonus()
end