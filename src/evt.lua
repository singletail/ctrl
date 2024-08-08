--[[ ctrl - evt.lua - t@wse.nyc - 7/24/24 ]] --

local aname, ctrl = ...

local mod = {
    name = 'evt',
    color = ctrl.c.y,
    symbol = ctrl.s.evt,
    reg = {},
    n = {},
}

ctrl.evt = ctrl.mod:new(mod)

local f = CreateFrame('Frame', nil, UIParent)
f:SetFrameStrata('BACKGROUND')
f:SetSize(1, 1)
f:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 0, 0)
ctrl.evt.f = f

local function process(self, e, ...)
    local et = ctrl.pack(...)
    for i = 1, ctrl.evt.n[e] do
        ctrl[ctrl.evt.reg[e][i]].evt(e, et)
    end
end

--[[
local function delegate(e, et)
    for i = 1, ctrl.evt.n[e] do
        local modname = ctrl.evt.reg[e][i]
        if ctrl[modname][e] then
            ctrl[modname][e](et)
        elseif ctrl[modname].evt then
            ctrl[modname].evt(e, et)
        else
            ctrl.evt.warn(ctrl.evt, 'No event handler for ' .. e .. ' in ' .. modname)
        end
    end
end

local function process(self, e, ...)
    local et = ctrl.pack(...)
    delegate(e, et)
end
]]

local function start()
    f:SetScript("OnEvent", process)
end

local function stop()
    f:SetScript('OnEvent', nil)
end

function ctrl.evt.register(module, e)
    if not ctrl.evt.reg[e] then
        ctrl.evt.reg[e] = {}
        ctrl.evt.n[e] = 0
    end
    tinsert(ctrl.evt.reg[e], module.name)
    ctrl.evt.n[e] = ctrl.evt.n[e] + 1
    if not ctrl.evt.f:IsEventRegistered(e) then ctrl.evt.f:RegisterEvent(e) end
end

function ctrl.evt.unregister(module, e)
    if not ctrl.evt.reg[e] then return end
    for i = 1, #ctrl.evt.n[e] do
        if ctrl.evt.reg[e][i] == module.name then
            tremove(ctrl.evt.reg[e], i)
            ctrl.evt.n[e] = ctrl.evt.n[e] - 1
            if ctrl.evt.n[e] == 0 then ctrl.evt.f:UnregisterEvent(e) end
            break
        end
    end
end

function ctrl.evt:init()
    self:register('ADDON_LOADED')
    start()
end

function ctrl.evt.ADDON_LOADED(et)
    if not et then return end
    local addon_name = et[1] or 'nil'
    local isReload = et[2] or false
    if aname == addon_name then ctrl.master.load() end
end

ctrl.evt:init()

--[[
local allevt = {
  'ADDON_LOADED',
  'VARIABLES_LOADED',
  'PLAYER_ENTERING_WORLD',
  'CVAR_UPDATE',
  'ADDON_ACTION_BLOCKED',
  'ADDON_ACTION_FORBIDDEN',
  'GENERIC_ERROR',
  'UI_ERROR_MESSAGE',
  'UI_ERROR_POPUP',
  'UI_INFO_MESSAGE',
  'UI_SCALE_CHANGED',
  'SYSMSG',
  'CONSOLE_MESSAGE',
  'CONSOLE_LOG',

  -- misc
  'CHAT_MSG_LOOT', -- see below
  'PLAYER_TARGET_CHANGED',
  'UNIT_THREAT_LIST_UPDATE', --maybe?
  'UNIT_THREAT_SITUATION_UPDATE',
  'UNIT_FLAGS',
  'UNIT_NAME_UPDATE',
  'UNIT_CONNECTION', -- unitTarget, isConnected
  'ENTERED_DIFFERENT_INSTANCE_FROM_PARTY',
  'PLAYER_CONTROL_LOST',
  'PLAYER_CONTROL_GAINED',

  --nameplates (for passive scanning)
  'FORBIDDEN_NAME_PLATE_CREATED', -- namePlateFrame
  'FORBIDDEN_NAME_PLATE_UNIT_ADDED', -- unitToken
  'FORBIDDEN_NAME_PLATE_UNIT_REMOVED', -- unitToken
  'NAME_PLATE_CREATED', -- namePlateFrame
  'NAME_PLATE_UNIT_ADDED', -- unitToken
  'NAME_PLATE_UNIT_REMOVED', -- unitToken

  -- group
  'GROUP_FORMED', -- category, partyGUID
  'GROUP_JOINED', --category, partyGUID
  'GROUP_LEFT', -- category, partyGUID
  'GROUP_ROSTER_UPDATE',
  'PARTY_LEADER_CHANGED',
  'READY_CHECK', -- initiatorName, readyCheckTimeLeft
  'READY_CHECK_FINISHED', --preempted (bool)
  'ROLE_CHANGED_INFORM', --changedName, fromName, oldRole, newRole'
  'RAID_TARGET_UPDATE',

  -- combat
  'ENCOUNTER_START',
  'ENCOUNTER_END',
  'PLAYER_REGEN_DISABLED',
  'PLAYER_REGEN_ENABLED',
  'UNIT_TARGET',
  'UNIT_SPELLCAST_START',
  'UNIT_SPELLCAST_INTERRUPTIBLE',
  'UNIT_SPELLCAST_INTERRUPTED',
  --'SPELL_UPDATE_COOLDOWN', --(player's)
  --'SPELL_UPDATE_CHARGES', --(player's)


  -- M+
  'CHALLENGE_MODE_COMPLETED',
  'CHALLENGE_MODE_DEATH_COUNT_UPDATED',
  'CHALLENGE_MODE_MAPS_UPDATE',
  'CHALLENGE_MODE_MEMBER_INFO_UPDATED',
  'CHALLENGE_MODE_RESET', --mapID
  'CHALLENGE_MODE_START', --mapID
}
]]
