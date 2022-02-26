function VoteToSkip() {
    GameEvents.SendCustomGameEventToServer('VoteClick', {});
}