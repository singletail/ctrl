--[[ ctrl - timer.lua - t@wse.nyc - 8/7/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local GetTime = GetTime
local GetTimePreciseSec = GetTimePreciseSec

local mod = {
    name = 'timer',
    color = c.g,
    symbol = s.timer,
    registry = {},
    index = 0,
    time = {
        start = 0,
        last = 0,
        throttle = 1 / 30,
        profile = 0,
    }
}

ctrl.timer = ctrl.mod:new(mod)

-- registry entry:
-- {interval, modulename, last, count}

local function findTimerIndex(moduleName, interval)
    for i = 1, ctrl.timer.index do
        if ctrl.timer.registry[i][2] == moduleName and ctrl.timer.registry[i][1] == interval then return i end
    end
end

function ctrl.timer.register(module, interval)
    local moduleName = module.name or module or 'nil'
    tinsert(ctrl.timer.registry, {interval, moduleName, 0, 0})
    ctrl.timer.index = ctrl.timer.index + 1
    ctrl.timer:debug('Registered ' .. moduleName .. ' for  timer, interval ' .. tostring(interval))
end

function ctrl.timer.unregister(module, interval)
    local moduleName = module.name or module or 'nil'
    local timerIndex = findTimerIndex(moduleName, interval)
    tremove(ctrl.timer.registry, timerIndex)
    ctrl.timer.index = ctrl.timer.index - 1
    ctrl.timer:debug('Unregistered ' .. moduleName .. ' for timer, interval' .. tostring(interval))
end

function ctrl.timer:tick()
    for i = 1, self.index do
        if GetTime() >= self.registry[i][1] + self.registry[i][3] then
            self.registry[i][3] = GetTime()
            self.registry[i][4] = self.registry[i][4] + 1
            ctrl[self.registry[i][2] ]:tick(self.registry[i][1], self.registry[i][4])
        end
    end
end

function ctrl.timer:onUpdate()
    if GetTime() >= self.time.last + self.time.throttle then
        self.time.last = GetTime()
        self:tick()
    end
end

local updateScript = function()
    ctrl.timer.onUpdate(ctrl.timer)
end

function ctrl.timer:start()
    self.time.start = GetTime()
    self.f:SetScript('OnUpdate', updateScript)
    self:debug('Timer Started')
end

function ctrl.timer:stop()
    self.f:SetScript('OnUpdate', nil)
    self:debug('Timer Stopped')
end

function ctrl.timer.profileStart()
    ctrl.timer.time.profile = GetTimePreciseSec()
end

function ctrl.timer.profileStop()
    local time_precise_end = GetTimePreciseSec()
    local elapsed = (time_precise_end - ctrl.timer.time.profile) / 1000
    return elapsed
end

function ctrl.timer:init()
    self.f = CreateFrame('Frame', nil, UIParent)
    self.f:SetFrameStrata('BACKGROUND')
    self.f:SetSize(1, 1)
    self.f:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 1, 0)
    self:start()
end

ctrl.timer:init()
