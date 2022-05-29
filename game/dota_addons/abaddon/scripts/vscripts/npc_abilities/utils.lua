-- 检测人物的等级是否满足技能升级的需求
function CheckLevelRequirement( keys )
	local hero = keys.caster
	local ability = keys.ability
	local ability_name = ability:GetAbilityName()

	if ability:GetLevel() <= 1 then
		return
	end

	if not hero:IsRealHero() then return end

	local hero_level = hero:GetLevel()
	local ability_level = ability:GetLevel()
	
	if ability_level > hero_level then
		msg.bottom("#ability_cant_bigger_than_hero_level", hero:GetPlayerID())
		hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
		ability:SetLevel(ability:GetLevel() - 1)
	end
end