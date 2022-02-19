-- You can get full version only if you ask about that to author

if WaveManager == nil then
    WaveManager = {}
end

WaveManager.State = -1

_G.MADNESS_WAVE_STATE_DISABLED = -1
_G.MADNESS_WAVE_STATE_PRE_GAME = 0
_G.MADNESS_WAVE_STATE_PRE_ROUND_TIME = 1
_G.MADNESS_WAVE_STATE_ROUND_IN_PROGRESS = 2
_G.MADNESS_WAVE_STATE_POST_GAME = 3

-- Initalization
defenseLoc = nil
currentRound = 0
roundTimerIsFinished = true
roundEnded = false

unitRemains = 0
Boss = nil


function WaveManager:Init()
    defenseLoc = Entities:FindByName( nil, 'defense_loc'):GetAbsOrigin()

    WaveManager.State = MADNESS_WAVE_STATE_PRE_GAME

    SetBossNPC('npc_dota_ancient_guardian')
    ListenToGameEvent('entity_killed', OnWaveEntityKilled)

    
    if IsInToolsMode() then
        print('Debug info: ')
        print('Current Round: ', currentRound)
        print('Round Timer Is Finished: ', roundTimerIsFinished)
        print('Round Ended: ', roundEnded)
        print('Unit Remains: ', unitRemains)
        print('Boss Name: ', Boss:GetUnitName())
    end

    GameRules:GetGameModeEntity():SetThink( 'WaveThink', self, 'GlobalThink', 0.3 )
end

function WaveThink()
    if roundTimerIsFinished and roundEnded then
        roundEnded = false
        WaveManage.State = MADNESS_STATE_PRE_ROUND_TIME

        if currentRound ~= 0 then
            local reward = {
                base = current_round * 100,
                threshold = current_round * 500
            }
            WaveManager:Reward( reward )
        end
        Timers:PopupTimer( 30 )
    end
end

function WaveManager:StartNextRound()
    if currentRound ~= 0 then
        AncientBase:CreatureLevelUp(1)
    end

    roundTimerIsFinished = false
    currentRound = currentRound + 1

    local spawnInfo = SpawnTable[currentRound]
    if not spawnInfo then
        GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
        roundTimerIsFinished = true
    else
        local interval = spawnInfo["interval"]
        local wave_count = spawnInfo["wave_count"]
        local current_wave_count = 0
        local countdown = interval

        

        Timers:CreateTimer(function()
            if not current_round_timer_finished and current_wave_count < wave_count then
                if countdown == 0 then
                   current_wave_count = current_wave_count + 1
                   self:SpawnWave(spawnInfo, current_wave_count)
                end
                if countdown == -1 then
                   countdown = interval
                end
                countdown = countdown - 1
                return 1
            else
                current_round_timer_finished = true
                return
            end
        end)
    end
    
    if IsInToolsMode() then
        print('Debug info: ')
        print('Current Round: ', currentRound)
        print('Round Timer Is Finished: ', roundTimerIsFinished)
        print('Round Ended: ', roundEnded)
        print('Unit Remains: ', unitRemains)
        print('Boss Name: ', Boss:GetUnitName())
    end
end

function WaveManager:Reward( tReward )
    for i=0, DOTA_MAX_PLAYER_TEAMS do   
        if PlayerResource:IsValidPlayer(i) then
            local gained = PlayerResource:GetTotalEarnedGold(i)
            local support = math.max(0, reward.threshold - gained)
            local total = reward.base + support
            Timers:CreateTimer(1.5, function()
                PlayerResource:ModifyGold(i, total, true, 0)
            end)
        end
    end
end

-- Additional functions

-- Debug functions
function WaveManager:SkipWave()
    roundTimerIsFinished = true
    roundEnded = true
    unitRemains = 0
end
