function WisdomTomeUsed( keys )
	local caster = keys.caster
	local casterLevel = caster:GetLevel()
	caster:AddExperience(_G.XP_PER_LEVEL_TABLE[casterLevel + 1] - _G.XP_PER_LEVEL_TABLE[casterLevel], false, false)
end
