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
            'PLAYER_TARGET_CHANGED',
            'NAME_PLATE_CREATED',
        },
        timers = {
            15,
        },
    }
}

ctrl.mob = ctrl.mod:new(mod)

function ctrl.mob:checkunit(unit)
    if not UnitExists(unit) then self.unit[unit] = nil; return end
    local guid = UnitGUID(unit)
    if not guid then return end
    if UnitIsDead(unit) then
        self.unit[unit] = nil
        self.guid[guid] = nil
        return
    end
    if self.guid[guid] and UnitIsUnit(unit, self.guid[guid].unit) then return end
    self:add(guid, unit)
end

function ctrl.mob:add(guid, unit)
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
end

function ctrl.mob:updateall()
    for guid, data in pairs(self.guid) do
        self:updateguid(guid)
    end
end

function ctrl.mob:tick(interval)
    ctrl.mob:updateall()
end

function ctrl.mob.PLAYER_TARGET_CHANGED()
    ctrl.mob:checkunit('target')
end

function ctrl.mob.NAME_PLATE_CREATED(nameplate)
    local unit = nameplate.namePlateUnitToken
    if not unit then return end
    ctrl.mob:checkunit(unit)
end

function ctrl.mob.setup(self)
    ctrl.mob.guid = ctrl.mob.guid or {}
    ctrl.mob.unit = ctrl.mob.unit or {}
    ctrl.mob.npc = ctrl.mob.npc or {}
end

ctrl.mob:init()
