function Respawn (keys )
    local caster= keys.caster                --пробиваем IP усопшего
    local caster_position = caster:GetAbsOrigin("natural_spawn_1") --Пробиваем адрес,где лежит жмурик
    local name= caster:GetUnitName("boss_demon")         --Пробиваем имя покойного
    Timers:CreateTimer(0,function()              --Через сколько секунд появится новый фраер(5)
    local unit = CreateUnitByName(name, caster_position + RandomVector( RandomFloat( 0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)
-- создаем нового пацыка по трем аргументам ( имя покойного ,адрес жмурика ,true,nil,nil,Команда_нейтралов)
    end)
end