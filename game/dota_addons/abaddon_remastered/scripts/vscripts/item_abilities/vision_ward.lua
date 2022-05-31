function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local pos = ability:GetCursorPosition()
    local hp = ability:GetLevelSpecialValueFor("hp", ability:GetLevel() - 1)
    local armor = ability:GetLevelSpecialValueFor("armor", ability:GetLevel() - 1)
    local day_vision_range = ability:GetLevelSpecialValueFor("day_vision_range", ability:GetLevel() - 1)
    local night_vision_range = ability:GetLevelSpecialValueFor("night_vision_range", ability:GetLevel() - 1)  
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local ward = CreateUnitByName("npc_dota_observer_wards", pos, true, caster, nil, caster:GetTeam())
    ward:SetDayTimeVisionRange(day_vision_range)
    ward:SetNightTimeVisionRange(night_vision_range)
    ward:AddNewModifier(ward, nil, "modifier_kill", {duration = duration})
    while (ward:GetMaxHealth() ~= hp)
    do
        ward:SetMaxHealth(hp)
    end
    while (ward:GetHealth() ~= hp)
    do
        ward:SetHealth(hp)
    end
    while (ward:GetPhysicalArmorBaseValue() ~= armor)
    do
        ward:SetPhysicalArmorBaseValue(armor)
    end
    local model = keys.model
    ward:SetModel(model)
end