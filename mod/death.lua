--[[ ctrl - death.lua - t@wse.nyc - 8/5/24 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'death',
    color = c.o,
    symbol = s.dead,
    options = {
        cleu = {
            'UNIT_DIED'
        }
    }
}

ctrl.death = ctrl.mod:new(mod)

ctrl.death.msgTab = ctrl.newTable('')
ctrl.death.msgTab[1] = c.r
ctrl.death.msgTab[2] = ' ' --name
ctrl.death.msgTab[3] = ' died.' .. c.d .. ' ('
ctrl.death.msgTab[4] = '' --role
ctrl.death.msgTab[5] = ') ' .. c.b
ctrl.death.msgTab[6] = ' ' -- unit
ctrl.death.msgTab[7] = ' ' .. c.d .. c.v
ctrl.death.msgTab[8] = ' ' -- guid
ctrl.death.msgTab[9] = c.d

local function getBuffer(t)
    return table.concat(t, c.d)
end

function ctrl.death:died(evt)
    self:debug('UNIT_DIED', evt[1], evt[2], evt[3], evt[4], evt[5], evt[6], evt[7], evt[8], evt[9], evt[10], evt[11])
    
    local guid = evt[8]
    if not guid then return end
    if string.sub(guid, 1, 5) ~= 'Player' then return end

    local name = evt[9]
    self:debug('UNIT_DIED', guid, name)

    if not ctrl.group.guid[guid] then return end -- I don't know her
    local unit = ctrl.group.guid[guid].unit
    if not unit or unit.guid ~= guid then return end -- Outdated entry
    local localname = ctrl.group.unit[unit].name or 'Unknown'
    local role = ctrl.group.unit[unit].role or 'DAMAGER'

    ctrl.death.msgTab[2] = tostring(localname)
    ctrl.death.msgTab[4] = '(' .. tostring(role) .. ')'
    ctrl.death.msgTab[6] = tostring(unit)
    ctrl.death.msgTab[8] = tostring(guid)
    local msg = getBuffer(ctrl.death.msgTab)
    self:debug('death message', msg)
    ctrl.alert:add(msg)

    ctrl.sfx.play(ctrl.death, role, "Master")
end

function ctrl.death.UNIT_DIED(evt)
    ctrl.death:died(evt)
end

ctrl.death:init()

--[[
9/10/2024 20:00:02.644-4  
UNIT_DIED
0000000000000000
nil
0x80000000
0x80000000
Player-162-0A64C9CD
"Ôrphanmaker-EmeraldDream-US"
0x514
0x0
0

]]

-- 1 timestamp
-- 2 subevent
-- 3 hideCaster
-- 4 sourceGUID
-- 5 sourceName
-- 6 sourceFlags
-- 7 sourceRaidFlags
-- 8 destGUID
-- 9 destName
--10 destFlags
--11 destRaidFlags
