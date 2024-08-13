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
        ttl = 10,
        fade = 5,
        debug = nil,
        throttle = 1/30,
        frame = {
            w = 1024,
            h = 256,
            x = 0,
            y = 200,
            a = 'CENTER',
            pa = 'CENTER',
            isMovable = 0,
            isResizable = 0,
        }
    }
}

ctrl.alert = ctrl.mod:new(mod)

local subframes = {
    ['bk'] = { anchors = { { a = a.tl, pa = a.tl, x = 12, y = -12 }, { a = a.br, pa = a.br, x = -12, y = 12 } } },
    --['sf'] = { subclass = 'ScrollingMessageFrame', target = 'bk', anchors = { { a = a.tl, pa = a.tl, x = 20, y = -20 }, { a = a.br, pa = a.br, x = -16, y = 14 } } },
}

local textures = {
    ['tx'] = { t = 'dark1', path = ctrl.p.tx, l = -7 },
    ['bktx'] = { target = 'bk', t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
}

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
    if not ctrl.alert.ux.c.bk then 
        ctrl.alert:warn('no bk found')
        return
    end
    

    ctrl.alert.fs = ctrl.alert.fs or {}
    for i = 1, ctrl.alert.options.maxLines do
        local set = {
            target = ctrl.alert.ux.c.bk,
            fontFile = ctrl.alert.options.fontFile,
            fontSize = ctrl.alert.options.fontSize,
            x = 24,
            y = -((i-1) * 30),
            jH = 'CENTER',
            jV = 'MIDDLE',
            n = 'fs' .. i
        }

        ctrl.alert.fs[i] = ctrl.fs:new(set)
        ctrl.alert.fs[i]:SetText('fs ' .. i)
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
    --local bufferSize = ctrl.count(ctrl.alert.buffer)
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

function ctrl.alert:redrawAlertFrame()
    for i = 1, self.options.maxLines do
        if not ctrl.alert.fs[i] then
            ctrl.alert:warn('no fs found: ' .. i)
        else
            ctrl.alert.fs[i]:ClearAllPoints()
            ctrl.alert.fs[i]:SetPoint(a.t, ctrl.alert.ux.c.bk, a.t, 0, 0 - ((i-1) * 46))
        end
    end
end

function ctrl.alert.setup(self)
    self.ux.f = ctrl.frame:new(self.options.frame, self)
    self.f = self.ux.f

    ctrl.frame:generate(subframes, self)
    --ctrl.tx:generate(textures, self)

    self:createFontStrings()
    --self:redrawAlertFrame()

    self:add(c.r..'ctrl' .. c.o..':' .. c.y .. 'alert' .. c.g.. ' initialized')
    if ctrl.alert.options.debug then self:add(c.y .. s.warn .. ' Debug mode enabled.') end
end

ctrl.alert:init()
