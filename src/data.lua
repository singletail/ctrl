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

function ctrl.data:status()
    self.prefs.version = self.prefs.version or ctrl.version
    self.prefs.last = self.prefs.last or 0
    self:debug(ctrl.c.r .. 'version: ' .. self.prefs.version)
    self:debug(ctrl.c.r .. 'last login: ' .. ts(self.prefs.last))
end

function ctrl.data:write()
    self.prefs.last = GetServerTime()
    self.prefs.guid = UnitGUID('player')
    self.prefs.name = UnitName('player')
end

function ctrl.data.PLAYER_LOGOUT()
    ctrl.data:write()
end

function ctrl.data.setup(self)
    self:debug('setup()')
    ctrlprefs = ctrlprefs or {}
    self.prefs = ctrlprefs
    self:status()
end

ctrl.data:init()
