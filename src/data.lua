--[[ ctrl - data.lua - t@wse.nyc - 16 July 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s = ctrl.c, ctrl.s

local mod = {
    name = 'data',
    color = c.w,
    symbol = s.db,
    options = {
        events = {
            'PLAYER_LOGOUT',
        },
    },
}

ctrl.data = ctrl.mod:new(mod)

local function ts(t)
    return string.format('%s',  date('%I:%M:%S', t))
end

function ctrl.data:login()
    self.prefs.version = self.prefs.version or ctrl.version
    self.prefs.last = self.prefs.last or 0
    self.prefs.counter = self.prefs.counter or 0
    self.prefs.counter = self.prefs.counter + 1
    self:debug(ctrl.c.r .. 'ctrl v' .. self.prefs.version .. last: ' .. ts(self.prefs.last))
end

function ctrl.data:write()
    self.prefs.last = GetServerTime()
end

function ctrl.data.PLAYER_LOGOUT()
    ctrl.data:write()
end

function ctrl.data.setup(self)
    self:debug('setup()')
    local data = _G.ctrldata
    ctrl.data.prefs = data.prefs or {}
    ctrl.data.user = data.user or {}
    ctrl.data.unit = data.unit or {}
    ctrl.data.loot = data.loot or {}
    self:login()
    self:write()
end

ctrl.data:init()
