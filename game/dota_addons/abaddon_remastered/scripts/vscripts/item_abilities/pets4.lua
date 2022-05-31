local pets = {}

function SpawnPet(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin() + RandomVector(RandomFloat(100, 100))
	local pet_type = keys.Pet
	local pid = caster:GetPlayerOwnerID() 

	if pets[pid] then
		if IsValidEntity(pets[pid]) and pets[pid]:IsAlive() then
			pets[pid]:ForceKill(true)
			pets[pid] = nil
		end
	end

	if pet_type == "hulk" then
		SpawnHulk(caster, pid, pos)
	end
end

function SpawnHulk(caster, playerid, pos)
	local team = caster:GetTeamNumber() 


	PrecacheUnitByNameAsync("npc_a4_ancient_hulk", function(...)
		pets[playerid] = CreateUnitByName("npc_a4_ancient_hulk", pos, true, caster, caster, team)
		Timers:CreateTimer(.04, function()
     		pets[playerid]:SetControllableByPlayer(caster:GetPlayerID(), true)
  		end)
	end)
end