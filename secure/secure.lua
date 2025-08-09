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



-- Kick Macro

local script_kick = [=[
    local k = self:GetAttribute('k')
    local s = self:GetAttribute('s')
    local t = newtable(strsplit('|', s))
    local m = '/focus target\n/cleartarget\n'
    for i = 1, #t do
        m = m .. '/tar ' .. t[i] .. '\n'
    end
    m = m .. '/cast '..k..'\n/target focus\n/clearfocus'
    self:SetAttribute('macrotext', m)
    print(m)
]=]


-- using this version for now - hard target and direct cast at target
local script_kick_2 = [=[
    local k = self:GetAttribute('k')
    local s = self:GetAttribute('s')
    local t = newtable(strsplit('|', s))
    local m = ''
    for i = 1, #t do
        m = m .. '/tar ' .. t[i] .. '\n'
    end
    m = m .. '/cast [@target,exists,nodead]'..k
    self:SetAttribute('macrotext', m)
    print(m)
]=]

function ctrl.secure:getKickMobs()
    local t, str = {}, ''
    for _, entry in pairs(ctrl.db.npcId) do
        if entry.z and entry.z == self.instanceID and entry.kick then
            t[entry.n] = entry.kick -- using table key to remove duplicates
        end
    end
    for n, v in pairs(t) do str = str .. n .. '|' end
    --for n, v in pairs(t) do str = str .. string.sub(n, 1, 8) .. '|' end -- alt version to truncate names
    str = str:sub(1, -2)
    if ctrl.secure.btn.kick then ctrl.secure.btn.kick:SetAttribute('s', str) end
    self.isDirty = nil
end

function ctrl.secure:checkInstance()
    if not IsInInstance() then self.instanceID = nil; return end
    local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    if instanceID and instanceID ~= self.instanceID then
        self.instanceID = instanceID
        self:info('instanceID', instanceID)
        if InCombatLockdown() then self.isDirty = true else ctrl.secure:getKickMobs() end
    end
end

function ctrl.secure:kickbtn(key)
    ctrl.secure.kickSpell = self:findKickSpell()
    self:info('kickSpell', tostring(ctrl.secure.kickSpell))
    if not ctrl.secure.kickSpell then return end

    local name = 'ctrlsecurekick'
    local btn = ctrl.sec.btn({f=self.f.main, name=name, w=16, h=16})
    btn:SetAttribute('type', 'macro')
    btn:SetAttribute('k', ctrl.secure.kickSpell)
    SecureHandlerWrapScript(btn, 'OnClick', self.f.main, script_kick_2)
    if key then SetOverrideBindingClick(btn, true, key, name) end
    return btn
end

function ctrl.secure:findKickSpell()
    local kickSpells = {'Pummel','Mind Freeze', 'Strangulate', 'Skull Bash', 'Quell', 'Counter Shot', 'Counterspell', 'Spear Hand Strike', 'Rebuke', 'Silence', 'Kick', 'Wind Shear','Disrupt'}
    for _,v in ipairs(kickSpells) do
        local spellID = C_Spell.GetSpellIDForSpellIdentifier(v)
        if spellID then
            local isKnown = IsPlayerSpell(spellID) --C_SpellBook.IsSpellKnown(spellID)
            if isKnown then
                return v
            end
        end
    end
end

--


function ctrl.secure:setup()

    self.f.main = ctrl.sec.frame({name='ctrlsecuref', w=16, h=16, a='TOPLEFT', pa='TOPLEFT'})
    self.btn.kick = self:kickbtn('`')
--[[
    self.f.charm = ctrl.sec.frame({name='ctrlseccharms', w=64, h=32, a='CENTER', pa='CENTER'})
    self.f.charm.tx = ctrl.sec.tx({f=self.f.charm, t='metal_half_h'})
    self.btn.skull = self:charmbtn(8)
    self.btn.skull.tx = ctrl.sec.tx({f=self.btn.skull})
    self.f.charm:Hide()
]]
end

ctrl.secure:init()

