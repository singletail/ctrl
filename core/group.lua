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
    myGuild = 'None',
    inspectingUnit = nil,
    options = {
        events = {
            'PLAYER_ENTERING_WORLD',
            'GROUP_ROSTER_UPDATE',
            'INSPECT_READY',
        },
        timers = {
            1,
            3,
        }
    },
}

ctrl.group = ctrl.mod:new(mod)

ctrl.group.unit = ctrl.group.unit or {}
ctrl.group.guid = ctrl.group.guid or {}
ctrl.group.queue = ctrl.group.queue or {}

--[[ Inventory slots
INVSLOT_AMMO		= 0;
INVSLOT_HEAD 		= 1; INVSLOT_FIRST_EQUIPPED = INVSLOT_HEAD;
INVSLOT_NECK		= 2;
INVSLOT_SHOULDER	= 3;
INVSLOT_BODY		= 4;
INVSLOT_CHEST		= 5;
INVSLOT_WAIST		= 6;
INVSLOT_LEGS		= 7;
INVSLOT_FEET		= 8;
INVSLOT_WRIST		= 9;
INVSLOT_HAND		= 10;
INVSLOT_FINGER1		= 11;
INVSLOT_FINGER2		= 12;
INVSLOT_TRINKET1	= 13;
INVSLOT_TRINKET2	= 14;
INVSLOT_BACK		= 15;
INVSLOT_MAINHAND	= 16;
INVSLOT_OFFHAND		= 17;
INVSLOT_RANGED		= 18;
INVSLOT_TABARD		= 19;
]]

local defaultUnit = {
    unit = nil,
    name = 'Unknown',
    class = 'Unknown',
    role = 'NONE',
    specializationID = 0,
    itemLevel = 0,
    lastInspect = 0,
    inv = {},
    color = c.w,
}

function ctrl.group:copyGuidToData(guid)
    if not guid or not ctrl.group.guid[guid] then return end
    ctrl.data.unit[guid] = {}
    ctrl.data.unit[guid] = ctrl.cp(ctrl.group.guid[guid])
end

function ctrl.group:doInspect(unit, guid)
    ctrl.group.guid[guid].specializationID = GetInspectSpecialization(unit)
    ctrl.group.guid[guid].role = GetSpecializationRoleByID(ctrl.group.guid[guid].specializationID)
    ctrl.group.guid[guid].itemLevel = C_PaperDollInfo.GetInspectItemLevel(unit)
    ctrl.group.guid[guid].inv = {}
    for i=1,19 do
        local itemLink = GetInventoryItemLink(unit, i)
        if itemLink then
            local _, _, _, itemLevel = C_Item.GetItemInfo(itemLink)
            ctrl.group.guid[guid].inv[i] = {}
            ctrl.group.guid[guid].inv[i].itemLink = itemLink
            ctrl.group.guid[guid].inv[i].itemLevel = itemLevel
        end
    end
    ctrl.group.guid[guid].lastInspect = GetServerTime()
    ctrl.group.guid[guid].guild = GetGuildInfo(unit)
    if ctrl.group.guid[guid].guild and ctrl.group.guid[guid].guild == ctrl.group.myGuild then self:copyGuidToData(guid) end
    self:info('Inspect complete for ' .. guid .. ' (' .. ctrl.group.guid[guid].name .. ') ilvl = ' .. tostring(ctrl.group.guid[guid].itemLevel))
    ClearInspectPlayer()
    self:removeUnitFromQueue(unit)
    ctrl.group.inspectingUnit = nil
end

function ctrl.group.INSPECT_READY(evt)
    if not ctrl.group.inspectingUnit then ClearInspectPlayer(); return end
    local err = nil
    local guid = evt[1]
    if not guid then err = 'no guid' end
    if not ctrl.group.guid[guid] then err = 'ctrl.group.guid['..tostring(guid)..']' end
    local unit = ctrl.group.guid[guid].unit or ('no unit for ' .. tostring(guid))
    if unit ~= ctrl.group.inspectingUnit then err = 'unit mismatch: ' .. tostring(unit) .. ' vs ' .. tostring(ctrl.group.inspectingUnit) end
    if not ctrl.group.unit[unit] then err = 'ctrl.group.unit[' .. tostring(unit) .. '] not found' end
    if ctrl.group.unit[unit] and ctrl.group.unit[unit] ~= guid then err = 'unit entry mismatch: ' .. tostring(ctrl.group.unit[unit]) .. ' vs ' .. tostring(guid) end
    if err then
        ctrl.group:crit('INSPECT_READY error: ' .. err)
        ctrl.group.inspectingUnit = nil
        ClearInspectPlayer()
        return
    end
    ctrl.group:doInspect(unit, guid)
end

function ctrl.group:removeUnitFromQueue(unit)
    for i, queuedUnit in ipairs(ctrl.group.queue) do
        if queuedUnit == unit then
            tremove(ctrl.group.queue, i)
            return
        end
    end
end

function ctrl.group:moveUnitToEndOfQueue(unit)
    self:removeUnitFromQueue(unit)
    tinsert(ctrl.group.queue, unit)
end

function ctrl.group:checkQueue()
    if InCombatLockdown() then return end
    if #ctrl.group.queue == 0 then return end
    local unit = ctrl.group.queue[1]
    self:debug('checkQueue(' .. unit .. ')')
    if not UnitExists(unit) then self:moveUnitToEndOfQueue(unit); return end
    ctrl.group.inspectingUnit = unit
    NotifyInspect(unit)
    self:moveUnitToEndOfQueue(unit)
    self:debug('NotifyInspect(' .. unit .. ')')
end

function ctrl.group:addGuid(guid, unit)
    if not guid then return end
    self:debug('addGuid(' .. guid .. ', ' ..  unit .. ')')
    if ctrl.data.unit[guid] then
        ctrl.group.guid[guid] = ctrl.cp(ctrl.data.unit[guid])
    else
        ctrl.group.guid[guid] = ctrl.cp(defaultUnit)
        ctrl.group.guid[guid].name = UnitName(unit) or 'Unknown'
        ctrl.group.guid[guid].class = select(2, UnitClass(unit)) or 'Unknown'
        ctrl.group.guid[guid].pvpName = UnitPVPName(unit) or ctrl.group.guid[guid].name
    end
    ctrl.group.guid[guid].unit = unit
    local tempRole = UnitGroupRolesAssigned(unit)
    if tempRole and tempRole ~= 'NONE' then
        ctrl.group.guid[guid].role = tempRole
    end
end

function ctrl.group:check(unit)
    local guid = UnitGUID(unit)
    if not guid then return end
    ctrl.group.unit[unit] = guid
    if not ctrl.group.guid[guid] then self:addGuid(guid, unit) end
    tinsert(ctrl.group.queue, unit)
    if ctrl.group.guid[guid].name ~= UnitName(unit) then
        ctrl.group.guid[guid].name = UnitName(unit) or 'Unknown'
    end
end

function ctrl.group:scan()
    self:debug('scan()')
    ctrl.group.queue = {}
    ClearInspectPlayer()
    self.unitId, self.groupSize = ctrl.groupConfig()
    for i = 1, self.groupSize do
        local unit = self.unitId .. i
        if unit == 'party5' or unit == 'player1' then unit = 'player' end
        if UnitIsPlayer(unit) then
            self:check(unit)
        else
            self.unit[unit] = nil
        end
    end
    ctrl.group.flag.scanGroup = nil
end

function ctrl.group:tick(interval)
    if interval == 1 then
        if ctrl.group.flag.scanGroup then ctrl.group:scan() end
    elseif interval == 3 then
        ctrl.group:checkQueue()
    end
end

function ctrl.group.GROUP_ROSTER_UPDATE(evt)
    ctrl.group.flag.scanGroup = 1
end

function ctrl.group.PLAYER_ENTERING_WORLD()
    ctrl.group.flag.scanGroup = 1
    ctrl.group.myGuild = GetGuildInfo('player') or 'None'
end

function ctrl.group.setup(self)
    --
end

ctrl.group:init()
