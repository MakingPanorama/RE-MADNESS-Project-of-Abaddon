function up (keys)
    local caster = keys.caster
    caster:CreatureLevelUp(1)
    local level = caster:GetLevel()
    if level == 15 then 
        Timers:CreateTimer(0.1,function()
            caster:RemoveAbility("Tower_Building_Upgrade")  
            return
        end
        )
    end
end