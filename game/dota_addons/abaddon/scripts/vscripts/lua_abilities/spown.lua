function Respawn (keys )
    local caster= keys.caster                --��������� IP ��������
    local caster_position = caster:GetAbsOrigin("natural_spawn_1") --��������� �����,��� ����� ������
    local name= caster:GetUnitName("boss_demon")         --��������� ��� ���������
    Timers:CreateTimer(0,function()              --����� ������� ������ �������� ����� �����(5)
    local unit = CreateUnitByName(name, caster_position + RandomVector( RandomFloat( 0, 50)), true, nil, nil, DOTA_TEAM_NEUTRALS)
-- ������� ������ ������ �� ���� ���������� ( ��� ��������� ,����� ������� ,true,nil,nil,�������_���������)
    end)
end