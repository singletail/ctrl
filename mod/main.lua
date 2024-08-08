--[[ ctrl - main.lua - t@wse.nyc - 7/24/24 ]]

local _, ctrl = ...
local C, c, s, a = ctrl, ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'main',
    color = ctrl.c.v,
    symbol = ctrl.s.console,
    options = {
        frame = {
            name = 'ctrl',
            w = 480,
            h = 200,
            x = 200,
            y = -200,
            isResizable = 1,
            isMovable = 1,
            globalName = 'ctrlFrameTemp',
        },
    }
}

ctrl.main = ctrl.mod:new(mod)

local subframes = {
    ['bk'] = { anchors = { { a = a.tl, pa = a.tl, x = 12, y = -18 }, { a = a.br, pa = a.br, x = -12, y = 8 } } },
    ['sf'] = { subclass = 'ScrollingMessageFrame', target = 'bk', anchors = { { a = a.tl, pa = a.tl, x = 16, y = -20 }, { a = a.br, pa = a.br, x = -8, y = 16 } } },
}

local textures = {
    ['tx'] = { t = 'dark1', path = ctrl.p.tx, l = -7 },
    ['bktx'] = { target = 'bk', t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
}

local fontstrings = {
    ['fsTitle'] = {
        t = ctrl.name, fontFile = 'PrintChar21-Medium.ttf', fontSize = 12, a = a.tl, pa = a.tl, x = 14, y = -4
    },
    --['fsBtest'] = {
    --    t = 'BTN', target = 'bTest', fontFile = 'Prompt-Medium.ttf', fontSize = 12, x = 0, y = -2
    --},
}

local buttons = {
    ['bTest'] = {
        template = 'btn_smol',
        btnColor = { 1.0, 0, 0, 1 },
        h = 48,
        w = 48,
        anchors = { { a = a.tr, pa = a.tr, x = -16, y = 4 } }
    },
}

local function ConfigureScrollFrame(self, f)
    local font = 'SourceCodePro-Medium.ttf'
    f:SetFont(ctrl.p.fnt .. font, 15, "")
    f:SetSpacing(3)
    f:SetFading(false)
    f:SetMaxLines(2000)
    f:SetJustifyH('LEFT')
    f:EnableMouse(false)
    f:EnableMouseWheel(true)
    f:SetInsertMode("BOTTOM")
    f:SetScript('OnMouseWheel', function(s, delta)
        s:ScrollByAmount(delta * 3)
    end)
end

local msgTab = ctrl.newTable('')
msgTab[1] = c.p
msgTab[2] = ' '

local function getBuffer(buffer)
    return table.concat(buffer, ' ')
end

function ctrl.main:evt(e)
    self:debug('main received event', e[1])
end

function ctrl.main:click(btn, btn2)
    self:debug('click', tostring(btn.name), tostring(btn2.name), tostring(btn:getValue()))
end

function ctrl.main:resize(f, w, h)
    ctrl.f.r:ClearAllPoints()
    ctrl.f.r:SetSize(36, 36)
    ctrl.f.r:SetPoint('BOTTOMRIGHT', ctrl.f, 'BOTTOMRIGHT', -10, 8)
    ctrl.f.r.on:SetAllPoints(self.ux.f.r)
    ctrl.f.r.off:SetAllPoints(self.ux.f.r)
    local uis = UIParent:GetScale()
    ctrl.f:SetScale((1 - uis) * 2)
end

function ctrl.main:reanchor()
    ctrl.f.tx:ClearAllPoints()
    ctrl.f.tx:SetAllPoints(ctrl.f)

    ctrl.bk:ClearAllPoints()
    ctrl.bk:SetPoint('TOPLEFT', ctrl.f, 'TOPLEFT', 24, -24)
    ctrl.bk:SetPoint('BOTTOMRIGHT', ctrl.f, 'BOTTOMRIGHT', -24, 24)

    ctrl.bk.tx:ClearAllPoints()
    ctrl.bk.tx:SetAllPoints(ctrl.bk)

    ctrl.sf:ClearAllPoints()
    ctrl.sf:SetPoint('TOPLEFT', ctrl.bk, 'TOPLEFT', 12, -12)
    ctrl.sf:SetPoint('BOTTOMRIGHT', ctrl.bk, 'BOTTOMRIGHT', -12, 12)
end

function ctrl.main.setup(self)
    self.ux.f = ctrl.frame:new(self.options.frame, self)
    ctrl.f = self.ux.f

    ctrl.frame:generate(subframes, self)
    ctrl.sf = self.ux.c.sf
    ConfigureScrollFrame(self, ctrl.sf)

    ctrl.tx:generate(textures, self)
    --ctrl.btns:generate(buttons, self)
    ctrl.fs:generate(fontstrings, self)

    self:debug(string.format('%sConsole Initialized %s', ctrl.c.b, date('%I:%M:%S', GetTime())))
    --_G.ctrl = ctrl.external
end

ctrl.main:init()
