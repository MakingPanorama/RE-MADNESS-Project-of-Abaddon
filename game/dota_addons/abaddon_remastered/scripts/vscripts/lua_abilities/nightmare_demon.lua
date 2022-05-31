function ChangeModel (keys)
    local caster = keys.caster
	local model = keys.model
	local projectile_model = keys.projectile_model
    caster.model = caster:GetModelName()
    caster:SetModel(model)
	caster:SetOriginalModel(model)
	caster:SetRangedProjectileName(projectile_model)
    caster.acquisition = caster:GetAcquisitionRange()
    caster:SetAcquisitionRange(caster:GetAttackRange())
end

function HideWearables (keys)
    local caster = keys.caster
	caster.original = {}
    local model = caster:FirstMoveChild()
    local count = 0
    while model ~= nil do                                          
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            count = count + 1
            caster.original[count] = model
        end
        model = model:NextMovePeer()
    end
    change (keys)
end

function change (keys)
    local caster = keys.caster
    local ability = keys.ability
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local original = caster:GetModelScale()
    local new = original + 0.2
    for i=1, 10 do
        Timers:CreateTimer(i/10,function() caster:SetModelScale(original+i/50) end )    
    end
    for i=1, 10 do
        local time = duration - (10-i)/10
        Timers:CreateTimer(time,function() caster:SetModelScale(new-i/50) end )    
    end
end

function ModelBack (keys)
    local caster = keys.caster
    local model = caster.model
	caster:SetModel(model)
	caster:SetOriginalModel(model)
    caster:SetAcquisitionRange(caster.acquisition)
end

function ShowWearables (keys)
    local caster = keys.caster
	for i,v in pairs(caster.original) do
		v:RemoveEffects(EF_NODRAW)
	end
end