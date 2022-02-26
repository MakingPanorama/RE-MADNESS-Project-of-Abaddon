if DropSystem == nil then
    DropSystem = {}
end

_G.DropList = LoadKeyValues('scripts/npc/kv/drop_list.kv')
_G.ItemProperties = LoadKeyValues('scripts/npc/npc_items_custom.txt')

function DropSystem:DropItem( victim )
    if DropList then
        for itemName, chance in pairs( DropList ) do
            if RollPercentage( chance ) then
                local dropItem = CreateItem( itemName, nil, nil )
                local vicPos = victim:GetAbsOrigin()
                if item_name == 'item_bag_of_gold' then
                    item:SetCurrentCharges( RandomInt(75,150) )
                end

                local landLoc = vicPos + RandomVector(RandomFloat(-360, 360))
                local dropInWorld = CreateItemOnPositionSync(vicPos, dropItem)
                item:LaunchLoot(GetCastItemOnPickup( itemName ), 400, 0.7, landLoc)
                
                DoClear( item )
            end
        end
    else
        print('[DropSystem] Error while I was tried to DropItem. Seems like DropList is not defined!')
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
            if itemEntity:GetOwner() == nil and itemEntity == item then
                Timers:CreateTimer(15, function()
                    value:RemoveSelf()
                    itemEntity:RemoveSelf()
                end)
            end
        end
    end
end
