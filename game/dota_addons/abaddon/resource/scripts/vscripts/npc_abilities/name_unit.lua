    function nameboss( event ) 
        local hero = event.caster
        Timers:CreateTimer(0.01, function()
        -- Set Mana to 0 on created
        hero:SetMana(0)
    end)
 end