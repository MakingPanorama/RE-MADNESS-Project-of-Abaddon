-- Internal
require('events.lua')

-- Libraries
require('libraries/physics.lua')
require('libraries/timers.lua')

-- Utilities
require('utilities/wave_manager.lua')
require('utilities/dropsystem.lua')

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
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	-- Events
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(Abaddon, 'OnGameRulesStateChange'), self)
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