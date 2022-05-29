require "../timers"
function Expel_Effect(keys)
    local caster = keys.caster
    local ability=keys.ability
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    caster:Purge(false, true, false, true, false)
    caster:SetRenderColor(255, 185, 15)
    Timers:CreateTimer({
        endTime = duration, 
        callback = function()
            caster:SetRenderColor(255,255,255)
        end
    })
end