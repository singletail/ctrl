--[[ ctrl - alert.lua - t@wse.nyc - 8/5/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'alert',
    color = c.r,
    symbol = s.notice,
    id = 0,
    buffer = {},
    isTimerOn = nil,
    options = {
        fontFile = 'Prompt-Bold.ttf',
        fontSize = 24,
        maxLines = 5,
        ttl = 5,
        fade = 4,
        debug = nil,
        throttle = 1/30,
        frame = {
            w = 1024,
            h = 256,
            x = 0,
            y = 200,
            a = 'CENTER',
            pa = 'CENTER',
            isMovable = nil,
            isResizable = nil,
        }
    }
}

ctrl.alert = ctrl.mod:new(mod)

function ctrl.alert:add(msg)
    if not msg then msg = self end
    if not ctrl.alert.isTimerOn then ctrl.alert:startTimer() end
    tinsert(ctrl.alert.buffer, 1, { ts = GetTime(), msg = tostring(msg), alpha = 1 })
    ctrl.alert:drawBuffer()
    ctrl.alert:debug(msg)
end

function ctrl.alert:resize(f, w, h)
--
end

function ctrl.alert:createFontStrings()
    for i = 1, self.options.maxLines do
        local set = {
            target = self.f.main,
            fontFile = self.options.fontFile,
            fontSize = self.options.fontSize,
            w=1024,
            h=30,
            x = 24,
            y = -((i-1) * 30),
            jH = 'CENTER',
            jV = 'MIDDLE',
            n = 'fs' .. i
        }
        self.fs[i] = ctrl.fs:new(set)
        self.fs[i]:SetText('fs ' .. i)
    end
end

function ctrl.alert:startTimer()
    ctrl.timer.register(ctrl.alert, ctrl.alert.options.throttle)
    ctrl.alert.isTimerOn = 1
end

function ctrl.alert:stopTimer()
    ctrl.timer.unregister(ctrl.alert, ctrl.alert.options.throttle)
    ctrl.alert.isTimerOn = nil
end

function ctrl.alert:checkBuffer()
    local bufferSize = 0
    for i, v in ipairs(ctrl.alert.buffer) do
        bufferSize = bufferSize + 1
        local now = GetTime()
        local age = now - v.ts
        if age > ctrl.alert.options.ttl then tremove(ctrl.alert.buffer, i) end
        if age > ctrl.alert.options.fade then
            local pastFade = age - ctrl.alert.options.fade
            local fadeDuration = ctrl.alert.options.ttl - ctrl.alert.options.fade
            local alpha = 1.0 - (pastFade / fadeDuration)
            if alpha < 0 then alpha = 0 end
            v.alpha = alpha
        end
    end
    if bufferSize < 1 then
        self:debug('buffer empty, stopping timer')
        self:stopTimer()
        return
    end
end

function ctrl.alert:drawBuffer()
    for i = 1, self.options.maxLines do
     if not ctrl.alert.fs[i] then return end
        if not ctrl.alert.buffer[i] then
            ctrl.alert.fs[i]:SetText('')
            ctrl.alert.fs[i]:SetAlpha(0)
        else
            local alpha = ctrl.alert.buffer[i].alpha or 1
            local msg = tostring(ctrl.alert.buffer[i].msg) or ''
            ctrl.alert.fs[i]:SetText(msg)
            ctrl.alert.fs[i]:SetAlpha(alpha)
        end
    end
end

function ctrl.alert:tick()
    ctrl.alert:checkBuffer()
    ctrl.alert:drawBuffer()
end

function ctrl.alert.setup(self)
    self.f.main = ctrl.frame:new(self.options.frame)
    self:createFontStrings()

    ctrl.alert:add(c.r..'ctrl' .. c.o..':' .. c.y .. 'alert' .. c.g.. ' initialized')
    ctrl.alert:add(c.r..'ctrl' .. c.o..':' .. c.y .. 'alert' .. c.g.. ' 2')
    ctrl.alert:add(c.r..'ctrl' .. c.o..':' .. c.y .. 'alert' .. c.g.. ' 3')
    ctrl.alert:add(c.r..'ctrl' .. c.o..':' .. c.y .. 'alert' .. c.g.. ' 4')
    ctrl.alert:add(c.r..'ctrl' .. c.o..':' .. c.y .. 'alert' .. c.g.. ' 5')
    if ctrl.alert.options.debug then self:add(c.y .. s.warn .. ' Debug mode enabled.') end
end

ctrl.alert:init()
