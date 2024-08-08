--[[ ctrl - cleu.lua - t@wse.nyc - 8/5/24 ]] --

local aname, ctrl = ...

local mod = {
    name = 'cleu',
    color = ctrl.c.o,
    symbol = ctrl.s.cleu,
    reg = {},
    n = {},
    options = {
        debug = nil,
    }
}

ctrl.cleu = ctrl.mod:new(mod)

local f = CreateFrame('Frame', nil, UIParent)
f:SetFrameStrata('BACKGROUND')
f:SetSize(1, 1)
f:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 0, 0)
ctrl.cleu.f = f

local function delegate(et)
    for i = 1, ctrl.cleu.n[et[2]] do
        local modname = ctrl.cleu.reg[et[2]][i]
        if ctrl[modname][et[2]] then
            ctrl[modname][et[2]](et)
            if ctrl.cleu.options.debug then ctrl.log(ctrl.cleu, 8, 'ctrl:' .. modname .. '.' .. et[2] .. '()') end
        elseif ctrl[modname].cleu_event(et) then
            ctrl[modname].cleu_event(et)
            if ctrl.cleu.options.debug then ctrl.log(ctrl.cleu, 8, 'ctrl:' .. modname .. '.cleu' .. '(' .. et[2] .. ')') end
        end
    end
end

local function process()
    local et = ctrl.pack(CombatLogGetCurrentEventInfo())
    if not ctrl.cleu.reg[et[2]] then return end
    delegate(et)
end

local function start()
    f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
    f:SetScript("OnEvent", process)
    if ctrl.cleu.options.debug then ctrl.log(ctrl.cleu, 8, 'Started.') end
end

local function stop()
    f:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
    f:SetScript('OnEvent', nil)
    if ctrl.cleu.options.debug then ctrl.log(ctrl.cleu, 8, 'Stopped.') end
end

function ctrl.cleu.register(module, e)
    local modname = module.name
    if not ctrl.cleu.reg[e] then
        ctrl.cleu.reg[e] = {}
        ctrl.cleu.n[e] = 0
    end
    tinsert(ctrl.cleu.reg[e], module.name)
    ctrl.cleu.n[e] = ctrl.cleu.n[e] + 1
    if ctrl.cleu.options.debug then ctrl.log(ctrl.cleu, 8, module.name .. 'registered CLEU event ' .. e) end
end

function ctrl.cleu.unregister(self, module, e)
    if not ctrl.cleu.reg[e] then return end
    for i = 1, #ctrl.cleu.n[e] do
        if ctrl.cleu.reg[e][i] == module.name then
            tremove(ctrl.cleu.reg[e], i)
            ctrl.cleu.n[e] = ctrl.cleu.n[e] - 1
            break
        end
    end
    if ctrl.cleu.options.debug then ctrl.log(ctrl.cleu, 8, module.name .. 'unregistered CLEU event ' .. e) end
end

function ctrl.cleu:init()
    start()
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
