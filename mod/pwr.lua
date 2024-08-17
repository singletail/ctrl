--[[ ctrl - power.lua - t@wse.nyc - 8/14/24 ]]
--

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'pwr',
    color = c.r,
    symbol = s.power,
    options = {
        --frame = { w = 83, h = 36, x = 200, y = -200, a=a.tl, pa=a.tl,isMovable = true },
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
    ['fsbctrl'] = { target='b1', t = c.k..s.ctrl, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
    ['fsbinfo'] = { target='b2', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = 14, x = 0.5, y = -0.5, a=a.c, pa=a.c, jH=a.c },
}


function ctrl.pwr:resize()
    self:debug('resize')
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

function ctrl.pwr.setup(self)
    ctrl.pwr.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.frame.generate(self, subframes)

    ctrl.tx.generate(self, textures)
    ctrl.btns.generate(self, buttons)
    ctrl.fs.generate(self, fontstrings)
end

ctrl.pwr:init()

