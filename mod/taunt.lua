--[[ ctrl - taunt.lua - t@wse.nyc - 8/5/24 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'taunt',
    color = c.o,
    symbol = s.taunt,
    options = {
        cleu = {
            'SPELL_CAST_SUCCESS'
        }
    }
}

ctrl.taunt = ctrl.mod:new(mod)

local taunts = {
    [115546] = 'Provoke',
    [56222] = 'Dark Command',
    [51399] = 'Death Grip',
    [355] = 'Taunt',
    [185245] = 'Torment',
    [6795] = 'Growl',
    [62124] = 'Hand of Reckoning',
}

--[[
local aoe = {
    [116189] = 'Provoke',
    [205644] = 'Force of Nature',
    [2649] = 'Growl',
    [134477] = 'Threatening Presence',
    [17735] = 'Suffering',
    [171014] = 'Seethe',
    [36213] = 'Angered Earth',
    [204079] = 'Final Stand',
    [61146] = 'Provoke',
}
]]

ctrl.taunt.msgTab = ctrl.newTable('')
ctrl.taunt.msgTab[1] = c.y
ctrl.taunt.msgTab[2] = ' '
ctrl.taunt.msgTab[3] = c.b
ctrl.taunt.msgTab[4] = ' cast '
ctrl.taunt.msgTab[5] = c.o
ctrl.taunt.msgTab[6] = ' '
ctrl.taunt.msgTab[7] = c.b
ctrl.taunt.msgTab[8] = ' on '
ctrl.taunt.msgTab[9] = c.r
ctrl.taunt.msgTab[10] = ' '
ctrl.taunt.msgTab[11] = c.d

local function getBuffer(t)
    return table.concat(t, c.d)
end

function ctrl.taunt:taunted(evt)
    self:debug('taunted', tostring(evt[5]))
    ctrl.taunt.msgTab[2] = tostring(evt[5])
    ctrl.taunt.msgTab[6] = tostring(evt[13])
    ctrl.taunt.msgTab[10] = tostring(evt[9])
    local msg = getBuffer(ctrl.taunt.msgTab)
    self:debug('taunt message', msg)
    ctrl.alert:add(msg)
    ctrl.sfx.play(ctrl.taunt, 'TAUNT', "Master")
end

function ctrl.taunt.SPELL_CAST_SUCCESS(evt)
    if not taunts[evt[12]] then return end
    ctrl.taunt:taunted(evt)
end

ctrl.taunt:init()
