nduft6_lua = class({})

--------------------------------------------------------------------------------

function nduft6_lua:OnSpellStart()

	self.meleecreeps = self.meleecreeps + 1

	local unit = CreateUnitByName("npc_crystal_maiden", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Ismeleecreep = true;

end

function nduft6_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.meleecreeps = 0;
		ListenToGameEvent("entity_killed", nduft6_lua.WatchmeleecreepDeaths, self)

	end

	self:StartSpawner()

end

function nduft6_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function nduft6_lua:StartSpawner()

	self:SetThink("Makemeleecreeps", self, self:GetCooldownTimeRemaining())

end

function nduft6_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxmeleecreeps = self:GetLevelSpecialValueFor("maxmeleecreeps", (self:GetLevel() - 1))

	return self.meleecreeps <= maxmeleecreeps

end

function nduft6_lua:Makemeleecreeps()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function nduft6_lua:WatchmeleecreepDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Ismeleecreep and ent.Owner and ent.Owner == self:GetCaster() then

		self.meleecreeps = self.meleecreeps - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------