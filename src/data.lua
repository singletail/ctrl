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
            'ADDON_LOADED',
        },
        db = {
            'pref',
            'unit',
            'raid',
            'loot',
        }
    },
}

ctrl.data = ctrl.mod:new(mod)

function ctrl.data:login()
    for _, v in pairs(self.options.db) do
        _G.ctrldata[v] = _G.ctrldata[v] or {}
        ctrl.data[v] = _G.ctrldata[v]
    end
    self:inc()
end

function ctrl.data:inc()
    ctrl.data.pref.last = GetServerTime()
    ctrl.data.pref.guid = UnitGUID("player")
end

function ctrl.data.ADDON_LOADED(evt)
    if evt and evt[1] == addon and not evt[2] then ctrl.data:login() end
end

function ctrl.data.setup(self)
    _G.ctrldata = _G.ctrldata or {}
end

ctrl.data:init()
