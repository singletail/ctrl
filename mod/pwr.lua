--[[ ctrl - power.lua - t@wse.nyc - 8/14/24 ]]
--

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'pwr',
    color = c.r,
    symbol = s.power,
    frames = {},
    nFrames = 0,
    options = {
        timers = { 1 },
        frame = { w = 86, h = 28, x = 200, y = -200, a=a.tl, pa=a.tl,isMovable = true },
    },
}

ctrl.pwr = ctrl.mod:new(mod)

local subframes = {
    ['btnframe'] = { target='main', w=234, h=33, a=a.tl, pa=a.bl, x=0, y=0},
}

local textures = {
    ['main'] = { t = 'metal_half_h', path = ctrl.p.tx, target='main', l = -7 },
    ['btnsbk'] = { target = 'btnframe', t = 'metal_eighth_h', path = ctrl.p.tx, l = -6 },
}

local fontstrings = {
    ['fsctrl'] = { target='main', t = ctrl.c.r .. 'c'..c.y..'t'..c.g..'r'..c.c..'l', fontFile = 'Data70-Regular.otf', fontSize = 18, x = 8, y = -1 },
    ['fsbpwr'] = { target='bpower', t = c.k..s.power, fontFile = 'Data70-Regular.otf', fontSize = 14, x = 0, y = 0, a=a.c, pa=a.c, jH=a.c },
    ['fsbmin'] = { target='bmin', t = c.k..s.min, fontFile = 'AnkaCoder-Bold.ttf', fontPath=ctrl.p.fntf, fontSize = 14, x = 0, y = 0, a=a.c, pa=a.c, jH=a.c },
    ['fsb1'] = { target='b1', t = c.k..s.ctrl, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsb2'] = { target='b2', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsb3'] = { target='b3', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsb4'] = { target='b4', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsb5'] = { target='b5', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsb6'] = { target='b6', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsb7'] = { target='b7', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsb8'] = { target='b8', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsb9'] = { target='b9', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
}

function ctrl.pwr:resize()
    --self:debug('resize')
end

local buttons = {
    ['bpower'] = { target = 'main', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 30, y = -1 } }},
    ['bmin'] = { target = 'main', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 54, y = -1 } }},
    ['b1'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 6, y = -3 } }},
    ['b2'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 30, y = -3 } }},
    ['b3'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 54, y = -3 } }},
    ['b4'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 78, y = -3 } }},
    ['b5'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 102, y = -3 } }},
    ['b6'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 126, y = -3 } }},
    ['b7'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 150, y = -3 } }},
    ['b8'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 174, y = -3 } }},
    ['b9'] = { target = 'btnframe', template = 'sq', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h = 28, w = 28, anchors = { { a = a.tl, pa = a.tl, x = 198, y = -3 } }},
}

function ctrl.pwr:register(fObj)
    ctrl.pwr.frames = ctrl.pwr.frames or {}
    ctrl.pwr.frames['f' .. fObj.index] = fObj
    ctrl.pwr.nFrames = ctrl.pwr.nFrames + 1
end

function ctrl.pwr:tick()
    ctrl.pwr:draw()
end

function ctrl.pwr:click(btn)
    local fNum = tonumber(string.sub(btn.name, 2))
    local module = ctrl.pwr.frames['f'..fNum].module
    if btn:getValue() == 1 then
        module.off(module)
    else
        module.on(module)
    end
    ctrl.pwr:draw()
end

function ctrl.pwr:draw()
    local x, y = 0, -32
    for i=1, self.nFrames do
        fObj = self.frames['f'..i]
        local btn = ctrl.pwr.btn['b'..i]
        local hexString = strsub(fObj.module.color, 9, 10)
        hexString = hexString .. strsub(fObj.module.color, 3, 8)
        btn:setColor(fObj.colorObj[1], fObj.colorObj[2], fObj.colorObj[3], fObj.colorObj[4])
        ctrl.pwr.fs['fsb'..i]:SetText(c.k..fObj.symbol)
        if fObj.module.is.on then
            btn:setValue(1)
            fObj.frame:ClearAllPoints()
            fObj.frame:SetPoint(a.tl, ctrl.pwr.f.main, a.bl, x, y)
            fObj.frame:Show()
            x = x + fObj.frame:GetWidth()
        else
            btn:setValue(0)
            fObj.frame:Hide()
        end
    end
end

function ctrl.pwr.setup(self)
    ctrl.pwr.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.frame.generate(self, subframes)

    ctrl.tx.generate(self, textures)
    ctrl.btns.generate(self, buttons)
    ctrl.fs.generate(self, fontstrings)
end

ctrl.pwr:init()

