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
        },
        timers = {
            0.1,
        },
        --debug = 1,
    }
}

ctrl.mob = ctrl.mod:new(mod)

local units = {}
local unitCount = 0

function ctrl.mob:add(guid, unit)
    if self.options.debug then self:debug('add ' .. unit .. ' ' .. guid) end
    if self.guid[guid] then return end
    local unitType, _, _, _, _, npcId, sId = strsplit("-", guid)
    if unitType ~= "Creature" and unitType ~= "Vehicle" then return end
    self.guid[guid] = {
        name = UnitName(unit) or 'Unknown',
        healthPct = 100,
        range = 0,
        inCombat = false,
        unitClassification = UnitClassification(unit) or 'Unknown',
        npcId = npcId,
        spawnId = bit.rshift(bit.band(tonumber(string.sub(sId, 1, 5), 16), 0xffff8), 3),
    }
end

function ctrl.mob:updatemob(guid, unit)
    self.guid[guid].healthPct = UnitHealthMax(unit) > 0 and math.floor(UnitHealth(unit) / UnitHealthMax(unit) * 100) or 0
    self.guid[guid].inCombat = UnitAffectingCombat(unit)
    self.guid[guid].range = ctrl.unitRange(unit)
end

function ctrl.mob:cleanup()
    for guid, data in pairs(self.guid) do
        if not UnitExists(data.unit) or UnitIsDead(data.unit) then
            self.guid[guid] = nil
        end
    end
end

function ctrl.mob:check(unit)
    if not UnitExists(unit) or UnitIsDead(unit) then return end
    local guid = UnitGUID(unit)
    if not guid then return end
    if C_PlayerInfo.GUIDIsPlayer(guid) then return end
    if not self.guid[guid] then self:add(guid, unit) end
    self:updatemob(guid, unit)
end

function ctrl.mob:scan()
    wipe(ctrl.mob.guid)
    for i=1, unitCount do
        self:check(units[i])
    end
end

function ctrl.mob.UNIT_DIED(evt)
    local guid = evt[8]
    if not guid then return end
    ctrl.mob.guid[guid] = nil
end

function ctrl.mob:tick(interval)
    ctrl.mob:scan()
end


function ctrl.mob:defineunits()
    units[#units+1] = 'target'
    for i=1, 5 do units[#units+1] = 'boss'..i end
    for j=1, 40 do units[#units+1] = 'nameplate'..j end
    unitCount = #units
end

function ctrl.mob.setup(self)
    ctrl.mob.guid = ctrl.mob.guid or {}
    ctrl.mob:defineunits()
    if ctrl.mob.options.debug then ctrl.mob:debug('setup. defined units: ' .. unitCount) end
end

ctrl.mob:init()
