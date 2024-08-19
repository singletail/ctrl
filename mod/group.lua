--[[ ctrl - tgt.lua - t@wse.nyc - 8/7/24 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitClass = UnitClass
local GetGuildInfo = GetGuildInfo
local UnitName = UnitName
local UnitRace = UnitRace
local UnitPVPName = UnitPVPName
local UnitLevel = UnitLevel
local UnitSex = UnitSex
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsConnected = UnitIsConnected
local UnitIsGroupLeader = UnitIsGroupLeader
local GetRaidTargetIndex = GetRaidTargetIndex
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

local mod = {
    name = 'group',
    color = c.v,
    symbol = s.group,
    drawTable = {},
    unitId = 'player',
    groupSize = 1,
    flag = {
        scanGroup = 1,
    },
    options = {
        numStrings = 25,
        numFields = 4,
        fieldW = {28, 100, 56, 36},
        lineHeight = 24,
        timers = {
            1,
            0.2,
        },
        events = {
            'PLAYER_ENTERING_WORLD',
            'GROUP_ROSTER_UPDATE',
        },
        frame = {
            name = 'ctrlgroup',
            w=220,
            h=172,
            isResizable = nil,
            isMovable = nil,
            globalName = 'ctrlgroup',
            isClipsChildren = nil,
        },
    }
}

ctrl.group = ctrl.mod:new(mod)

-- TODO: Load from saved variables
ctrl.group.unit = ctrl.group.unit or {}
ctrl.group.guid = ctrl.group.guid or {}


local textures = {
    ['txinfo'] = { target = 'main', t = 'metal_34_v', path = ctrl.p.tx, l = -6 },
    ['tnasa'] = { target = 'main', t = 'nasa_43_b', path = ctrl.p.test, l = -5, w=210, h=164 },
}

local fs_default = {
    fontFile = 'Hack-Regular.ttf',
    fontSize = 18,
    x = 0,
    y = 0,
    a = a.tl,
    pa = a.tl,
    jH = a.l,
    target = 'main',
    t = ''
}

local fs_override = {
    ['f1'] = { fontSize = 18, y=-2},
    ['f2'] = { fontFile = 'Prompt-Medium.ttf', fontSize = 18, y=-2},
    ['f3'] = { jH = a.r }
}

local function createFontStrings()
    for i=1, ctrl.group.options.numStrings do
        local curX = 18
        for f = 1, ctrl.group.options.numFields do
            local o = {}
            for k,v in pairs(fs_default) do o[k] = v end
            if fs_override['f'..f] then for k,v in pairs(fs_override['f'..f]) do o[k] = v end end
            o.x = o.x + curX
            o.w = ctrl.group.options.fieldW[f]
            o.h = ctrl.group.options.lineHeight
            o.y = o.y + -16 - (ctrl.group.options.lineHeight * (i-1))
            ctrl.group.fs['l'..i] = ctrl.group.fs['l'..i] or {}
            ctrl.group.fs['l'..i]['f'..f] = ctrl.fs.new(ctrl.group, o)
            ctrl.group.fs['l'..i]['f'..f]:SetText(tostring(i) .. ' ' .. tostring(f))
            curX = curX + ctrl.group.options.fieldW[f]
        end
    end
end

function ctrl.group:updateGuidEntryClass(unit, guid)
    if not unit or not guid or not ctrl.group.guid[guid] then return end
    local g = ctrl.group.guid[guid]
    if not g.classFilename or g.classFilename == 'Unknown' then
        local className, classFilename, classId = UnitClass(unit)
        g.className = className or 'Unknown'
        g.classFilename = classFilename or 'Unknown'
        g.classId = classId or 'Unknown'
    end
end

function ctrl.group:updateGuidEntryGuild(unit, guid)
    if not unit or not guid or not ctrl.group.guid[guid] then return end
    local g = ctrl.group.guid[guid]
    if not g.guildName then
        local gn, gr, _, rr = GetGuildInfo(unit)
        g.guildName = gn
        g.guildRank = gr
        g.realm = rr
    end
end

function ctrl.group:updateGuidEntryColor(unit, guid)
    if not unit or not guid or not ctrl.group.guid[guid] then return end
    local g = ctrl.group.guid[guid]
    if g.classFilename and g.classFilename ~= 'Unknown' then
        g.classColor = C_ClassColor.GetClassColor(g.classFilename)
    end
    local cr,cg,cb = g.classColor:GetRGB()
    g.r = cr or 0.6
    g.g = cg or 0.6
    g.b = cb or 0.6
    local ch = g.classColor:GenerateHexColor() or ctrl.c.a
    g.hex = '|c' .. ch
end

function ctrl.group:refreshGuidEntry(unit, guid)
    if not unit or not guid then return end
    if not ctrl.group.guid[guid] then self:createGuidEntry(unit, guid) end
    local g = ctrl.group.guid[guid]
    g.unit = unit
    if not g.name or g.name == 'Unknown' then g.name = UnitName(unit) or 'Unknown' end
    g.race = UnitRace(unit) or 'Unknown'
    g.PVPname = UnitPVPName(unit) or 'Unknown'
    g.level = UnitLevel(unit)
    g.unitSex = UnitSex(unit)
    if not g.classFilename or g.classFilename == 'Unknown' then self:updateGuidEntryClass(unit, guid) end
    if not g.hex or g.hex == ctrl.c.a then self:updateGuidEntryColor(unit, guid) end
    self:updateGuidEntryGuild(unit, guid)
    g.isFriend = C_FriendList.IsFriend(guid)
    g.isIgnored = C_FriendList.IsIgnored(unit)
end

function ctrl.group:createGuidEntry(unit, guid)
    if not unit or not guid then return end
    ctrl.group.guid[guid] = {}
    local g = ctrl.group.guid[guid]
    g.guid = guid
    g.unit = unit
    self:refreshGuidEntry(unit, guid)
end

function ctrl.group:addUnit(unit, guid)
    ctrl.group.unit[unit] = { guid = guid }
    local u = ctrl.group.unit[unit]
    self:refreshGuidEntry(unit, guid)
    local g = ctrl.group.guid[guid]
    u.name = g.name
    u.hex = g.hex
end

function ctrl.group:updateUnit(unit)
    if not ctrl.group.unit[unit] then ctrl.group:addUnit(unit, UnitGUID(unit)) end
    local u = ctrl.group.unit[unit]
    u.unitHealth = UnitHealth(unit) or 0
    u.unitHealthMax = UnitHealthMax(unit) or 0
    u.healthPct = math.floor((u.unitHealth / u.unitHealthMax) * 100)
    u.healthPctStr = ctrl.healthPctStr(u.healthPct)
    u.isDead = UnitIsDead(unit)
    u.isGhost = UnitIsGhost(unit)
    u.isAFK = UnitIsAFK(unit)
    u.isDND = UnitIsDND(unit)
    u.isConnected = UnitIsConnected(unit)
    u.isLeader = UnitIsGroupLeader(unit)
    u.raidTargetIndex = GetRaidTargetIndex(unit)
    -- TODO: Auras, Threat
end

function ctrl.group:checkUnit(unit)
    local guid = UnitGUID(unit)
    if not ctrl.group.guid[guid] then self:createGuidEntry(unit, guid) end
    if not ctrl.group.unit[unit] or guid ~= ctrl.group.unit[unit].guid then
        self:addUnit(unit, guid)
    end
    u.role = UnitGroupRolesAssigned(unit) or 'NONE'
end

function ctrl.group:scanGroup()
    self.unitId, self.groupSize = ctrl.groupConfig()
    for i=1,self.groupSize do
        local unit = self.unitId..i
        if unit == 'party5' or unit == 'player1' then unit = 'player' end
        if UnitExists(unit) then self:checkUnit(unit) else ctrl.group.unit[unit] = nil end
    end
    ctrl.group.flag.scanGroup = nil
end

function ctrl.group:updateUnits()
    for i=1,self.groupSize do
        local unit = self.unitId..i
        if unit == 'party5' or unit == 'player1' then unit = 'player' end
        if UnitExists(unit) then self:updateUnit(unit) else ctrl.group.unit[unit] = nil end
    end
end

function ctrl.group:draw()
    local line = 1
    for i=1,self.groupSize do
        local unit = self.unitId..i
        if unit == 'party5' or unit == 'player1' then unit = 'player' end
        local u = self.unit[self.unitId..i]
        if u then
            local col = u.hex or c.a
            if u.isDead then col = c.dim end
            self.fs['line'..line]['field1']:SetText(col..tostring(s[u.role]))
            self.fs['line'..line]['field2']:SetText(col..tostring(u.name))
            self.fs['line'..line]['field3']:SetText(tostring(u.healthPctStr))
            line = line + 1
        end
    end
end

function ctrl.group:tick(interval)
    if interval == 1 then
        if ctrl.group.flag.scanGroup then ctrl.group:scanGroup() end
    else
        ctrl.group:updateUnits()
        ctrl.group:draw()
    end
end

function ctrl.group.GROUP_ROSTER_UPDATE()
    ctrl.group.flag.scanGroup = 1
end

function ctrl.group.PLAYER_ENTERING_WORLD()
    ctrl.group.flag.scanGroup = 1
end

function ctrl.group.setup(self)
    ctrl.group.f.main = ctrl.frame.new(ctrl.group, ctrl.group.options.frame)
    ctrl.tx.generate(ctrl.group, textures)
    createFontStrings()
    ctrl.group:registerCtrlFrame(5, ctrl.group.f.main)
    ctrl.group.unitId, ctrl.group.groupSize = ctrl.groupConfig()
end

ctrl.group:init()
