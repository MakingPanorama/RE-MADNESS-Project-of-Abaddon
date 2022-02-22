function VoteToSkip() {
    GameEvents.SendCustomGameEventToServer('VoteClick', {});
    $('#SkipButton').AddClass('Hidden');
}