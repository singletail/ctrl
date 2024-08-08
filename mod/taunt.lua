--[[ ctrl - taunt.lua - t@wse.nyc - 8/5/24 ]]
--

local _, ctrl = ...
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

local msgTab = ctrl.newTable('')
msgTab[1] = c.y
msgTab[2] = ' '
msgTab[3] = ' cast '
msgTab[4] = c.o
msgTab[5] = ' '
msgTab[6] = ' on '
msgTab[7] = c.r
msgTab[8] = ' '

local function getBuffer(t)
    return table.concat(t, c.d)
end

local function taunted(evt)
    msgTab[2] = tostring(evt[5])
    msgTab[5] = tostring(evt[13])
    msgTab[8] = tostring(evt[9])
    ctrl.alert.add(ctrl.taunt, getBuffer(msgTab))
    ctrl.sfx.play(ctrl.taunt, 'TAUNT', "Master")
end

function ctrl.taunt.SPELL_CAST_SUCCESS(evt)
    if taunts[evt[12]] then
        taunted(evt)
    end
end

ctrl.taunt:init()
