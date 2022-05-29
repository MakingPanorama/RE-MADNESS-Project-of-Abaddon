function Kill (event)
    local caster = event.caster
    local ability = event.ability
    local base_heal = ability:GetLevelSpecialValueFor("base_heal", ability:GetLevel() - 1)
    local bonus_heal_percentage = ability:GetLevelSpecialValueFor("bonus_heal_percentage", ability:GetLevel() - 1)
    local total_heal = (caster:GetHealth() * bonus_heal_percentage / 100) + base_heal
    caster:Heal(total_heal,caster)
    SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,caster,total_heal,nil)
end