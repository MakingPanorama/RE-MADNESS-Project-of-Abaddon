function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local modifier = keys.modifier_name
    local sound = keys.sound_name
    local point = ability:GetCursorPosition()
    local tower = CreateUnitByName("Defence Tower", point, true, caster, nil, caster:GetTeam())
    tower:SetControllableByPlayer(caster:GetPlayerID(), true)
    tower:SetOwner(caster)
    EmitSoundOn(sound, tower)
    ability:ApplyDataDrivenModifier( tower, tower, modifier, {} )
end