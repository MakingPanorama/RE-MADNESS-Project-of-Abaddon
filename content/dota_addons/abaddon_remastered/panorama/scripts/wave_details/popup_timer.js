// Code was taken from https://github.com/ZLOY5/LiA/blob/636690d1640151ea9938c0d944ce3111b5739b21/content/life_in_arena/panorama/scripts/custom_game/lia_timer.js
// Life in Arena by ZLOY

let schedule
let startTime
let endTime
let duration
let bTimerActive

/* 
    Tick
    Do a tick with 0.s
*/
function Tick() {
    schedule = $.Schedule(0., Tick);
    let currentTime = Game.GetDOTATime(false, false);
    
    let progressBarValue = ( ( endTime - currentTime ) / duration * 100 )
    $("#progressTime_left").style.width = progressBarValue + "%";

    let time = endTime - currentTime
	let minuts = Math.floor( time/60 )
	let seconds = Math.floor( time - minuts*60 )	
	let sTime = ( (minuts < 10) && "0" + minuts || minuts ) + ":" + ( (seconds < 10) && "0" + seconds || seconds )
	$("#timeLeft").text = sTime

	if (currentTime >= endTime)
		StopTimer()
}

/* 
    Stop Timer
    Calls once player_table value was changed
*/
function StartTimer( data ) {
    startTime = data.startTime
    endTime = data.endTime
    duration = endTime - startTime
    bTimerActive = true;

    if ( schedule == null ) {
        Tick();
    }
}

/* Stop Timer */
function StopTimer() {
    if ( schedule != null ) {
        $.CancelScheduled( schedule );
    }  

    GameEvents.SendCustomGameEventToServer('timer_stopped', {})
    $('#timeLeft').text = '0:00';
    
    bTimerActive = false;
    schedule = null;
}

function NewEndTime( data ) {
    endTime = data.endTime
}

function OnTimerChanged( table, key, data ) {
    if ( key == "timer" ) {
        if ( data.startTime != startTime && !bTimerActive ) {
            $('#skipVote').RemoveClass('Hidden')
            StartTimer( data )
        } else {
            endTime = data.endTime
        }
    }
}

// Debug function
function CreateDebugTimer( iEndTime ) {
    endTime = Game.GetDOTATime(false, false) + iEndTime

    Tick();
}

function VoteToSkip() {
    GameEvents.SendCustomGameEventToServer('VoteClick', {});
    $("#skipVote").AddClass( "Hidden" );
}

(function()
{
	CustomNetTables.SubscribeNetTableListener("player_table", OnTimerChanged)
	//GameEvents.Subscribe("lia_timer_start", StartTimer);
	GameEvents.Subscribe("timer_stop", StopTimer);
	//GameEvents.Subscribe("lia_timer_time_left", NewEndTime);

	var data = CustomNetTables.GetTableValue("player_table", "timer")
	if (typeof(data) == "object") {
		StartTimer(data)
	}

    $.Msg("Timer has begun")
})();