function item_bag_of_gold_on_spell_start( keys )
    local caster = keys.caster
    caster:ModifyGold(caster:FindItemInInventory('item_bag_of_gold'):GetCurrentCharges(), false, 0)
end