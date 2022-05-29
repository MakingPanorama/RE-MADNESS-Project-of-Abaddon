nduft7_lua = class({})

--------------------------------------------------------------------------------

function nduft7_lua:OnSpellStart()

	self.meleecreeps = self.meleecreeps + 1

	local unit = CreateUnitByName("npc_ogre_magi2", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Ismeleecreep = true;

end

function nduft7_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.meleecreeps = 0;
		ListenToGameEvent("entity_killed", nduft7_lua.WatchmeleecreepDeaths, self)

	end

	self:StartSpawner()

end

function nduft7_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function nduft7_lua:StartSpawner()

	self:SetThink("Makemeleecreeps", self, self:GetCooldownTimeRemaining())

end

function nduft7_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxmeleecreeps = self:GetLevelSpecialValueFor("maxmeleecreeps", (self:GetLevel() - 1))

	return self.meleecreeps <= maxmeleecreeps

end

function nduft7_lua:Makemeleecreeps()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function nduft7_lua:WatchmeleecreepDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Ismeleecreep and ent.Owner and ent.Owner == self:GetCaster() then

		self.meleecreeps = self.meleecreeps - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------