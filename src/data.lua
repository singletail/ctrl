--[[ ctrl - data.lua - t@wse.nyc - 16 July 2025 ]] --

---@class ctrl
local addon, ctrl = ...
local c, s = ctrl.c, ctrl.s

local mod = {
    name = 'data',
    color = c.w,
    symbol = s.db,
    options = {
        events = {
            'SAVED_VARIABLES_TOO_LARGE',
        },
        db = {
            'prefs',
            'player',
            'unit',
            'loot',
            'logs',
        }
    },
}

ctrl.data = ctrl.mod:new(mod)

function ctrl.data:check()
    for _, v in pairs(self.options.db) do
        _G.CtrlData[v] = _G.CtrlData[v] or {}
        ctrl.data[v] = _G.CtrlData[v]
    end
end

function ctrl.data:clean()
    for _, v in pairs(self.options.db) do
        if ctrl.data.prefs[v] and ctrl.data.prefs[v].wipe then ctrl.data[v] = {} end
    end
end

function ctrl.data:count()
    local guid = UnitGUID('player')
    if not guid then ctrl.data:crit('UnitGUID = nil'); return end
    ctrl.data.player[guid] = ctrl.data.player[guid] or {}
    ctrl.data.player[guid].name = UnitName('player')
    ctrl.data.player[guid].realm = GetRealmName()
    ctrl.data.player[guid].last = GetServerTime()
    ctrl.data.player[guid].count = ctrl.data.player[guid].count or 0
    ctrl.data.player[guid].count = ctrl.data.player[guid].count + 1
end

function ctrl.data.SAVED_VARIABLES_TOO_LARGE(evt)
    ctrl.data:crit('SAVED_VARIABLES_TOO_LARGE ' .. tostring(evt[1]))
end

function ctrl.data:login()
    _G.CtrlData = _G.CtrlData or {}
    self:check()
    self:clean()
    self:count()
    self.is.ready = 1
end

ctrl.data:init()
