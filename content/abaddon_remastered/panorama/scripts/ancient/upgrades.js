let upgrades = {
    bonusAttackDMG: "ancient_bonus_attack_damage",
    bonusArmor: "ancient_bonus_armor",
    bonusHP: "ancient_bonus_hp",
    HealAbility: "ancient_heal_ability",
    GlobalHPRegen: "ancient_global_bonus_hp_regen",
    GlobalBonusAttackSpeed: "ancient_global_bonus_attack_speed",
    GlobalBonustAttackDmaage: "ancient_global_bonus_attack_damage",
    CloseButton: "action_stop_png"
};
function Init() {
    for ( const upgradeName of upgrades ) {
        let panel = $.CreatePanel('Panel', $('#upgradePanel'), upgradeName);
        panel.BLoadLayoutSnippet('upgradeSlotSnippet');
        
        /* Variables */
        let button = panel.FindChildTraverse('upgradeButton');
        let image = button.FindChildTraverse('img');
        let titleText = button.FindChildTraverse('titleAbility');

        /* Adjust Parameters */
        image.src = "file://{images}/custom_game/ancient/upgrades/" + upgradeName + ".png";
        titleText = $.Localize('#DOTA_Tooltip_ability_' + upgradeName);

    }
}

function OnPointsChanged( table, key, data ) {
    if ( key == "points" ) {
        // $('#pointNum').text = data.points;
    }
}

(function() {
    CustomNetTables.SubscribeNetTableListener("points", OnPointsChanged)
    GameEvents.Subscribe('UpdatePanel', OnUpdatePanel);

    $.Msg(upgrades);
})();