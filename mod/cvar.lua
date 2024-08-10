--[[ ctrl - cvar.lua - t@wse.nyc - 8/6/24 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'cvar',
    color = c.v,
    symbol = s.cvar,
    options = {
        events = { 'CVAR_UPDATE' },
    },
}

ctrl.cvar = ctrl.mod:new(mod)

local default = {
    ['taintLog'] = 2,
    --['AutoPushSpellToActionBar'] = 0,
    ['autoStand'] = 0,
    ['ConsoleKey'] = '`',
    ['disableServerNagle'] = 1,
    ['dynamicLod'] = 0,
    ['doodadLodScale'] = 0,
    ['DynamicRenderScale'] = 0,
    ['chatBubbles'] = 1,
    ['chatBubblesParty'] = 1,
    ['colorChatNamesByClass'] = 1,
    ['SpellQueueWindow'] = 100,
    ['cameraDistanceMaxZoomFactor'] = 2.6,
    ['autoLootDefault'] = 1,
    ['autoLootRate'] = 6,
    ['advancedCombatLogging'] = 1,
    ['disableAELooting'] = 0,
    ['enableSourceLocationLookup'] = 1,
}

local cvarTab = ctrl.newTable('')
cvarTab[1] = c.b
cvarTab[2] = s.cvar_alert
cvarTab[3] = ' CVAR_UPDATE '
cvarTab[3] = c.o
cvarTab[4] = 'cvar'
cvarTab[5] = ' '
cvarTab[6] = c.g
cvarTab[7] = 'value'
cvarTab[8] = c.d

local function getBuffer(t)
    return table.concat(t, '')
end

local function mismatch(cvarName, cvarValue, oldValue)
    local alertStr = c.r .. 'Type mismatch for CVar ' ..
        tostring(cvarName) ..
        '. Old value: ' ..
        tostring(oldValue) ..
        ' (' ..
        tostring(type(oldValue)) ..
        ') new value: ' .. tostring(cvarValue) .. ' (' .. tostring(type(cvarValue)) .. '). Not changed.'
    ctrl.cvar.warn(ctrl.cvar, alertStr)
    ctrl.alert.add(ctrl.cvar, alertStr)
end

local function set(cvarName, cvarValue)
    local oldValue = C_CVar.GetCVar(cvarName)
    if tostring(oldValue) ~= tostring(cvarValue) then
        local ok = C_CVar.SetCVar(cvarName, cvarValue)
        local msg = 'CVar ' .. tostring(cvarName) .. ' set to ' .. cvarValue
        if not ok then
            msg = c.r .. 'Error: CVar ' .. tostring(cvarName) .. ' NOT set to ' .. cvarValue
        end
        ctrl.cvar.notice(ctrl.cvar, msg)
        ctrl.alert.add(ctrl.cvar, msg)
    end
end

function ctrl.cvar.CVAR_UPDATE(et)
    local cvarName = et[1] or 'unknown'
    local cvarValue = et[2] or 'unknown'
    local msg = "CVAR_UPDATE('" .. tostring(cvarName) .. "', " .. tostring(cvarValue) .. ")"
    --ctrl.alert.add(ctrl.cvar, msg)
    --ctrl.cvar.info(ctrl.cvar, msg)
end

local function setAll()
    for k, v in pairs(default) do
        set(k, v)
    end
end

function ctrl.cvar.setup()
    setAll()
end

ctrl.cvar:init()
