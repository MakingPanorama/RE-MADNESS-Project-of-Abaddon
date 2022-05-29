function SummonBoss( stringUnitName, vLocation, vTrue, hcaster )
	CreateUnitByName(stringUnitName, vLocation, vTrue, hcaster, hcaster, hcaster:GetTeamNumber())
end

function RandomBoss( keys )

	local random = RandomInt(1, 3)
	local caster = keys.caster
	if random == 1 then
		SummonBoss( "boss_lich", caster:GetAbsOrigin() + RandomVector( 300 ) , false, caster, caster, caster:GetTeamNumber() )
	end
	if random == 2 then
		SummonBoss( "windrunner", caster:GetAbsOrigin() + RandomVector( 300 ), false, caster, caster, caster:GetTeamNumber() )
	end
	if random == 3 then
		SummonBoss( "Axe Lord", caster:GetAbsOrigin() + RandomVector( 300 ), false, caster, caster, caster:GetTeamNumber() )
	end

end


