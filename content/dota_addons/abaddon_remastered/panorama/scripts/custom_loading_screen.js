let lastTip;


(function() {
    randomTipInterval();
}());

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min)
}

function randomTipInterval() {
    $.Schedule( 10, () => {
        randomTipInterval();
    })

    let randomNUM = getRandomInt( 1, 10 );
    let tip = "tip" + randomNUM

    // Avoid the last tip
    if ( tip == lastTip ) {
        randomNUM = getRandomInt( 1, 10 );
        tip = "tip" + randomNUM
        if ( tip == lastTip ) {
            randomNUM = getRandomInt( 1, 10 );
            tip = $.Localize("#tip" + randomNUM)
            lastTip = tip;
        }
    } else tip = $.Localize('#tip' + randomNUM );

    $('#tipLabel').text = tip;
    lastTip = tip
}

function selectRandomTip()
{
    let randomNUM = getRandomInt( 1, 11 );
    let tip = "tip" + randomNUM

    // Avoid the last tip
    if ( tip == lastTip ) {
        randomNUM = getRandomInt( 1, 11 );
        tip = "tip" + randomNUM
        if ( tip == lastTip ) {
            randomNUM = getRandomInt( 1, 11 ) - 1;
            tip = $.Localize("#tip" + randomNUM)
            lastTip = tip;
        }
    } else tip = $.Localize('#tip' + randomNUM );

    $('#tipLabel').text = tip;
    lastTip = tip
}