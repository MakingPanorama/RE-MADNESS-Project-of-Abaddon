function hunter_blood(event)
	local caster = event.caster
	local bonus=event.ability:GetSpecialValueFor("bonus")
	if not caster:GetContext("hunter_blood") then 
		caster:SetContextNum("hunter_blood",0,0) 
	end
    local max = caster:GetContext("hunter_blood") + 1
    caster:SetContextNum("hunter_blood", max , 0)         
    --修改modifier图标上的数字
	caster:SetModifierStackCount("modifier_hunter_blood_owner",event.ability,max*bonus)
end