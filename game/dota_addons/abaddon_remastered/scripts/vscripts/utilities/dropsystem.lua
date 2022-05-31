if DropSystem == nil then
    DropSystem = {}
end

function DropSystem:DropItem( victim, dropList, attacker  )
    if DropList then
        for itemName, chance in pairs( DropList[victim:GetUnitName()] ) do
            if RollPercentage( tonumber(chance) ) then
                local dropItem = CreateItem( itemName, nil, nil )
                local vicPos = victim:GetAbsOrigin()
                if item_name == 'item_bag_of_gold' then
                    dropItem:SetCurrentCharges( RandomInt(75,150) )
                end

                local landLoc = attacker:GetAbsOrigin() + RandomVector(RandomFloat(-180, 180))
                local dropInWorld = CreateItemOnPositionSync(vicPos, dropItem)
                item:LaunchLoot(GetCastItemOnPickup( itemName ), 400, 0.7, landLoc)
                DoClear( dropItem )
            end
        end
    else
        print("[DROP SYSTEM] Error 22: KV file doesn't exists")
    end
end

-- Additional function
function GetCastItemOnPickup( itemName )
    if ItemProperties[itemName]["ItemCastOnPickup"] == 1 then
        return true
    else
        return false
    end
end

function DoClear( hItem )
    local droppedItems = Entities:FindAllByClassname( "dota_item_drop" )
    for key, value in pairs(dropped_items) do
        if value then
            local itemEntity = value:GetContainedItem()
            if itemEntity:GetOwner() == nil and itemEntity == hItem then
                Timers:CreateTimer(15, function()
                    value:RemoveSelf()
                    itemEntity:RemoveSelf()
                end)
            end
        end
    end
end

