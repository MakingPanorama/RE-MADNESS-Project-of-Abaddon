function SpawnZombie( keys )
if not keys.target:IsAlive() then
	local caster = keys.target
	local caster2 = keys.caster
    local ability = keys.ability	
    local mult = ability:GetSpecialValueFor("zombie_multiplier") *0.01
	local BaseAttackTime = ability:GetSpecialValueFor("BaseAttackTime") *0.01
	local caster_position = caster:GetAbsOrigin()
	local unit = CreateUnitByName( "undead"  , caster_position + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
	
		unit:SetBaseDamageMin(caster2:GetBaseDamageMin()* mult )
		unit:SetBaseDamageMax(caster2:GetBaseDamageMax()* mult )
		unit:SetBaseHealthRegen(caster2:GetHealthRegen()* mult )
		unit:SetBaseAttackTime(caster2:GetBaseAttackTime()* BaseAttackTime )
		unit:SetPhysicalArmorBaseValue(caster2:GetPhysicalArmorBaseValue() *BaseAttackTime )
		unit:SetMaxHealth(caster2:GetMaxHealth() *mult )
		unit:SetHealth(caster2:GetMaxHealth())
	end

end