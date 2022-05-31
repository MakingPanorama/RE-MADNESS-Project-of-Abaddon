function OnChuanxinchangmaoSuccess(keys)

    local function test()

    local caster = keys.caster

	if caster:HasModifier("modifier_chuanxinchangmao_effect") then return end

	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel()
	local chance = ability:GetLevelSpecialValueFor("chance", level)
	if RandomInt(1, 100) > chance then return end

	local attack_counts = ability:GetLevelSpecialValueFor("attack_counts", level)
	local kockback_distance = ability:GetLevelSpecialValueFor("kockback_distance", level)
	local knockback_height = ability:GetLevelSpecialValueFor("knockback_height", level)
	local knockback_duration = ability:GetLevelSpecialValueFor("knockback_duration", level)

	local knockbackModifierTable =
    {
        should_stun = false,
        knockback_duration = knockback_duration,
        duration = knockback_duration,
        knockback_distance = kockback_distance,
        knockback_height = knockback_height,
        center_x = caster:GetAbsOrigin().x,
        center_y = caster:GetAbsOrigin().y,
        center_z = caster:GetAbsOrigin().z
    }
    keys.target:AddNewModifier( keys.caster, nil, "modifier_knockback", knockbackModifierTable )

    local attack_interval = (knockback_duration * 2) / (attack_counts + 1)
    local last_attack_time = GameRules:GetGameTime()

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_chuanxinchangmao_effect", {})

    local positions = {}
    local caster_origin = caster:GetOrigin()
    local target_origin = target:GetOrigin()
    positions[1] = RotatePosition(target_origin, QAngle(0,  90, 0), caster_origin) + Vector(0,0,knockback_height * 1 / 3)
    positions[2] = RotatePosition(target_origin, QAngle(0, 180, 0), caster_origin) + Vector(0,0,knockback_height * 2 / 3)
    positions[3] = RotatePosition(target_origin, QAngle(0, 270, 0), caster_origin) + Vector(0,0,knockback_height * 2 / 3)
    local attack_index = 0

    caster:SetContextThink(DoUniqueString(""), function()
    	local now = GameRules:GetGameTime()
    	local dt = now - last_attack_time
    	if dt >= attack_interval then
    		attack_index = attack_index + 1

    		if attack_index > attack_counts or (not (target and IsValidEntity(target) and target:IsAlive())) then
    			FindClearSpaceForUnit(caster, caster_origin, true)
	    		local fv = (target:GetAbsOrigin() - caster_origin):Normalized() fv.z = 0
    			caster:SetForwardVector(fv)
	    		caster:RemoveModifierByName("modifier_chuanxinchangmao_effect")
    			return nil
    		else
	    		caster:SetOrigin(positions[attack_index])
	    		local fv = (target:GetAbsOrigin() - positions[attack_index]):Normalized() fv.z = 0
	    		caster:SetForwardVector(fv)
	    		caster:PerformAttack(target, true, true, true, false, true, false, true)
	    		last_attack_time = now
    			return attack_interval
    		end
    	else
    		return attack_interval - dt
    	end
    end, attack_interval)

    end

    local s,m = pcall(test)
    if not s then
        print("Phantom lancer script error")
        print(m)
    end
end
