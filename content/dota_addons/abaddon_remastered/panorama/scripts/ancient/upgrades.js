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

let CourierControlButton = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse('Hud').FindChildTraverse('HUDElements').FindChildTraverse('lower_hud').FindChildTraverse('shop_launcher_block').FindChildTraverse('quickbuy').FindChildTraverse('ShopCourierControls').FindChildTraverse('courier').FindChildTraverse('CourierControls')
let pointsShopButton;

function Init() {
    for ( const upgradeName in upgrades ) {
        /* Panel */
        let panel = $.CreatePanel('Button', $('#upgradeContainer'), upgradeName);
        panel.BLoadLayoutSnippet('upgradeSlotSnippet');
        
        /* Adjust Parameter */
        panel.style.backgroundImage = `url("file://{images}/custom_game/ancient/upgrades/${upgradeName}.png")`

        /* Events */
        /* On Mouse Click */
        panel.SetPanelEvent( 'onactivate', () => {
            GameEvents.SendCustomGameEventToServer('Upgrade', {
                abilityName: upgradeName
            })
        })

        /* On Mouse Enter */
        panel.SetPanelEvent( 'onmouseover', function() {
            $.DispatchEvent( 'DOTAShowAbilityTooltip', panel, upgradeName );
        })

        /* On Mouse Leave */
        panel.SetPanelEvent( 'onmouseout', function() {
            $.DispatchEvent( 'DOTAHideAbilityTooltip', panel );
        })
    }
}

/* Game Info table has changed */
function OnPointsChanged( table, key, data ) {
    if ( key == "points" ) {
        pointsShopButton.FindChildTraverse('titleButton').text = data.point;
    }
}

/* Answer on feedback from Lua */
function OnUpdatePanel( data ) {
    /* Variables */
    let abilityName = data.abilityName;
    let abilityLevel = data.abilityLevel;
    let abilityMaxLevel = data.abilityMaxLevel;
    let needPointsToNext = data.needPointsToNext;

    let pointShop = pointsShopButton
    let panel = $(`#${abilityName}`)
    let currentLevel = panel.FindChildTraverse('levelLabel');
    let points = pointShop.FindChildTraverse('titleButton')
    points.text = data.points;

    /* Misison Failed. Okay next time */
    if ( data.bFailed ) {
        $.Msg('Failed')
        return
    }

    /* Adjust text */
    currentLevel.text = ` ${abilityLevel} / ${abilityMaxLevel} `

    if ( needPointsToNext == null || abilityLevel >= abilityMaxLevel ) {
        currentLevel.text = 'Maxed';
        return;
    }
}

function InitUI() {
    let dotaHUD = $.GetContextPanel()
    CourierControlButton.FindChildTraverse('SelectCourierButton').style.visibility = "collapse";
    CourierControlButton.FindChildTraverse('DeliverItemsButton').style.visibility = "collapse";
    let shopPoints = CourierControlButton.FindChildTraverse('pointsShop')
    if ( shopPoints ) {
        shopPoints.DeleteAsync( 0 );
        $.Msg(shopPoints)
    };

    let button = $.CreatePanel("Button", $.GetContextPanel(), "pointsShop")
    button.BLoadLayoutSnippet( "pointButton" );
    button.SetParent( CourierControlButton );

    button.SetPanelEvent( 'onactivate', () => {
        $('#upgradeBar').SetHasClass( 'slideRightClass', !$("#upgradeBar").BHasClass( "slideRightClass" ) )
        if ( !$("#upgradeBar").BHasClass( "slideRightClass" ) ) {
            $("#upgradeBar").style.opacity = "0.0";
        } else {
            $("#upgradeBar").style.opacity = "1.0";
        }

    })

    pointsShopButton = button;
}

(function() {
    CustomNetTables.SubscribeNetTableListener("points", OnPointsChanged)
    GameEvents.Subscribe('UpdatePanel', OnUpdatePanel);

    /* Init to create upgrades */
    Init();

    $.Msg(!$("#upgradeBar").BHasClass( "slideRightClass" ))
    //
    /* Init UI */
    InitUI();
})();
