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
            'unit',
            'loot',
            'logs',
        }
    },
    ready = nil,
}

ctrl.data = ctrl.mod:new(mod)

function ctrl.data:login()
    --_G.ctrldata = {} -- wipe data
    _G.ctrldata = _G.ctrldata or {}
    for _, v in pairs(self.options.db) do
        _G.ctrldata[v] = _G.ctrldata[v] or {}
        ctrl.data[v] = _G.ctrldata[v]
        if not ctrl.data[v] then
            ctrl.error(ctrl.data, 2, 'ctrl:data table ' .. v .. ' not initialized')
        end
    end
    ctrl.data:inc()
    ctrl.data.ready = 1
end

function ctrl.data:inc()
    ctrl.data.prefs.last = GetServerTime()
    ctrl.data.prefs.guid = UnitGUID("player")
end

function ctrl.data.SAVED_VARIABLES_TOO_LARGE(evt)
    ctrl.data:crit('SAVED_VARIABLES_TOO_LARGE ' .. tostring(evt[1]))
end

function ctrl.data.setup(self)
    --self:debug('ctrl.data module setup()')
end

ctrl.data:init()
