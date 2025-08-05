--[[ ctrl - inspect.lua - t@wse.nyc - 2 August 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s = ctrl.c, ctrl.s

local mod = {
    name = 'inspect',
    color = c.r,
    symbol = s.boobs,
    guild = nil,
    guid = {},
    queue = {},
    options = {
        events = {
            'INSPECT_READY',
        },
        timers = {
            2,
        },
        expiry = 60,
    },
}

ctrl.inspect = ctrl.mod:new(mod)

local default = {
    name = nil,
    class = nil,
    role = nil,
    itemLevel = 0,
    inv = {},
    specializationID = 0,
    specializationName = 'Unknown',
    t = 0,
}

function ctrl.inspect.INSPECT_READY(evt)
    --ctrl.inspect:debug('INSPECT_READY(' .. tostring(evt[1]) .. ')')
    ctrl.inspect:reply(evt[1])
end

function ctrl.inspect:reply(guid)
    if not guid or not C_PlayerInfo.GUIDIsPlayer(guid) then return end
    local entry = nil
    for i=1,#ctrl.inspect.queue do
        --self:debug('comparing ' .. guid .. ' with ' .. ctrl.inspect.queue[i][2])
        if ctrl.inspect.queue[i][2] == guid then entry = ctrl.inspect.queue[i]; break end
    end
    if not entry then
        --ctrl.inspect:debug('no entry for ' .. guid)
        return
    end
    local unit, _, inParty, ts = unpack(entry)
    if UnitGUID(unit) == guid then
        --self:debug('found entry, updating '..unit..' '..guid)
        self:update(unit, guid, inParty)
    end
    --ctrl.inspect:debug('removing from queue: ' .. unit)
    self:remove(unit)
end

function ctrl.inspect:update(unit, guid, inParty)
    ctrl.inspect.guid[guid] = ctrl.inspect.guid[guid] or {}
    ctrl.inspect.guid[guid].name = UnitName(unit)
    ctrl.inspect.guid[guid].class = select(2, UnitClass(unit))

    local specID = GetInspectSpecialization(unit)
    if specID then
        ctrl.inspect.guid[guid].specializationID = specID
        local _, name, _, _, role = GetSpecializationInfoByID(specID)
        ctrl.inspect.guid[guid].specializationName = name
        ctrl.inspect.guid[guid].role = role
    end

    local ilvl = C_PaperDollInfo.GetInspectItemLevel(unit)
    if ilvl then ctrl.inspect.guid[guid].itemLevel = ilvl end

    if inParty then
        ctrl.inspect.guid[guid].inv = {}
        for i=1,19 do
            local itemLink = GetInventoryItemLink(unit, i)
            if itemLink then
                local _, _, _, itemLevel = C_Item.GetItemInfo(itemLink)
                ctrl.inspect.guid[guid].inv[i] = {}
                ctrl.inspect.guid[guid].inv[i].itemLink = itemLink
                ctrl.inspect.guid[guid].inv[i].itemLevel = itemLevel
            end
        end
    end

    ctrl.inspect.guid[guid].t = GetServerTime()
    if GetGuildInfo(unit) == ctrl.inspect.guild then
        ctrl.data.unit[guid] = ctrl.data.unit[guid] or {}
        ctrl.merge(ctrl.data.unit[guid], ctrl.inspect.guid[guid])
    end
    ClearInspectPlayer()
    self:remove(unit)
end

function ctrl.inspect:check()
    if InCombatLockdown() or #ctrl.inspect.queue == 0 then return end
    local unit, guid, inParty, ts = unpack(ctrl.inspect.queue[1])
    --self:debug('check(' .. unit .. ', ' .. guid .. ', ' .. tostring(inParty) .. ', ' .. ts .. ')')
    if UnitExists(unit) then
        NotifyInspect(unit)
    else
        self:remove(unit)
        if inParty and GetServerTime() > (ts + 300) then table.insert(ctrl.inspect.queue, {unit, guid, inParty, ts}) end
    end
end

function ctrl.inspect:remove(unit)
    for i=1,#ctrl.inspect.queue do
        if ctrl.inspect.queue[i][1] == unit then table.remove(ctrl.inspect.queue, i); break end
    end
end

function ctrl.inspect:add(unit)
    local guid = UnitGUID(unit)
    if not guid or not C_PlayerInfo.GUIDIsPlayer(guid) then return end
    local inQueue = nil
    for i=1,#ctrl.inspect.queue do
        if ctrl.inspect.queue[i][1] == unit then inQueue = true; break end
    end
    local inParty = nil
    if strsub(unit, 1, 5) == 'party' or strsub(unit, 1, 4) == 'raid' then inParty = true end
    if not inQueue then table.insert(ctrl.inspect.queue, {unit, guid, inParty, GetServerTime()}) end
end

function ctrl.inspect.unit(unit)
    ctrl.inspect.guild = ctrl.inspect.guild or GetGuildInfo('player')
    local guid = UnitGUID(unit)
    if not guid or not C_PlayerInfo.GUIDIsPlayer(guid) then return end
    if not ctrl.inspect.guid[guid] or ctrl.inspect.guid[guid].t < (C_DateAndTime.GetServerTimeLocal() - ctrl.inspect.options.expiry) then
        ctrl.inspect:add(unit); return nil end
    return ctrl.inspect.guid[guid]
end

function ctrl.inspect.tick()
    ctrl.inspect:check()
end

function ctrl.inspect.setup(self)
    --
end

ctrl.inspect:init()
