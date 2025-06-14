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
        frame = { w=25*ctrl.uimult, h=ctrl.uiheight, x=0, y=0, a=a.tl, pa=a.tl, isMovable = true },
    },
}

ctrl.pwr = ctrl.mod:new(mod)

local subframes = {
    ['btnframe'] = {target='main', w=25*ctrl.uimult, h=ctrl.uiheight, a=a.tl, pa=a.tl, x=0, y=0},
}

local textures = {
    --['main'] = { t='decktex512', path=ctrl.p.tx, target='main', l=-7 },
    ['maindark'] = { t='dark1', path=ctrl.p.tx, target='main', l=-6 },
    ['ctrl_v'] = {target='main', t='ctrl_v_top', path=ctrl.p.ctrl, l=-5, w=16*ctrl.uimult, h=68*ctrl.uimult, a=a.t, pa=a.t, x=0.5*ctrl.uimult, y=-4*ctrl.uimult },
}

local fntsize = 13 *ctrl.uimult
local fox = 0.5 *ctrl.uimult
local foy = -0.5 *ctrl.uimult
local fontstrings = {
    ['fsbpwr'] = { target='bpower', t = c.k..s.power, fontFile = 'Data70-Regular.otf', fontSize=fntsize-(1*ctrl.uimult), x=fox-(0.17*ctrl.uimult), y=foy+(0.5*ctrl.uimult), a=a.c, pa=a.c, jH=a.c },
    ['fsb1'] = { target='b1', t = c.k..s.ctrl, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize-(1*ctrl.uimult), x=fox+(0.1*ctrl.uimult), y=foy, a=a.c, pa=a.c, jH=a.c },
    ['fsb2'] = { target='b2', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize, x=fox, y=foy, a=a.c, pa=a.c, jH=a.c },
    ['fsb3'] = { target='b3', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize, x=fox, y=foy, a=a.c, pa=a.c, jH=a.c },
    ['fsb4'] = { target='b4', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize, x=fox, y=foy, a=a.c, pa=a.c, jH=a.c },
    ['fsb5'] = { target='b5', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize, x=fox, y=foy, a=a.c, pa=a.c, jH=a.c },
    ['fsb6'] = { target='b6', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize, x=fox, y=foy, a=a.c, pa=a.c, jH=a.c },
    ['fsb7'] = { target='b7', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize, x=fox, y=foy, a=a.c, pa=a.c, jH=a.c },
    ['fsb8'] = { target='b8', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize, x=fox, y=foy, a=a.c, pa=a.c, jH=a.c },
    ['fsb9'] = { target='b9', t = c.k..s.info, fontFile = 'AnkaCoder-Bold.ttf', fontSize = fntsize, x=fox, y=foy, a=a.c, pa=a.c, jH=a.c },
}

local btnsize = 27 *ctrl.uimult
local btnxo = -0.5 *ctrl.uimult
local buttons = {
    ['bpower'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-53*ctrl.uimult), x=btnxo } }},
    ['b1'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-73*ctrl.uimult), x=btnxo } }},
    ['b2'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-93*ctrl.uimult), x=btnxo } }},
    ['b3'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-113*ctrl.uimult), x=btnxo } }},
    ['b4'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-133*ctrl.uimult), x=btnxo } }},
    ['b5'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-153*ctrl.uimult), x=btnxo } }},
    ['b6'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-173*ctrl.uimult), x=btnxo } }},
    ['b7'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-193*ctrl.uimult), x=btnxo } }},
    ['b8'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-213*ctrl.uimult), x=btnxo } }},
    ['b9'] = { target = 'btnframe', template = 'ins', btnColor = { 1.0, 1.0, 0.75, 0.25 }, h=btnsize, w=btnsize, anchors = { { a=a.tl, pa=a.tl, y=(-233*ctrl.uimult), x=btnxo } }},
}

function ctrl.pwr:register(fObj)
    ctrl.pwr.frames = ctrl.pwr.frames or {}
    local fNum = ctrl.pwr.nFrames + 1
    ctrl.pwr.frames['f' .. fNum] = fObj
    ctrl.pwr.nFrames = fNum
end

function ctrl.pwr:resize()
    --self:debug('resize')
end

function ctrl.pwr:tick()
    ctrl.pwr:draw()
end

function ctrl.pwr:click(btn)
    if (btn.name == 'bpower') then
        if btn:getValue() == 1 then
            self:debug('power off to do')
        else
            self:debug('power on to do')
        end
    else
        local fNum = tonumber(string.sub(btn.name, 2))
        if ctrl.pwr.frames['f'..fNum] then
            local module = ctrl.pwr.frames['f'..fNum].module
            if btn:getValue() == 1 then
                module.off(module)
            else
                module.on(module)
            end
        end
    end
    ctrl.pwr:draw()
end

function ctrl.pwr:draw()
    local x, y = 1, -1
    for i=1, self.nFrames do
        local fObj = self.frames['f'..i]
        local btn = ctrl.pwr.btn['b'..i]
        if not btn then return end
        local hexString = strsub(fObj.module.color, 9, 10)
        hexString = hexString .. strsub(fObj.module.color, 3, 8)
        btn:setColor(fObj.colorObj[1], fObj.colorObj[2], fObj.colorObj[3], fObj.colorObj[4])
        ctrl.pwr.fs['fsb'..i]:SetText(c.k..fObj.symbol)
        if fObj.module.is.on then
            btn:setValue(1)
            fObj.frame:ClearAllPoints()
            fObj.frame:SetPoint(a.tl, ctrl.pwr.f.main, a.tr, x, y)
            fObj.frame:Show()
            x = x + fObj.frame:GetWidth()
        else
            btn:setValue(0)
            fObj.frame:Hide()
        end
    end
    for off=self.nFrames+1, 9 do
        ctrl.pwr.btn['b'..off]:Hide()
        ctrl.pwr.fs['fsb'..off]:Hide()
    end
    self.f.btnframe:SetWidth((self.nFrames * 24) + 16)
end

function ctrl.pwr.setup(self)
    ctrl.pwr.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.pwr.f.main:SetScale(ctrl.setting.scale)
    ctrl.frame.generate(self, subframes)

    ctrl.tx.generate(self, textures)
    ctrl.btns.generate(self, buttons)
    ctrl.fs.generate(self, fontstrings)
end

ctrl.pwr:init()

