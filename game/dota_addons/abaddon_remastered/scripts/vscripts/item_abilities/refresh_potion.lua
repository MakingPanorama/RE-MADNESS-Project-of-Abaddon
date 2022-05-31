local blocked_items = {
	[ "Cleaver_For_God" ] = 1,
	[ "item_refresh_potion" ] = 1,
} 

function refresh (keys)
    local caster = keys.caster
    local ability = keys.ability
    for i=0, caster:GetAbilityCount()-1 do
		local current_ability = caster:GetAbilityByIndex(i)
		if current_ability ~= nil then
			if current_ability and not blocked_items[current_ability:GetName()] then
				current_ability:EndCooldown()
			end
		end
	end  
	for i=0, 5 do
		local current_item = caster:GetItemInSlot(i)
		if current_item ~= nil then
			if current_item and not blocked_items[current_item:GetName()] then  
				current_item:EndCooldown()
			end
		end
	end
end