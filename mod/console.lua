--[[ ctrl - console.lua - t@wse.nyc - 7/24/24 ]]

---@class ctrl
local ctrl = select(2, ...)

local C, c, s, a = ctrl, ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'console',
    color = ctrl.c.v,
    symbol = ctrl.s.console,
    zoom = 1,
    options = {
        fontFile = 'MartianMono-sWdMd.otf',
        fontSize = 18,
        frame = {
            name = 'ctrl',
            w = 480,
            h = 200,
            x = 200,
            y = -200,
            isResizable = 1,
            isMovable = 1,
            isClipsChildren = 1,
            globalName = 'ctrlFrameTemp',
        },
    }
}

ctrl.console = ctrl.mod:new(mod)

local subframes = {
    ['bk'] = { anchors = { { a = a.tl, pa = a.tl, x = 24, y = -64 }, { a = a.br, pa = a.br, x = -24, y = 8, isClipsChildren = 1, } } },
    ['sf'] = { subclass = 'ScrollingMessageFrame', target = ctrl.console.ux.c.bk, anchors = { { a = a.tl, pa = a.tl, x = 16, y = -20 }, { a = a.br, pa = a.br, x = -8, y = 16 } } },
}

local textures = {
    ['tx'] = { t = 'dark1', path = ctrl.p.tx, l = -7 },
    ['bktx'] = { target = 'bk', t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
}

local fontstrings = {
    ['fsTitle'] = {t = ctrl.name, fontFile = 'Data70-Regular.otf', fontSize = 48, a = a.tl, pa = a.tl, x = 36, y = -12},
    ['fsbReload'] = { t = 'C_UI.Reload()', target = 'bReload', fontFile = 'Prompt-Medium.ttf', fontSize = 24, x = -2, y = -3},
    ['fsbZoomIn'] = { t = ctrl.s.zoomIn, target = 'bZoomIn', fontFile = 'Prompt-Medium.ttf', fontSize = 36, x = -2, y = -3},
    ['fsbZoomOut'] = { t = ctrl.s.zoomOut, target = 'bZoomOut', fontFile = 'Prompt-Medium.ttf', fontSize = 36, x = -2, y = -3},
    ['fsbInspect'] = { t = ctrl.s.i, target = 'bInspect', fontFile = 'Prompt-Medium.ttf', fontSize = 32, x = -4, y = -3},
}

local buttons = {
    ['bReload'] = { template = 'btn_beeg', btnColor = { 0.75, 0, 0, 1 }, h = 90, w = 224, anchors = { { a = a.tr, pa = a.tr, x = -268, y = 7 } }},
    ['bZoomIn'] = { template = 'btn_smol', btnColor = { 0, 0.75, 0, 1 }, h = 84, w = 84, anchors = { { a = a.tr, pa = a.tr, x = -184, y = 4 } }},
    ['bZoomOut'] = { template = 'btn_smol', btnColor = { 0, 0, 0.75, 1 }, h = 84, w = 84, anchors = { { a = a.tr, pa = a.tr, x = -100, y = 4 } }},
    ['bInspect'] = { template = 'btn_smol', btnColor = { 0, 0.75, 0.75, 1 }, h = 84, w = 84, anchors = { { a = a.tr, pa = a.tr, x = -16, y = 4 } }},
}

local function ConfigureScrollFrame(self, f)
    local font = ctrl.console.options.fontFile or 'GlassTTYVT220-Medium.ttf'
    local fontSize = ctrl.console.options.fontSize or 24
    f:SetFont(ctrl.p.fnt .. font, fontSize, "")
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

function ctrl.console:evt(e)
    self:debug('console received event', e[1])
end

function ctrl.console:click(btn, btn2)
    if btn.name == 'bInspect' then
        DisplayTableInspectorWindow(ctrl.console)
        elseif btn.name == 'bZoomIn' then
            ctrl.console.zoom = ctrl.console.zoom + 0.2
            ctrl.console:resize()
        elseif btn.name == 'bZoomOut' then
            ctrl.console.zoom = ctrl.console.zoom - 0.2
            ctrl.console:resize()
        elseif btn.name == 'bReload' then
            C_UI.Reload()
    end
end

function ctrl.console:resize(f, w, h)
    ctrl.f.r:ClearAllPoints()
    ctrl.f.r:SetSize(36, 36)
    ctrl.f.r:SetPoint('BOTTOMRIGHT', ctrl.f, 'BOTTOMRIGHT', -8, 8)
    ctrl.f.r.on:SetAllPoints(self.ux.f.r)
    ctrl.f.r.off:SetAllPoints(self.ux.f.r)
    local uis = UIParent:GetScale()

    ctrl.console.ux.c.bk:SetClipsChildren(true)
    ctrl.console.ux.c.bk:ClearAllPoints()
    ctrl.console.ux.c.bk:SetPoint(subframes.bk.anchors[1].a, ctrl.console.ux.f, subframes.bk.anchors[1].pa, subframes.bk.anchors[1].x, subframes.bk.anchors[1].y)
    ctrl.console.ux.c.bk:SetPoint(subframes.bk.anchors[2].a, ctrl.console.ux.f, subframes.bk.anchors[2].pa, subframes.bk.anchors[2].x, subframes.bk.anchors[2].y)
    ctrl.sf:ClearAllPoints()
    ctrl.sf:SetPoint('TOPLEFT', ctrl.console.ux.c.bk, 'TOPLEFT', 12, -12)
    ctrl.sf:SetPoint('BOTTOMRIGHT', ctrl.console.ux.c.bk, 'BOTTOMRIGHT', 2000, 12)

    local newScale = math.abs(1 - uis) * 2
    if newScale < 0.3 then newScale = 0.3 end
    newScale = newScale * ctrl.console.zoom
    ctrl.f:SetScale(newScale)
end

--[[
function ctrl.console:reanchor()
    ctrl.f.tx:ClearAllPoints()
    ctrl.f.tx:SetAllPoints(ctrl.f)

    ctrl.bk:ClearAllPoints()
    ctrl.bk:SetPoint('TOPLEFT', ctrl.f, 'TOPLEFT', 24, -24)
    ctrl.bk:SetPoint('BOTTOMRIGHT', ctrl.f, 'BOTTOMRIGHT', -24, 24)

    ctrl.bk.tx:ClearAllPoints()
    ctrl.bk.tx:SetAllPoints(ctrl.bk)

    ctrl.sf:ClearAllPoints()
    ctrl.sf:SetPoint('TOPLEFT', ctrl.bk, 'TOPLEFT', 12, -12)
    ctrl.sf:SetPoint('BOTTOMRIGHT', ctrl.bk, 'BOTTOMRIGHT', 600, 12)
end
]]

function ctrl.console.setup(self)
    self.ux.f = ctrl.frame:new(self.options.frame, self)
    ctrl.f = self.ux.f

    ctrl.frame:generate(subframes, self)

    ctrl.sf = ctrl.console.ux.c.sf
    ConfigureScrollFrame(self, ctrl.sf)

    ctrl.tx:generate(textures, self)
    ctrl.btns:generate(buttons, self)
    ctrl.fs:generate(fontstrings, self)

    self:debug(string.format('%sConsole Initialized %s', ctrl.c.b, date('%I:%M:%S', GetTime())))
    --_G.ctrl = ctrl.external
end

ctrl.console:init()