--[[ ctrl - secure/buttons.lua - t@wse.nyc - 4 August 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'secure',
    color = c.r,
    symbol = s.secure,
    options = {
        events = {
            'ZONE_CHANGED',
            'PLAYER_ENTERING_WORLD',
            'PLAYER_REGEN_ENABLED',
            'ACTIVE_PLAYER_SPECIALIZATION_CHANGED',
        },
    },
    instanceID = nil,
    isDirty = nil,
    btn = {},
}

ctrl.secure = ctrl.mod:new(mod)

function ctrl.secure.PLAYER_REGEN_ENABLED()
    if ctrl.secure.isDirty then
        ctrl.secure:getKickMobs()
    end
end

function ctrl.secure.PLAYER_ENTERING_WORLD()
    ctrl.secure:checkInstance()
end

function ctrl.secure.ZONE_CHANGED()
    ctrl.secure:checkInstance()
end





local script_kick = [=[
    local s = self:GetAttribute('s')
    local t = newtable(strsplit('|', s))
    local m = '/focus target\n/cleartarget\n'
    for i = 1, #t do
        m = m .. '/tar [nodead] ' .. t[i] .. '\n'
    end
    m = m .. '/cast Disrupt\n/target focus\n/clearfocus'
    self:SetAttribute('macrotext', m)
]=]

function ctrl.secure:getKickMobs()
    local t, str = {}, ''
    for _, entry in pairs(ctrl.db.npcId) do if entry.z and entry.z == self.instanceID then t[entry.n] = entry.kick end end
    for n, v in pairs(t) do str = str .. string.sub(n, 1, 8) .. '|' end
    str = str:sub(1, -2)
    if ctrl.secure.btn.kick then ctrl.secure.btn.kick:SetAttribute('s', str) end
    self.isDirty = nil
end

function ctrl.secure:checkInstance()
    if not IsInInstance() then self.instanceID = nil; return end
    local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    if instanceID and instanceID ~= self.instanceID then
        self.instanceID = instanceID
        if InCombatLockdown() then self.isDirty = true else ctrl.secure:getKickMobs() end
    end
end

function ctrl.secure:kickbtn(key)
    local name = 'ctrlsecurekick'
    local btn = ctrl.sec.btn({f=self.f.main, name=name, w=16, h=16})
    btn:SetAttribute('type', 'macro')
    SecureHandlerWrapScript(btn, 'OnClick', self.f.main, script_kick)
    if key then SetOverrideBindingClick(btn, true, key, name) end
    return btn
end

function ctrl.secure:setup()
    self.f.main = ctrl.sec.frame({name='ctrlsecuref', w=16, h=16, a='TOPLEFT', pa='TOPLEFT'})
    self.btn.kick = self:kickbtn('`')
end

ctrl.secure:init()

