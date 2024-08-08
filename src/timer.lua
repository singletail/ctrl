--[[ ctrl - timer.lua - t@wse.nyc - 8/7/24 ]] --

local _, ctrl = ...
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local GetTime = GetTime
local GetTimePreciseSec = GetTimePreciseSec

local mod = {
    name = 'timer',
    color = c.g,
    symbol = s.timer,
    time = {
        start = 0,
        last = 0,
        throttle = 1 / 30,
    }
}

local registry = {}

ctrl.timer = ctrl.mod:new(mod)

ctrl.timer.frame = CreateFrame('Frame', nil, UIParent)
ctrl.timer.frame:SetFrameStrata('BACKGROUND')
ctrl.timer.frame:SetSize(1, 1)
ctrl.timer.frame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 1, 0)

-- registry entry:
-- {interval, last, modulename}

function ctrl.timer:tick()
    if GetTime() >= self.time.last + self.time.throttle then
        self.time.last = GetTime()
        self:tock()
    end
end

function ctrl.timer:tock()
    for i = 1, #registry do
        if GetTime() >= registry[i][1] + registry[i][2] then
            registry[i][2] = GetTime()
            ctrl[registry[i][3]]:tick()
        end
    end
end

local updateScript = function()
    ctrl.timer.tick(ctrl.timer)
end

function ctrl.timer:start()
    self.time.start = GetTime()
    self.frame:SetScript('OnUpdate', updateScript)
    self:debug('Timer Started')
end

function ctrl.timer:stop()
    self.frame:SetScript('OnUpdate', nil)
    self:debug('Timer Stopped')
end

local function precise()
    ctrl.timer.time.precise = GetTimePreciseSec()
end

local function done()
    local time_precise_end = GetTimePreciseSec()
    local elapsed = (time_precise_end - ctrl.timer.time.precise) / 1000
    return elapsed
end

function ctrl.timer.register(modulename, interval)
    local entry = { interval, 0, modulename }
    tinsert(registry, entry)
    ctrl.timer:debug(modulename .. ' registered timer, interval: ' .. tostring(interval))
end

function ctrl.timer:unregister(modulename, interval)
    local found = 0
    for i, v in ipairs(registry) do
        if v[3] == modulename and v[1] == interval then
            found = i
        end
        if found > 0 then
            tremove(registry, found)
            break
        end
    end
end

ctrl.timer.start(ctrl.timer)
