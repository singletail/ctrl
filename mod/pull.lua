--[[ ctrl - pull.lua - t@wse.nyc - 26 July 2025 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'pull',
    color = c.o,
    symbol = s.bow,
    options = {
        events = {
            'UNIT_FLAGS', --unitToken
            'GROUP_ROSTER_UPDATE',
            'PLAYER_ENTERING_WORLD',
            'RAID_INSTANCE_WELCOME', --mapname, timeLeft, locked, extended
            'PLAYER_REGEN_DISABLED',
            'PLAYER_REGEN_ENABLED',
        }
    },
    active = 1,
}

ctrl.pull = ctrl.mod:new(mod)

function ctrl.pull:alert(unit)
    if not self.active then return end
    local unitName = UnitName(unit) or 'Unknown'
    local msg = string.format('%s%s ctrl.pull: %s %s%s', c.y, self.symbol, unitName, c.a, unit)
    ctrl.alert:add(msg)
    ctrl.sfx.play(ctrl.pull, 'airhorn')
    self:info(msg)
    self:disable()
end

function ctrl.pull:disable()
    self.active = nil
    --ctrl.evt.unregister(ctrl.pull, 'UNIT_FLAGS')
end

function ctrl.pull:enable()
    if InCombatLockdown() then return end
    if not IsInInstance() then return end
    if not IsInRaid() then return end
    self.active = 1
end

function ctrl.pull.UNIT_FLAGS(evt)
    local unit = evt[1] or ''
    ctrl.pull:alert(unit)
end

function ctrl.pull.PLAYER_REGEN_DISABLED()
    ctrl.pull:disable()
end

function ctrl.pull.PLAYER_REGEN_ENABLED()
    ctrl.pull:enable()
end

function ctrl.pull.GROUP_ROSTER_UPDATE()
    ctrl.pull:enable()
end

function ctrl.pull.RAID_INSTANCE_WELCOME()
    ctrl.pull:enable()
end

function ctrl.pull.PLAYER_ENTERING_WORLD()
    ctrl.pull:enable()
end

ctrl.pull:init()
