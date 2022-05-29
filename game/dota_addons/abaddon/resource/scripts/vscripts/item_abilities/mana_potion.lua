function mana (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local mana = ability:GetLevelSpecialValueFor("mana", (ability:GetLevel() - 1))
    local sound = keys.sound_name
    local particle = keys.particle_name
    target:EmitSound(sound)
    local current_mana = target:GetMana()
    target:SetMana(current_mana + mana)
    local particle_id = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
    Timers:CreateTimer(1.5, function()
          ParticleManager:DestroyParticle(particle_id, false)
    end)
    SendOverheadEventMessage(nil,OVERHEAD_ALERT_MANA_ADD,target,mana,nil)
end