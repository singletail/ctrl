--[[ ctrl - power.lua - t@wse.nyc - 8/14/24 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'power',
    color = c.r,
    symbol = s.power,
    frames = {},
    nFrames = 0,
    options = {
        timers = { 1 },
        frame = { w=0, h=0, x=0, y=0, a=a.tl, pa=a.tl, isMovable=true },
        numButtons = 9,
    },
}

ctrl.power = ctrl.mod:new(mod)

local subframes = {
    ['btns'] = {target='main', w=0, h=0, a=a.tl, pa=a.tl, x=0, y=0},
}

local textures = {
    ['maindark'] = { t='dark1', path=ctrl.p.tx, target='main', l=-6, al=0.6 },
    ['ctrl_v'] = {target='main', t='ctrl_sm.png', path=ctrl.p.ctrl, l=-5, w=16, h=32, a=a.t, pa=a.t, x=0, y=-4 },
}

function ctrl.power:register(fObj)
    ctrl.power.frames = ctrl.power.frames or {}
    local fNum = ctrl.power.nFrames + 1
    ctrl.power.frames['f' .. fNum] = fObj
    ctrl.power.nFrames = fNum
end

function ctrl.power:resize()
    --self:debug('resize')
end

function ctrl.power:tick()
    ctrl.power:draw()
end

function ctrl.power:setModule(moduleIndex, state)
    --self:debug('setModule ' .. moduleIndex .. ' ' .. tostring(state))
    local fObj = ctrl.power.frames['f' .. moduleIndex]
    if not fObj then return end
    if state == 1 then
        fObj.module.on(fObj.module)
    else
        fObj.module.off(fObj.module)
    end
end

function ctrl.power:click(btn)
    btn:toggle()
    if (btn.name == 'b0') then
        for i=1, ctrl.power.nFrames do
            self:setModule(i, btn:getValue())
        end
    else
        local fNum = tonumber(string.sub(btn.name, 2))
        self:setModule(fNum, btn:getValue())
    end
    ctrl.power:draw()
end

function ctrl.power:draw()
    local x, y = 0, 0
    for i=1, self.nFrames do
        local fObj = self.frames['f'..i]
        local btn = ctrl.power.btn['b'..i]
        if not btn then return end
        local hexString = strsub(fObj.module.color, 9, 10)
        hexString = hexString .. strsub(fObj.module.color, 3, 8)
        btn:setColor(fObj.colorObj[1], fObj.colorObj[2], fObj.colorObj[3], fObj.colorObj[4])
        ctrl.power.btn['b'..i]:Show()
        ctrl.power.fs['fsb'..i]:SetText(c.k..fObj.symbol)
        ctrl.power.fs['fsb'..i]:Show()
        if fObj.module.is.on then
            btn:setValue(1)
            fObj.frame:ClearAllPoints()
            fObj.frame:SetPoint(a.tl, ctrl.power.f.main, a.tr, x, y)
            fObj.frame:Show()
            x = x + fObj.frame:GetWidth()
        else
            btn:setValue(0)
            fObj.frame:Hide()
        end
    end
    for off=self.nFrames+1, self.options.numButtons do
        ctrl.power.btn['b'..off]:Hide()
        ctrl.power.fs['fsb'..off]:Hide()
    end
end

function ctrl.power:prefs()
    self.options.frame.h = ctrl.prefs.ui.height
    self.options.frame.w = ctrl.prefs.mod.power.frame.width
    subframes['btns'].h = ctrl.prefs.ui.height
    subframes['btns'].w = ctrl.prefs.mod.power.frame.width
    self.options.buttons = self.options.buttons or {}
    self.options.fontstrings = self.options.fontstrings or {}
    for i=0, self.options.numButtons do
        self.options.buttons['b'..i] = {target='btns', template='gv', btnColor={1.0, 1.0, 0.75, 0.25}, anchors={{a=a.t, pa=a.t, y=0, x=0}}}
        self.options.buttons['b'..i].w = ctrl.prefs.mod.power.buttons.width
        self.options.buttons['b'..i].h = ctrl.prefs.mod.power.buttons.height
        self.options.buttons['b'..i].anchors[1].y = ctrl.prefs.mod.power.buttons.top - (i * (ctrl.prefs.mod.power.buttons.height + ctrl.prefs.mod.power.buttons.spacing))
        self.options.fontstrings['fsb'..i] = {target='b'..i, t=c.k..s.power, a=a.c, pa=a.c, jH=a.c}
        self.options.fontstrings['fsb'..i].fontFile = ctrl.prefs.mod.power.font.file
        self.options.fontstrings['fsb'..i].fontSize = ctrl.prefs.mod.power.font.size
        self.options.fontstrings['fsb'..i].x = ctrl.prefs.mod.power.font.offset.x
        self.options.fontstrings['fsb'..i].y = ctrl.prefs.mod.power.font.offset.y
    end
end

function ctrl.power.setup(self)
    self:prefs()
    ctrl.power.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.power.f.main:SetScale(ctrl.prefs.ui.scale)
    ctrl.frame.generate(self, subframes)
    ctrl.tx.generate(self, textures)
    ctrl.btns.generate(self, self.options.buttons)
    ctrl.fs.generate(self, self.options.fontstrings)
end

ctrl.power:init()

