--[[ ctrl - logs.lua - t@wse.nyc - 7/25/24 ]] --

---@class ctrl
local ctrl = select(2, ...)
local c, s = ctrl.c, ctrl.s

local tinsert, tremove, wipe = table.insert, table.remove, table.wipe
local date = date
local tostring = tostring
local GetServerTime = GetServerTime

local lvl = {
    [1] = { 'emerg', c.c, s.emerg },
    [2] = { 'alert', c.p, s.alert },
    [3] = { 'crit', c.o, s.crit },
    [4] = { 'error', c.r, s.bug },
    [5] = { 'warn', c.o, s.warn },
    [6] = { 'notice', c.y, s.notice },
    [7] = { 'info', c.w, s.info },
    [8] = { 'debug', c.g, s.ghost },
}

local function timestamp(msgObj)
    return string.format('%s%s%s', c.a, date('%I:%M:%S', msgObj.ts), c.d)
end

local function moduleStr(msgObj)
    return string.format('%s%s[%s%s:%s%s%s%s]%s', c.d, c.r, ctrl.name,
        c.a, msgObj.color, msgObj.name, c.d, c.r, c.d)
end

local function levelStr(msgObj)
    local levelObj = lvl[msgObj.level]
    return string.format('%s%s', tostring(levelObj[2]), tostring(levelObj[3]))
end

local function msgStr(msgObj) -- copied from Blizzard's print function
    local msgString = ''
    for i = 1, msgObj.msgTbl.n do
        if i > 1 then msgString = msgString .. ", " end
        msgString = msgString .. tostring(msgObj.msgTbl[i])
    end
    return msgString
end

local function formatMsg(msgObj)
    return string.format('%s %s %s %s', timestamp(msgObj), moduleStr(msgObj),
        levelStr(msgObj), msgStr(msgObj))
end

local function prnt(msgObj)
    local msg = formatMsg(msgObj)
    if ctrl.console and ctrl.console.is.loaded then --TODO: Change to console exists
        ctrl.sf:AddMessage(msg)
    else
        print(msg)
    end
end

local function writeToLog(msgObj)
    if msgObj.level > ctrl.prefs.log.level then return end
    ctrl.prefs.log.index = ctrl.prefs.log.index + 1
    local logMsg = ''
    for i = 1, msgObj.msgTbl.n do
        if i > 1 then logMsg = logMsg .. ', ' end
        logMsg = logMsg .. tostring(msgObj.msgTbl[i])
    end
    local logObj = {ctrl.prefs.log.index, msgObj.ts, msgObj.name, logMsg}
    tinsert(ctrl.data.logs, logObj)
    if ctrl.count(ctrl.data.logs) > ctrl.prefs.log.max then tremove(ctrl.data.logs, 1) end
end

local function dispatch(msgObj)
    if ctrl.is.loaded then
        if ctrl.prefs.log.enable then writeToLog(msgObj) end
        prnt(msgObj)
    else
        tinsert(ctrl.buffer, msgObj)
    end
end

local function normalize(level)
    level = tonumber(level) or 5
    if level > 8 then level = 8 end
    if level < 1 then level = 1 end
    return level
end

local function msgObj(module, level, ...)
    local msgTbl = ctrl.pack(...)
    if next(msgTbl) == nil then msgTbl = ctrl.pack(level) end
    if next(msgTbl) == nil then msgTbl = ctrl.pack(s['?']) end
    level = normalize(level)
    local id = ctrl.cp(module.addon)
    return {
        ts = GetServerTime(),
        level = tonumber(level) or 5,
        msgTbl = msgTbl,
        name = module.name or s['nul'],
        color = module.color or c.w,
        symbol = module.symbol or s['nul'],
        addon = id
    }
end

local function log(module, level, ...)
    local msgObject = msgObj(module, level, ...)
    dispatch(msgObject)
end

local function dumpBuffer()
    local n = ctrl.count(ctrl.buffer)
    for i = 1, n do
        prnt(ctrl.buffer[i])
        if ctrl.prefs.log.enable then writeToLog(ctrl.buffer[i]) end
    end
    wipe(ctrl.buffer)
    ctrl.buffer = nil
end

local function setup(self)
    --self:debug('setup()')
end

local mod = {
    name = 'logs',
    color = c.g,
    symbol = s.log,
    log = log,
    dumpBuffer = dumpBuffer,
    setup = setup,
}

ctrl.logs = ctrl.mod:new(mod)
ctrl.log = ctrl.logs.log

ctrl.logs:init()
