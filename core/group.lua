--[[ ctrl - group.lua - t@wse.nyc - 16 July 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s = ctrl.c, ctrl.s

local mod = {
    name = 'group',
    color = c.o,
    symbol = s.ankh,
    unitId = 'player',
    groupSize = 1,
    flag = {
        scanGroup = 1,
    },
    options = {
        events = {
            'PLAYER_ENTERING_WORLD',
            'GROUP_ROSTER_UPDATE',
        },
        timers = {
            1,
        }
    },
}

ctrl.group = ctrl.mod:new(mod)

ctrl.group.unit = ctrl.group.unit or {}
ctrl.group.guid = ctrl.group.guid or {}

function ctrl.group:addGuid(guid)
    if not guid then return end
    ctrl.group.guid[guid] = {}
    local g = ctrl.group.guid[guid]
    g.guid = guid
    --g.unit = unit
    --self:refreshGuidEntry(unit, guid)
end

function ctrl.group:check(unit)
    local guid = UnitGUID(unit)
    if not guid then return end
    if not ctrl.group.guid[guid] then self:addGuid(guid) end
    ctrl.group.unit[unit] = guid
    --if not ctrl.group.unit[unit] or guid ~= ctrl.group.unit[unit].guid then self:addUnit(unit, guid) end
    --ctrl.group.unit[unit].role = UnitGroupRolesAssigned(unit) or 'NONE'
end

function ctrl.group:scan()
    self.unitId, self.groupSize = ctrl.groupConfig()
    for i = 1, self.groupSize do
        local unit = self.unitId .. i
        if unit == 'party5' or unit == 'player1' then unit = 'player' end
        if UnitExists(unit) then self:check(unit) else self.unit[unit] = nil end
    end
    ctrl.group.flag.scanGroup = nil
end

function ctrl.group:tick()
    if ctrl.group.flag.scanGroup then ctrl.group:scan() end
end

function ctrl.group.GROUP_ROSTER_UPDATE(evt)
    ctrl.group.flag.scanGroup = 1
end

function ctrl.group.PLAYER_ENTERING_WORLD()
    ctrl.group.flag.scanGroup = 1
end

function ctrl.group.setup(self)
    --
end

ctrl.group:init()
