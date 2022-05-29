function SpawnZombie1( keys )
if not keys.target:IsAlive() then
	local caster = keys.target	
	local caster_position = caster:GetAbsOrigin()
	if caster:GetUnitName() == "npc_dota_mad_chicken" or caster:GetUnitName() == "npc_dota_secret_chicken" then
		return
	end
	local unit = CreateUnitByName( "npc_dota_dark_skeleton_2"  , caster_position + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
	if GameRules.ZombieMode == 1 then
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.5)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.5)				
		unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*1.5)
		unit:SetMaxHealth(unit:GetMaxHealth()*1.5)
		unit:SetHealth(unit:GetMaxHealth())
	end

	-- Destroy trees around the caster and target
end
end