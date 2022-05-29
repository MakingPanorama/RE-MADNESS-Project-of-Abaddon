function Ghosts (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if ability == nil then return end
    target.auspice_unit = target:GetName()
    local currTime = GameRules:GetGameTime()
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    if not distance then distance = 0 end
    if not target.positions or not target.positions[(math.floor(currTime * 100)/100)-2.5] then 
    	 return	
    end
    target.ghostloc = target.positions[(math.floor(currTime * 100)/100)-2.5]
    caster_distance = (target.ghostloc - caster:GetAbsOrigin()):Length2D()
    

    if target.auspice_illusion == nil then
      if caster_distance <= radius then
    	  target.auspice_illusion = CreateUnitByName(target.auspice_unit, target.ghostloc, false, caster, nil, caster:GetTeamNumber())
      	target.auspice_illusion:MakeIllusion()
  		  target.auspice_illusion:SetPlayerID(caster:GetPlayerID())
     		ability:ApplyDataDrivenModifier(caster, target.auspice_illusion, "modifier_auspice_invulnerability", {duration = -1})
      end
   	else
      if (target:GetAbsOrigin() - target.ghostloc):Length2D() < 100 then
        target.auspice_illusion:AddNoDraw()
      else
        target.auspice_illusion:RemoveNoDraw()
      end
   		if caster_distance > radius or target:HasModifier("modifier_auspice_immunity") then
        target.auspice_illusion:RemoveSelf()
        target.auspice_illusion = nil
		  else
   			target.auspice_illusion:MoveToPosition(target.ghostloc)
   		end

   	end
end

function DestroyIllusions( keys )
  local target = keys.target
  if target.auspice_illusion then
    target.auspice_illusion:RemoveSelf()
    target.auspice_illusion = nil
  end
end
