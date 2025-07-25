--[[ ctrl - tgt.lua - t@wse.nyc - 8/7/24 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'tgt',
    color = c.g,
    symbol = s.target,
    options = {
        numFontStrings = 10,
        timers = { 1, },
        events = {
            'PLAYER_TARGET_CHANGED',
            'PLAYER_ENTERING_WORLD',
            'INSPECT_READY',
        },
        frame = {
            name = 'ctrltgt',
            isResizable = nil,
            isMovable = nil,
            target = ctrl.power.f.main,
            isClipsChildren = nil,
        },
    }
}

ctrl.tgt = ctrl.mod:new(mod)
local u = 'target'

ctrl.tgt.target = ctrl.tgt.target or {}
ctrl.tgt.cache = ctrl.tgt.cache or {}
ctrl.tgt.buffer = {}

local textures = { ['bk'] = { target='main', t='mon2_188', l=-8, al=0.6 }, }

function ctrl.tgt:createFontStrings()
    local iconSettings = {t='', target='main', fontFile=ctrl.prefs.mod.tgt.font.file, fontSize=ctrl.prefs.mod.tgt.icon.size, x=ctrl.prefs.mod.tgt.icon.x, y=ctrl.prefs.mod.tgt.icon.y, a=a.tl, pa=a.tl,}
    ctrl.tgt.fs['fsicon'] = ctrl.fs.new(ctrl.tgt, iconSettings)
    local defaultfs = {t='', target='main', fontFile=ctrl.prefs.mod.tgt.font.file, fontSize=ctrl.prefs.mod.tgt.font.size, x=0, y=0, a=a.t, pa=a.t, jH=a.c}
    for i=1, self.options.numFontStrings do
        local o = ctrl.cp(defaultfs)
        o.t="fs"..i
        o.y = ctrl.prefs.mod.tgt.font.top - ((ctrl.prefs.mod.tgt.font.spacing + ctrl.prefs.mod.tgt.font.size) * (i-1))
        ctrl.tgt.fs['fs'..i] = ctrl.fs.new(ctrl.tgt, o)
    end
end

-- Inspect (experimental)

function ctrl.tgt.INSPECT_READY(evt)
    if evt and evt[1] and ctrl.tgt.target and evt[1] == ctrl.tgt.target.guid then
        ctrl.tgt:inspect()
    end
end

function ctrl.tgt:inspect()
    self.target.itemLevel = C_PaperDollInfo.GetInspectItemLevel(u)
    self.target.specializationID = GetInspectSpecialization(u)
    self.target.specializationName = GetSpecializationNameForSpecID(self.target.specializationID)
    self.target.role = GetSpecializationRoleByID(self.target.specializationID)
    self.cache[self.target.guid].itemLevel = self.target.itemLevel
    self.cache[self.target.guid].specializationID = self.target.specializationID
    self.cache[self.target.guid].specializationName = self.target.specializationName
    ClearInspectPlayer()
    self:draw()
end

-- Draw

function ctrl.tgt:refresh()
    ctrl.tgt.fs['fsicon']:SetText(string.format('%s%s', self.target.color or c.w, self.target.icon or ''))
    for i=1,ctrl.tgt.options.numFontStrings do
        ctrl.tgt.fs['fs'..i]:SetText(self.buffer[i] or '')
    end
end

function ctrl.tgt:drawMob()
    if self.target.spawnId and self.target.spawnId > 0 then
        self.buffer[1] = string.format('%s%s %d', self.target.color, self.target.name, self.target.spawnId)
    else
        self.buffer[1] = string.format('%s%s', self.target.color, self.target.name)
    end
    if _G.CtrlDB and _G.CtrlDB[self.target.npcId] then
        local entry = _G.CtrlDB[self.target.npcId]
        self.target.icon = entry.p[1] or self.target.icon or ''
        self.target.color = entry.p[3] or self.target.color
        if entry.t then self.buffer[2] = entry.t end
        if entry.t2 then self.buffer[3] = entry.t2 end
    else
        self.buffer[2] = string.format('%s%s %s %s', c.w, self.target.unitCreatureFamily or '', self.target.unitCreatureType or '', self.target.unitType or '')
        self.buffer[3] = string.format('%s%s %s %s', c.w, self.target.unitClassification or '', self.target.unitFamily or '', self.target.unitType or '')
    end
    self.buffer[4] = string.format('%s%s %s %d', c.w, self.target.race or '', self.target.className or '', self.target.level or 0)
    self.buffer[10] = string.format('%snpcId: %d', c.y, self.target.npcId or 0)
end

function ctrl.tgt:drawPlayer()
    self.buffer[1] = string.format('%s%s', self.target.color, self.target.pvpName or self.target.name)
    self.buffer[2] = string.format('%s%s', c.g, self.target.guildName or '')
    self.buffer[3] = string.format('%s%s', c.b, self.target.guildRank or '')
    self.buffer[4] = string.format('%s%s %s %d', self.target.color, self.target.specializationName or '', self.target.className or '', self.target.level or 0)
    if self.target.itemLevel then self.buffer[9] = string.format('%siLvl %d', c.g, self.target.itemLevel) end
    self.buffer[10] = string.format('%s%s', c.v, self.target.guid)
end

function ctrl.tgt:draw()
    if not self.target then self:blank(); return end
    if self.target.isPlayer then self:drawPlayer() else self:drawMob() end
    self:updateStats()
    self:refresh()
end


-- Status

function ctrl.tgt:numShort(n)
    if not n or n < 0 then return '0' end
    if n >= 1000000 then
        return string.format('%.1fm', n / 1000000)
    elseif n >= 1000 then
        return string.format('%.1fk', n / 1000)
    else
        return tostring(n)
    end
end

function ctrl.tgt:healthColor(h)
    if h == 100 then
        return c.w
    elseif h >= 75 then
        return c.g
    elseif h >= 50 then
        return c.y
    elseif h >= 25 then
        return c.o
    else
        return c.r
    end
end

function ctrl.tgt:getHealth(line)
    line = line or 5
    if not UnitExists(u) then
        self.buffer[line] = ''
    elseif UnitIsDeadOrGhost(u) then
        self.buffer[line] = string.format('%s%s %s', c.w, s.dead, 'DEAD')
    else
        local h = UnitHealth(u, false)
        local mh = UnitHealthMax(u)
        local hp = math.floor((h / mh) * 100)
        self.buffer[line] = string.format('%s%s / %s (%d%%)', self:healthColor(hp), self:numShort(h), self:numShort(mh), hp)
    end
end

function ctrl.tgt:getAggro(line)
    line = line or 6
    if UnitExists(u) and not UnitIsDeadOrGhost(u) and UnitAffectingCombat(u) then
        local isTanking, _, scaledPercentage, _, _ = UnitDetailedThreatSituation('player', u)
        if isTanking then
            self.buffer[line] = string.format('%s%s %d%%', c.o, 'AGGRO', scaledPercentage or 0)
        else
            self.buffer[line] = string.format('%s%s', c.y, 'Combat')
        end
    else
        self.buffer[line] = ''
    end
end

function ctrl.tgt:getTarget(line)
    line = line or 7
    if not UnitExists(u) or UnitIsDeadOrGhost(u) then self.buffer[line] = ''; return end
    local name = UnitName('targettarget')
    if not name then self.buffer[line] = ''; return end
    local col = ctrl.tgt:getSelectionColor('targettarget') or c.w
    local icon = s.target
    if UnitIsUnit('targettarget', 'player') then col = c.p; icon = s.alert end
    self.buffer[line] = string.format('%s%s %s', col, icon, name)
end

function ctrl.tgt:getRange(line)
    line = line or 8
    if UnitExists(u) and not UnitIsDeadOrGhost(u) then
        local range = ctrl.unitRange(u) or 0
        if range > 0 then
            self.buffer[line] = string.format('%sRange: %d', c.o, range)
        else
            self.buffer[line] = string.format('%sOut of Range', c.r)
        end
    else
        self.buffer[line] = ''
    end
end

function ctrl.tgt:updateStats()
    self:getHealth(5)
    self:getAggro(6)
    self:getTarget(7)
    self:getRange(8)
end

-- Mob

function ctrl.tgt:getSelectionColor(unit)
    local r, g, b, alpha = UnitSelectionColor(unit)
    local color = CreateColor( r, g, b, alpha )
    local hex = color:GenerateHexColor() or 'ffaaaaaa'
    return (string.format('|c%s', hex))
end

function ctrl.tgt:npcId(guid)
    local _, _, _, _, _, npcId, _ = strsplit("-", guid)
    if tonumber(npcId) and tonumber(npcId) > 0 then return tonumber(npcId) end
    return nil
end

function ctrl.tgt:spawnIndex(guid)
    local _, _, _, _, _, _, spawnId = strsplit("-", guid)
    local spawnIndex = bit.rshift(bit.band(tonumber(string.sub(spawnId, 1, 5), 16), 0xffff8), 3)
    return spawnIndex
end

function ctrl.tgt:spawnTime(guid)
    local _, _, _, _, _, _, spawnId = strsplit("-", guid)
    local spawnEpoch = GetServerTime() - (GetServerTime() % 2^23)
    local spawnEpochOffset = bit.band(tonumber(string.sub(spawnId, 5), 16), 0x7fffff)
    local spawnTime = spawnEpoch + spawnEpochOffset
    return spawnTime
end

function ctrl.tgt:addMob(guid)
    local className, classFilename, classId = UnitClass(u)
    local t = {
        guid = guid,
        isPlayer = nil,
        name = UnitName(u),
        npcId = self:npcId(guid),
        spawnIndex = self:spawnIndex(guid),
        unitClassification = UnitClassification(u),
        unitCreatureFamily = UnitCreatureFamily(u),
        unitCreatureType = UnitCreatureType(u),
        unitSelectionType = UnitSelectionType(u),
        race = UnitRace(u),
        className = className,
        classFilename = classFilename,
        classId = classId,
        level = UnitLevel(u),
        color = self:getSelectionColor(u),
    }
    self.target = ctrl.cp(t)
    self.cache[guid] = ctrl.cp(t)
end

-- Player

function ctrl.tgt:getPlayerIcon(t)
    if s[t.guid] then return s[t.guid] end
    if t.isFriend then return s.heart end
    if t.isIgnored then return s.anus end
    if t.role and s[t.role] then return s[t.role] end
    if t.guildName and s[t.guildName] then return s[t.guildName] end
    if t.classFilename and s[t.classFilename] then return s[t.classFilename] end
    return '䃿'
end

function ctrl.tgt:getPlayerColor(t)
    if t.isFriend then return c.p end
    if t.isIgnored then return c.r end
    if t.guildName and t.guildName == ctrl.tgt.guildName then return c.c end
    local hex = select(4, GetClassColor(t.classFilename)) or 'ffaaaaaa'
    return (string.format('|c%s', hex))
end

function ctrl.tgt:addPlayer(guid)
    local className, classFilename, classId = UnitClass(u)
    local guildName, guildRank = GetGuildInfo(u)
    local t = {
        guid = guid,
        isPlayer = true,
        name = UnitName(u),
        pvpName = UnitPVPName(u),
        race = UnitRace(u),
        className = className,
        classFilename = classFilename,
        classId = classId,
        level = UnitLevel(u),
        guildName = guildName,
        guildRank = guildRank,
        isFriend = C_FriendList.IsFriend(guid)
    }
    t.color = ctrl.tgt:getPlayerColor(t)
    t.icon = ctrl.tgt:getPlayerIcon(t)
    self.target = ctrl.cp(t)
    self.cache[guid] = ctrl.cp(t)
    NotifyInspect(u)
end

-- Methods

function ctrl.tgt:add(guid)
    if C_PlayerInfo.GUIDIsPlayer(guid) then self:addPlayer(guid) else self:addMob(guid) end
end

function ctrl.tgt:checkCache(guid)
    if not guid then
        ctrl.tgt.target = {}
        return true
    end
    if self.target.guid == guid then
        return true
    end
    if self.cache[guid] then
        self.target = ctrl.cp(self.cache[guid])
        return true
    end
    return nil
end

function ctrl.tgt:update()
    local guid = UnitGUID(u)
    if not guid then
        self.target = {}
        self:blank()
        return
    end
    if not self:checkCache(guid) then self:add(guid) end
    self:draw()
end

function ctrl.tgt:blank()
    for i=1,ctrl.tgt.options.numFontStrings do
        ctrl.tgt.fs['fs'..i]:SetText('')
    end
end

function ctrl.tgt:tick()
    if not ctrl.tgt.target then return end
    self:updateStats()
    self:refresh()
end

function ctrl.tgt.PLAYER_TARGET_CHANGED()
    ctrl.tgt:update()
end

function ctrl.tgt.PLAYER_ENTERING_WORLD()
    ctrl.tgt.guildName = GetGuildInfo('player')
end

function ctrl.tgt:prefs()
    self.options.frame.w = ctrl.prefs.mod.tgt.frame.width
    self.options.frame.h = ctrl.prefs.ui.height
end

function ctrl.tgt:setup()
    self:prefs()
    self.f.main = ctrl.frame:new(self.options.frame)
    ctrl.tx.generate(ctrl.tgt, textures)
    self:createFontStrings()
    self:registerCtrlFrame(3, self.f.main)
end

ctrl.tgt:init()
