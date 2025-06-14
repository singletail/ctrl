--[[ ctrl - mob.lua - t@wse.nyc - 6/12/25 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'mob',
    color = c.o,
    symbol = '%',
    options = {
        events = {
            --'PLAYER_TARGET_CHANGED',
            --'NAME_PLATE_CREATED',
        },
        timers = {
            5,
        },
        debug = 1,
    }
}

ctrl.mob = ctrl.mod:new(mod)

function ctrl.mob:checkunit(unit)
    if self.options.debug then
        self:debug('checkunit ' .. unit)
    end
    if not UnitExists(unit) or UnitIsDead(unit) then 
        self:removeunit(unit)
        return 
    end
    local guid = UnitGUID(unit)
    if not guid then return end
    if self.guid[guid] and UnitIsUnit(unit, self.guid[guid].unit) then return end
    self:add(guid, unit)
end

function ctrl.mob:removeunit(unit)
    if self.options.debug then
        self:debug('removeunit ' .. unit)
    end
    local guid = UnitGUID(unit)
    self.unit[unit] = nil
    if guid and self.guid[guid] then
        self:removeguid(guid)
    end
end

function ctrl.mob:removeguid(guid)
    if self.options.debug then
        self:debug('removeguid ' .. guid)
    end
    self.guid[guid] = nil
end

function ctrl.mob:add(guid, unit)
    if self.options.debug then
        self:debug('adding ' .. guid .. ' ' .. unit)
    end
    self.guid[guid] = self.guid[guid] or {
        unitName = nil,
        displayName = nil,
        unitClassification = nil,
        unitCreatureFamily = nil,
        unitCreatureType = nil,
        UnitAffectingCombat = nil,
        unit = unit,
        unitType = nil,
        npcId = nil,
        spawnId = nil,
        health = 0,
        maxHealth = 0,
        healthPct = 0,
    }
    self.unit[unit] = guid
    if not self.guid[guid].unitName then self:populate(guid, unit) end
end

function ctrl.mob:updateName(guid)
    if not self.guid[guid].unitName or self.guid[guid].unitName ~= UnitName(self.guid[guid].unit) then
        self.guid[guid].unitName = UnitName(self.guid[guid].unit) or "Unknown"
        if self.guid[guid].spawnId and self.guid[guid].spawnId > 0 then
            self.guid[guid].displayName = string.format('%s %d', self.guid[guid].unitName, self.guid[guid].spawnId)
        else
            self.guid[guid].displayName = self.guid[guid].unitName
        end
    end
end

function ctrl.mob:populate(guid, unit)
    if self.options.debug then
        self:debug('populating ' .. guid .. ' ' .. unit)
    end
    self.guid[guid].unitClassification = UnitClassification(unit)
    self.guid[guid].unitCreatureFamily = UnitCreatureFamily(unit)
    self.guid[guid].unitCreatureType = UnitCreatureType(unit)
    self:getSpawnId(guid)
    self:updateName(guid)
end

function ctrl.mob:getSpawnId(guid)
    local unitType, _, _, _, _, npcId, spawnUid = strsplit("-", guid)
    self.guid[guid].unitType = unitType
    self.guid[guid].npcId = tonumber(npcId)
    if self.guid[guid].unitType == "Creature" or self.guid[guid].unitType == "Vehicle" then
        local sID, _ = ctrl.tgt:spawnId(spawnUid)
        self.guid[guid].spawnId = sID
    end
end

function ctrl.mob:updateguid(guid)
    if self.options.debug then
        self:debug('updating ' .. guid)
    end

    local unit = self.guid[guid].unit
    if not unit or not UnitExists(unit) or UnitIsDead(unit) or not UnitIsUnit(unit, self.guid[guid].unit) then
        self.guid[guid] = nil
        self.unit[unit] = nil
        return
    end
    self.guid[guid].health = UnitHealth(unit) or 0
    self.guid[guid].maxHealth = UnitHealthMax(unit) or 0
    self.guid[guid].healthPct = self.guid[guid].health / self.guid[guid].maxHealth * 100
    self.guid[guid].UnitAffectingCombat = UnitAffectingCombat(unit)
    self:updateName(guid)
    
    if self.options.debug then
        self:debug('updated ' .. self.guid[guid].unitName .. ' ' .. self.guid[guid].healthPct .. '%')
    end
end

function ctrl.mob:updateall()
    if self.options.debug then
        self:debug('updateall()')
    end
    local numUpdated = 0
    for guid, data in pairs(self.guid) do
        self:updateguid(guid)
        numUpdated = numUpdated + 1
    end
    if self.options.debug then
        self:debug('updated ' .. numUpdated .. ' mobs')
        local tablecount = 0
        for _, _ in pairs(self.guid) do
            tablecount = tablecount + 1
        end
        self:debug(ctrl.c.c..'--> table count: ' .. tablecount)
    end
end

function ctrl.mob:scan()
    if self.options.debug then
        self:debug(c.v..'scan()')
    end
    for _, frame in pairs(C_NamePlate.GetNamePlates()) do
		local foundUnit = frame.namePlateUnitToken
		--if foundUnit and UnitAffectingCombat(foundUnit) and not UnitIsFriend(foundUnit, "player") then
			local guid = UnitGUID(foundUnit)
            if guid and not self.guid[guid] then
                self:add(guid, foundUnit)
            end
        --end
    end
end

function ctrl.mob:tick(interval)
    if ctrl.mob.options.debug then
        ctrl.mob:debug('tick.')
    end
    ctrl.mob:scan()
    ctrl.mob:updateall()
end

function ctrl.mob.PLAYER_TARGET_CHANGED()
    if ctrl.mob.options.debug then
        ctrl.mob:debug('mob target changed.')
    end
    ctrl.mob:checkunit('target')
end

local showedone = false

function ctrl.mob.NAME_PLATE_CREATED(nameplate)
    if showedone == false then
        showedone = true
        DevTools_Dump(nameplate[0])
        DisplayTableInspectorWindow(nameplate[0])
    end

    local unittoken = nameplate[1].namePlateUnitToken or "nil"
    local nameplateguid = nameplate[1].namePlateUnitGUID or "nil"
    if ctrl.mob.options.debug then
        ctrl.mob:debug(ctrl.c.b..'NAME_PLATE_CREATED: ' .. unittoken .. ' ' .. nameplateguid)
    end
    --local unit = nameplate.namePlateUnitToken
    if not unittoken or unittoken == "nil" then return end
    ctrl.mob:checkunit(unittoken)
end

function ctrl.mob.setup(self)
    ctrl.mob.guid = ctrl.mob.guid or {}
    ctrl.mob.unit = ctrl.mob.unit or {}
    ctrl.mob.npc = ctrl.mob.npc or {}
end

ctrl.mob:init()
