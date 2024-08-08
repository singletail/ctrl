--[[ ctrl - alert.lua - t@wse.nyc - 8/5/24 ]] --

local _, ctrl = ...
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'alert',
    color = c.r,
    symbol = s.notice,
    options = {
        debug = nil,
        frame = {
            w = 800,
            h = 150,
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
    ['bk'] = { anchors = { { a = a.tl, pa = a.tl, x = 12, y = -36 }, { a = a.br, pa = a.br, x = -12, y = 12 } } },
    ['sf'] = { subclass = 'ScrollingMessageFrame', target = 'bk', anchors = { { a = a.tl, pa = a.tl, x = 20, y = -20 }, { a = a.br, pa = a.br, x = -16, y = 14 } } },
}

local textures = {
    ['tx'] = { t = 'dark1', path = ctrl.p.tx, l = -7 },
    ['bktx'] = { target = 'bk', t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
}

function ctrl.alert:add(msg)
    if not msg then msg = self end
    ctrl.alert.ux.c.sf:AddMessage(msg)
end

function ctrl.alert:resize(f, w, h)
end

local function configureScrollFrame(f)
    local font = 'Prompt-SemiBold.ttf'
    f:SetFont(ctrl.p.fnt .. font, 18, "")
    if ctrl.alert.options.debug then
        f:SetFading(false)
    else
        f:SetFading(true)
        f:SetTimeVisible(10)
    end

    f:SetSpacing(2)
    f:SetMaxLines(100)
    f:SetJustifyH('CENTER')
    f:EnableMouse(false)
    f:SetInsertMode("BOTTOM")
end

function ctrl.alert.setup(self)
    self.ux.f = ctrl.frame:new(self.options.frame, self)
    ctrl.frame:generate(subframes, self)
    configureScrollFrame(self.ux.c.sf)
    self:add('ctrl:alert initialized.')
    if ctrl.alert.options.debug then self:add(c.y .. s.warn .. ' Debug mode enabled.') end
end

ctrl.alert:init()
