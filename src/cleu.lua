--[[ ctrl - cleu.lua - t@wse.nyc - 8/5/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local mod = {
    name = 'cleu',
    color = ctrl.c.o,
    symbol = ctrl.s.cleu,
    registry = {},
    index = {},
}

ctrl.cleu = ctrl.mod:new(mod)

local function addCleuEventToRegistry(e)
    if ctrl.cleu.registry[e] then return end
    ctrl.cleu.registry[e] = {}
    ctrl.cleu.index[e] = 0
end

local function findCleuModuleIndex(moduleName, cleuevent)
    for i = 1, ctrl.cleu.index[cleuevent] do
        if ctrl.cleu.registry[cleuevent][i] == moduleName then return i end
    end
end

function ctrl.cleu:cleuEvent()
    local cleut = ctrl.pack(CombatLogGetCurrentEventInfo())
    if not cleut and not cleut[2] then return end
    if not ctrl.cleu.index[cleut[2]] then return end
    for i = 1, ctrl.cleu.index[cleut[2]] do
        if not ctrl[ctrl.cleu.registry[cleut[2]][i]] then return end
        ctrl[ctrl.cleu.registry[cleut[2]][i]]:cleuEventHandler(cleut)
    end
end

function ctrl.cleu:start()
    self.f:SetScript("OnEvent", self.cleuEvent)
end

function ctrl.cleu:stop()
    self.f:SetScript("OnEvent", nil)
end

function ctrl.cleu.register(module, cleuEvent)
    local moduleName = module.name or module or 'nil'
    addCleuEventToRegistry(cleuEvent)
    tinsert(ctrl.cleu.registry[cleuEvent], moduleName)
    ctrl.cleu.index[cleuEvent] = ctrl.cleu.index[cleuEvent] + 1
    ctrl.cleu:debug('Registered ' .. moduleName .. ' for ' .. cleuEvent)
end

function ctrl.cleu.unregister(module, cleuEvent)
    local moduleName = module.name or module or 'nil'
    local eventIndex = findCleuModuleIndex(moduleName, cleuEvent)
    tremove(ctrl.cleu.registry[cleuEvent], eventIndex)
    ctrl.cleu.index[cleuEvent] = ctrl.cleu.index[cleuEvent] - 1
    ctrl.cleu:debug('Unegistered ' .. moduleName .. ' for ' .. cleuEvent)
end

function ctrl.cleu:init() --overwriting module default, to run on load
    self.f = self.f or CreateFrame('Frame', nil, UIParent)
    if not self.f then self:error('Frame not created.'); return end
    self.f:SetFrameStrata('BACKGROUND')
    self.f:SetSize(1, 1)
    self.f:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 0, 0)
    --self:register('COMBAT_LOG_EVENT_UNFILTERED')
    self.f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
    self:start()
end

ctrl.cleu:init()

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
