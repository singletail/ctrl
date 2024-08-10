--[[ ctrl - evt.lua - t@wse.nyc - 7/24/24 ]] --

---@class ctrl
local addon, ctrl = ...

local mod = {
    name = 'evt',
    color = ctrl.c.y,
    symbol = ctrl.s.evt,
    registry = {},
    index = {},
}

ctrl.evt = ctrl.mod:new(mod)

local function addEventToRegistry(e)
    if ctrl.evt.registry[e] then return end
    ctrl.evt.registry[e] = {}
    ctrl.evt.index[e] = 0
end

local function registerFrame(e)
    if ctrl.evt.f:IsEventRegistered(e) then return end
    ctrl.evt.f:RegisterEvent(e)
    ctrl.evt:debug('Registered event frame for ' .. e)
end

local function unregisterFrame(e)
    if not ctrl.evt.f:IsEventRegistered(e) then return end
    ctrl.evt.f:UnregisterEvent(e)
    ctrl.evt.registry[e] = nil
    ctrl.evt.index[e] = nil
    ctrl.evt:debug('Unegistered event frame for ' .. e)
end

local function findModuleIndex(moduleName, event)
    for i = 1, ctrl.evt.index[event] do
        if ctrl.evt.registry[event][i] == moduleName then return i end
    end
end

function ctrl.evt.eventHandler(self, e, et) -- to catch events for ctrl.evt only
    if self[e] then
        self[e](et)
    else
        self:warn(string.format('%sUncaught event: %s%s%s. Add evt() to module %s%s%s.%s', ctrl.c.r, ctrl.c.o, tostring(e), ctrl.c.r, ctrl.c.y, self.name, ctrl.c.r, ctrl.c.d))
    end
end

function ctrl.evt:event(e, ...) -- to catch events going to other modules
    local et = ctrl.pack(...)
    for i = 1, ctrl.evt.index[e] do
        ctrl[ctrl.evt.registry[e][i]]:eventHandler(e, et)
    end
end

function ctrl.evt:start()
    self.f:SetScript("OnEvent", ctrl.evt.event)
end

function ctrl.evt:stop()
    self.f:SetScript("OnEvent", nil)
end

function ctrl.evt.register(module, event)
    local moduleName = module.name or module or 'nil'
    addEventToRegistry(event)
    tinsert(ctrl.evt.registry[event], moduleName)
    ctrl.evt.index[event] = ctrl.evt.index[event] + 1
    registerFrame(event)
    print('Registered ' .. moduleName .. ' for ' .. event)
    ctrl.evt:debug('Registered ' .. moduleName .. ' for ' .. event)
end

function ctrl.evt.unregister(module, event)
    local moduleName = module.name or module or 'nil'
    local eventIndex = findModuleIndex(moduleName, event)
    tremove(ctrl.evt.registry[event], eventIndex)
    ctrl.evt.index[event] = ctrl.evt.index[event] - 1
    ctrl.evt:debug('Unegistered ' .. moduleName .. ' for ' .. event)
    if ctrl.evt.index[event] == 0 then unregisterFrame(event) end
end

function ctrl.evt.ADDON_LOADED(et)
    if et and et[1] == addon and not et[2] then ctrl.master.load() end
end

function ctrl.evt:init() --overwriting module default, to run on load
    self.f = CreateFrame('Frame', nil, UIParent)
    self.f:SetFrameStrata('BACKGROUND')
    self.f:SetSize(1, 1)
    self.f:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 0, 0)
    self:register('ADDON_LOADED')
    self:start()
end

ctrl.evt:init()
