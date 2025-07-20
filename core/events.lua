--[[          ctrl - events.lua - t@wse.nyc - 8/5/24        ]]
--[[   Quality of life event reactions, not event handlers. ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'events',
    color = c.o,
    symbol = s.taunt,
    options = {
        events = {
            --'PLAYER_STARTED_MOVING',
            'DUEL_REQUESTED',
            'PLAYER_REGEN_DISABLED',
            'PLAYER_REGEN_ENABLED',
            'PLAYER_GUILD_UPDATE',
            'ADDON_ACTION_BLOCKED',
            'ADDON_ACTION_FORBIDDEN',
            'MACRO_ACTION_BLOCKED',
            'MACRO_ACTION_FORBIDDEN',
            'SAVED_VARIABLES_TOO_LARGE',
            'CONSOLE_LOG',
            'CONSOLE_MESSAGE',
            'PARTY_LEADER_CHANGED',
            'ENTERED_DIFFERENT_INSTANCE_FROM_PARTY',
            'LUA_WARNING',
            'INITIAL_HOTFIXES_APPLIED',
            'FRAME_MANAGER_UPDATE_ALL',
            'UPDATE_ALL_UI_WIDGETS',
            'OBJECT_ENTERED_AOI',
            'OBJECT_LEFT_AOI',
            'UNIT_FLAGS',
            'GX_RESTARTED',
        },
    }
}

ctrl.events = ctrl.mod:new(mod)

local message = ctrl.newTable('')
message[1] = c.w
message[2] = ' '

function ctrl.events.alert(...)
    local msg, sfx, col = ...
    message[1] = col or c.w
    message[2] = msg or 'ctrl.events'
    ctrl.alert:add(table.concat(message, ''))
    --ctrl.alert:info(table.concat(message, ''))
    if sfx then
        ctrl.sfx:play(tostring(sfx))
    end
end

function ctrl.events.PLAYER_STARTED_MOVING()
    ctrl.events.alert('PLAYER_STARTED_MOVING()', 'alert23', c.y)
end

function ctrl.events.DUEL_REQUESTED(evt)
    local playerName = evt[1] or 'unknown'
    ctrl.events.alert('DUEL_REQUESTED by ' .. playerName, 'tindeck', c.r)
    CancelDuel()
end

function ctrl.events.PLAYER_REGEN_DISABLED()
    ctrl.events.alert('Aggro', nil, c.r)
end

function ctrl.events.PLAYER_REGEN_ENABLED()
    ctrl.events.alert('Combat ended')
end

function ctrl.events.PLAYER_GUILD_UPDATE(evt)
    local unit = evt[1] or 'unknown'
    local name = ''
    if UnitExists(unit) then
        name = UnitName(unit) or unit
    end
    ctrl.events.alert('PLAYER_GUILD_UPDATE(' .. name .. ')', 'among-us-role-reveal-sound', c.c)
end

function ctrl.events.ADDON_ACTION_BLOCKED(evt)
    local isTainted, fn = evt[1], evt[2]
    local msg = 'ADDON_ACTION_BLOCKED('..tostring(isTainted)..')'
    ctrl.events.alert(msg, 'consolewarning', c.r)
    ctrl.events:error(msg)
    if isTainted then ctrl.events:error('Tainted') end
    if fn then ctrl.events:error(tostring(fn)) end
end

function ctrl.events.ADDON_ACTION_FORBIDDEN(evt)
    local isTainted, fn = evt[1], evt[2]
    local msg = 'ADDON_ACTION_FORBIDDEN('..tostring(isTainted)..')'
    ctrl.events.alert(msg, 'consolewarning', c.r)
    ctrl.events:error(msg)
    if isTainted then ctrl.events:error('Tainted') end
    if fn then ctrl.events:error(tostring(fn)) end
end

function ctrl.events.MACRO_ACTION_BLOCKED(evt)
    local fn = evt[1]
    ctrl.events.alert('MACRO_ACTION_BLOCKED', 'consolewarning', c.r)
    ctrl.events:error('MACRO_ACTION_BLOCKED')
    if fn then ctrl.events:error(tostring(fn)) end
end

function ctrl.events.MACRO_ACTION_FORBIDDEN(evt)
    local fn = evt[1]
    ctrl.events.alert('MACRO_ACTION_FORBIDDEN', 'consolewarning', c.r)
    ctrl.events:error('MACRO_ACTION_FORBIDDEN')
    if fn then ctrl.events:error(tostring(fn)) end
end

function ctrl.events.SAVED_VARIABLES_TOO_LARGE(evt)
    local addon = evt[1] or ''
    ctrl.events.alert('SAVED_VARIABLES_TOO_LARGE: '..addon, 'consolewarning', c.o)
    ctrl.events:error('SAVED_VARIABLES_TOO_LARGE: '..addon)
end

function ctrl.events.CONSOLE_LOG(evt)
    local msg = evt[1] or ''
    ctrl.events:info('CONSOLE_LOG '..tostring(msg))
end

function ctrl.events.CONSOLE_MESSAGE(evt)
    local msg = evt[1] or ''
    ctrl.events:info('CONSOLE_MESSAGE '..tostring(msg))
end

function ctrl.events.PARTY_LEADER_CHANGED()
    ctrl.events.alert('PARTY_LEADER_CHANGED', nil, c.o)
end

function ctrl.events.ENTERED_DIFFERENT_INSTANCE_FROM_PARTY()
    ctrl.events.alert('ENTERED_DIFFERENT_INSTANCE_FROM_PARTY', 'wrong', c.o)
end

function ctrl.events.LUA_WARNING(evt)
    local msg = evt[1] or ''
    ctrl.events.alert('LUA_WARNING '..tostring(msg), 'wrong', c.o)
end

function ctrl.events.INITIAL_HOTFIXES_APPLIED()
    ctrl.events:info('INITIAL_HOTFIXES_APPLIED')
end

function ctrl.events.FRAME_MANAGER_UPDATE_ALL()
    ctrl.events:info('FRAME_MANAGER_UPDATE_ALL')
end

function ctrl.events.UPDATE_ALL_UI_WIDGETS()
    ctrl.events:info('UPDATE_ALL_UI_WIDGETS')
end

function ctrl.events.OBJECT_ENTERED_AOI(evt)
    local guid = evt[1] or ''
    ctrl.events.alert('OBJECT_ENTERED_AOI '..tostring(guid), nil, c.w)
end

function ctrl.events.OBJECT_LEFT_AOI(evt)
    local guid = evt[1] or ''
    ctrl.events.alert('OBJECT_LEFT_AOI '..tostring(guid), nil, c.w)
end

function ctrl.events.UNIT_FLAGS(evt)
    local unit = evt[1] or ''
    if UnitIsUnit(unit, 'player') then
        ctrl.events.alert('UNIT_FLAGS: player', nil, c.w)
    else
        ctrl.events:info('UNIT_FLAGS '..tostring(unit))
    end
end

function ctrl.events.GX_RESTARTED()
    ctrl.events.alert('GX_RESTARTED', 'pop', c.y)
end

ctrl.events:init()
