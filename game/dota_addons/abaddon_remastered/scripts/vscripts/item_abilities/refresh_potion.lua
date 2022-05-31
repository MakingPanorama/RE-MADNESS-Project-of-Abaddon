function refresh (keys)
    local caster = keys.caster
    local ability = keys.ability
    for i=0, caster:GetAbilityCount()-1 do
		local current_ability = caster:GetAbilityByIndex(i)
		if current_ability ~= nil then
			current_ability:EndCooldown()
		end
	end  
	for i=0, 5 do
		local current_item = caster:GetItemInSlot(i)
		if current_item ~= nil then
			if current_item:GetName() ~= "item_refresh_potion" then  
				current_item:EndCooldown()
			end
		end
	end
end