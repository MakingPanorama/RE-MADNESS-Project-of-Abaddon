function mana (keys)
    local ability = keys.ability
    local mana = ability:GetLevelSpecialValueFor("mana", (ability:GetLevel() - 1))
    local sound = keys.sound_name
    local particle = keys.particle_name
    local units = FindUnitsInRadius(
        DOTA_TEAM_GOODGUYS,
        Vector(0, 0, 0),
        nil,
        FIND_UNITS_EVERYWHERE,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )   
    for _,hero in pairs(units) do
        hero:EmitSound(sound)
        local current_mana = hero:GetMana()
        hero:SetMana(current_mana + mana)
        local particle_id = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, hero)
        Timers:CreateTimer(0.7, function()
            ParticleManager:DestroyParticle(particle_id, false)
        end)
        SendOverheadEventMessage(nil,OVERHEAD_ALERT_MANA_ADD,hero,mana,nil)
    end
end