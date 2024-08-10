--[[ ctrl - sys.lua - t@wse.nyc - 7/24/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local mod = {
    name = 'sys',
    color = ctrl.c.c,
    symbol = ctrl.s.sys,
    options = {
        events = {
            'VARIABLES_LOADED',
            'PLAYER_ENTERING_WORLD',
            'PLAYER_LEAVING_WORLD',
            'PLAYER_LOGIN',
            'PLAYER_LOGOUT',
            'PLAYER_QUITING',
            --'CVAR_UPDATE',
            'LUA_WARNING',
            'ADDON_ACTION_BLOCKED',
            'ADDON_ACTION_FORBIDDEN',
            'MACRO_ACTION_BLOCKED',
            'MACRO_ACTION_FORBIDDEN',
            'GENERIC_ERROR',
            'UI_ERROR_MESSAGE',
            'UI_ERROR_POPUP',
            'UI_INFO_MESSAGE',
            'SYSMSG',
            'CONSOLE_MESSAGE',

            'UI_SCALE_CHANGED',
            'DISPLAY_SIZE_CHANGED',
            'UPDATE_ALL_UI_WIDGETS',
            'UPDATE_UI_WIDGET',

            'INITIAL_HOTFIXES_APPLIED',

            'ENCOUNTER_START',
            'ENCOUNTER_END',
            'PLAYER_REGEN_DISABLED',
            'PLAYER_REGEN_ENABLED',
        },
    }
}

ctrl.sys = ctrl.mod:new(mod)

-- crude temp module to spit out some events

function ctrl.sys.evt(self, e, ...)
    self:debug('sys received evt:', e[1])
end

--[[
function ctrl.sys:on()
    self:debug('on')
    self:registerEventTable()
    self:debug('enabled')
end

function ctrl.sys:off()
    self:debug('off')
    self:unregisterEventTable()
    self:debug('disabled')
end
]]

function ctrl.sys.setup(self)
    self:debug('sys loaded.')
end

ctrl.sys:init()
