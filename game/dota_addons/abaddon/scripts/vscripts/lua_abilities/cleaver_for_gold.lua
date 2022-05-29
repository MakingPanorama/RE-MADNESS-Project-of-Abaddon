function model (keys)
    local caster = keys.caster
    local ability = keys.ability
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local original = caster:GetModelScale()
    local new = original + 1
    for i=1, 20 do
        Timers:CreateTimer(i/10,function() caster:SetModelScale(original+i/20) end )    
    end
    for i=1, 20 do
        local time = duration - (20-i)/10
        Timers:CreateTimer(time,function() caster:SetModelScale(new-i/20) end )    
    end
end