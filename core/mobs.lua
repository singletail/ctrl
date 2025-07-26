--[[ ctrl - mob.lua - t@wse.nyc - 6/12/25 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'mob',
    color = c.o,
    symbol = '%',
    options = {
        cleu = {
            'UNIT_DIED',
            'PLAYER_REGEN_ENABLED',
            'PLAYER_REGEN_DISABLED',
        },
        timers = {
            0.1,
            0.3,
            1
        },
        removeIfDead = 5,
        removeIfGone = 10,
        debug = nil,
    }
}

ctrl.mob = ctrl.mod:new(mod)

ctrl.mob.guid = ctrl.mob.guid or {}
ctrl.mob.inCombat = nil
ctrl.mob.count = {
    total = 0,
    alive = 0,
    combat = 0,
    tanking = 0
}

local units = {}
local unitCount = 0

function ctrl.mob:add(guid, unit)
    if self.guid[guid] then return end
    local t = GetTime()
    local _, _, _, _, _, npcId, sId = strsplit("-", guid)
    self.guid[guid] = {
        name = UnitName(unit) or 'Unknown',
        healthPct = 100,
        range = 0,
        inCombat = false,
        isTanking = false,
        isDead = false,
        threat = 0,
        unitClassification = UnitClassification(unit) or 'Unknown',
        npcId = npcId,
        spawnId = bit.rshift(bit.band(tonumber(string.sub(sId, 1, 5), 16), 0xffff8), 3),
        time = t,
        last = t,
        color = c.w,
        symbol = s.mob,
    }
end

function ctrl.mob:updatemob(guid, unit, t)
    self.guid[guid].isDead = UnitIsDead(unit) or false
    self.guid[guid].healthPct = UnitHealthMax(unit) > 0 and math.floor(UnitHealth(unit) / UnitHealthMax(unit) * 100) or 0
    local isTanking, status, scaledPercentage, _, _ = UnitDetailedThreatSituation('player', unit)
    self.guid[guid].isTanking = isTanking or false
    self.guid[guid].inCombat = status and status > 0 or false
    self.guid[guid].threat = scaledPercentage or 0
    self.guid[guid].range = ctrl.unitRange(unit)
    self.guid[guid].last = t
    if isTanking then
        self.guid[guid].color = c.tank
    elseif self.guid[guid].inCombat then
        self.guid[guid].color = c.o
    elseif UnitIsEnemy('player', unit) then
        self.guid[guid].color = c.y
    else
        self.guid[guid].color = c.w
    end
end

function ctrl.mob:cleanup()
    local t = GetTime()
    for guid, data in pairs(self.guid) do
        if self.guid[guid].isDead and (t - data.last) > self.options.removeIfDead then self.guid[guid] = nil end
        if (t - data.last) > self.options.removeIfGone then self.guid[guid] = nil end
    end
end

function ctrl.mob:check(unit, t)
    if not UnitExists(unit) or UnitIsDead(unit) then return end
    local guid = UnitGUID(unit)
    if not guid then return end
    local unitType, _, _, _, _, _, _ = strsplit("-", guid)
    if unitType ~= "Creature" and unitType ~= "Vehicle" then return end
    if not UnitCanAttack('player', unit) then return end
    if not self.guid[guid] then self:add(guid, unit) end
    self:updatemob(guid, unit, t)
end

function ctrl.mob:counter()
    local total, alive, combat, tanking = 0, 0, 0, 0
    for _, mob in pairs(self.guid) do
        if not mob then return end
        total = total + 1
        if not mob.isDead then
            alive = alive + 1
            if mob.inCombat then combat = combat + 1 end
            if mob.isTanking then tanking = tanking + 1 end
        end
    end
    self.count.total = total
    self.count.alive = alive
    self.count.combat = combat
    self.count.tanking = tanking
end

function ctrl.mob:scan()
    local t = GetTime()
    for i=1, unitCount do
        self:check(units[i], t)
    end
end

function ctrl.mob.UNIT_DIED(evt)
    local guid = evt[8]
    if not guid then return end
    ctrl.mob.guid[guid] = nil
end

function ctrl.mob.PLAYER_REGEN_ENABLED()
    ctrl.mob.inCombat = false
end

function ctrl.mob.PLAYER_REGEN_DISABLED()
    ctrl.mob.inCombat = true
end

function ctrl.mob:tick(interval)
    if interval == 0.1 then
        ctrl.mob:scan()
    elseif interval == 0.3 then
        ctrl.mob:counter()
    else
        ctrl.mob:cleanup()
    end
end

function ctrl.mob:defineunits()
    units[#units+1] = 'target'
    for i=1, 5 do units[#units+1] = 'boss'..i end
    for j=1, 40 do units[#units+1] = 'nameplate'..j end
    unitCount = #units
end

function ctrl.mob.setup(self)
    ctrl.mob:defineunits()
    if ctrl.mob.options.debug then ctrl.mob:debug('setup. defined units: ' .. unitCount) end
end

ctrl.mob:init()
