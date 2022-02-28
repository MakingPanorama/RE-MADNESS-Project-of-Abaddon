let upgrades = {
    ancient_bonus_attack_damage: "ancient_bonus_attack_damage",
    ancient_bonus_armor: "ancient_bonus_armor",
    ancient_bonus_hp: "ancient_bonus_hp",
    ancient_heal_ability: "ancient_heal_ability",
    ancient_global_bonus_hp_regen: "ancient_global_bonus_hp_regen",
    ancient_global_bonus_attack_speed: "ancient_global_bonus_attack_speed",
    ancient_global_bonus_attack_damage: "ancient_global_bonus_attack_damage",
    ancient_global_bonus_physical_armor: "ancient_global_bonus_physical_armor",
};

function Init() {
    for ( const upgradeName in upgrades ) {
        /* Panel */
        let panel = $.CreatePanel('Panel', $('#upgrade'), upgradeName);
        panel.BLoadLayoutSnippet('upgradeSlotSnippet');
        
        /* Variables */
        let button = panel.FindChildTraverse( 'buttonSlot' );

        /* Adjust Parameter */
        button.text = $.Localize('#DOTA_Tooltip_ability_' + upgradeName);

        /* Events */
        /* On Mouse Click */
        panel.SetPanelEvent( 'onactivate', () => {
            GameEvents.SendCustomGameEventToServer('Upgrade', {
                abilityName: upgradeName
            })
        })

        /* On Mouse Enter */
        panel.SetPanelEvent( 'onmouseover', function() {
            $.DispatchEvent( 'DOTAShowAbilityTooltip', button, upgradeName );
        })

        /* On Mouse Leave */
        panel.SetPanelEvent( 'onmouseout', function() {
            $.DispatchEvent( 'DOTAHideAbilityTooltip', button );
        })
    }
}

/* Game Info table has changed */
function OnPointsChanged( table, key, data ) {
    if ( key == "points" ) {
        // $('#pointNum').text = data.point;
    }
}

/* Answer on feedback from Lua */
function OnUpdatePanel( data ) {
    /* Variables */
    let abilityName = data.abilityName;
    let abilityLevel = data.abilityLevel;
    let abilityMaxLevel = data.abilityMaxLevel;
    let needPointsToNext = data.needPointsToNext;

    let panel = $(`#${abilityName}`);
    let upgradeButton = panel.FindChildTraverse('buttonSlot');
    let points = $("#nameMenu")
    points.text = "Points: " + data.points;

    /* Misison Failed. Okay next time */
    if ( data.bFailed ) {
        $.Msg('Failed')
        return
    }

    /* Adjust text */
    upgradeButton.text = 'Need Points: ' + needPointsToNext;

    /* Change text to maxed */
    if ( needPointsToNext == null || abilityLevel >= abilityMaxLevel ) {
        upgradeButton.text = 'Maxed';
        return;
    }
}

(function() {
    CustomNetTables.SubscribeNetTableListener("points", OnPointsChanged)
    GameEvents.Subscribe('UpdatePanel', OnUpdatePanel);

    /* Init to create upgrades */
    Init();
})();
