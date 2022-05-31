function viper_nethertoxin(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local missing_health = target:GetMaxHealth() - target:GetHealth()
    local damage = math.floor(ability:GetLevelSpecialValueFor("percent", ability:GetLevel()-1) * missing_health * 0.01) + 1
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }

    ApplyDamage( damageTable )
    if caster.show_popup ~= true then
                    caster.show_popup = true
                    ShowPopup( {
                    Target = keys.caster,
                    PreSymbol = 1,
                    PostSymbol = 5,
                    Color = Vector( 50, 255, 100 ),
                    Duration = 1.5,
                    Number = damage,
                    pfx = "damage",
                    Player = PlayerResource:GetPlayer( caster:GetPlayerID() )
                } )
                Timers:CreateTimer(3.0,function()
                    caster.show_popup = false
                end)
    end
end