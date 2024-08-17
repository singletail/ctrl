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
        fontSize = 12,
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
    --['bk'] = { anchors = { { a = a.tl, pa = a.tl, x = 12, y = -36 }, { a = a.br, pa = a.br, x = -12, y = 8, isClipsChildren = 1, } } },
    ['sf'] = { template = 'ScrollingMessageFrame', target = 'main', anchors = { { a = a.tl, pa = a.tl, x = 16, y = -8 }, { a = a.br, pa = a.br, x = -8, y = 16 } } },
}

local textures = {
    ['tx'] = { t = 'dark1', target='main', path = ctrl.p.tx, l = -7 },
    ['bktx'] = { target='main', t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
}

local fontstrings = {
    ['fsTitle'] = {t = ctrl.name, fontFile = 'Data70-Regular.otf', fontSize = 32, a = a.tl, pa = a.tl, x = 24, y = -2},
    ['fsbReload'] = { t = 'C_UI.Reload()', target = 'bReload', fontFile = 'Prompt-Medium.ttf', fontSize = 16, x = -1, y = -1},
    ['fsbZoomIn'] = { t = ctrl.s.zoomIn, target = 'bZoomIn', fontFile = 'Prompt-Medium.ttf', fontSize = 18, x = -1, y = -1},
    ['fsbZoomOut'] = { t = ctrl.s.zoomOut, target = 'bZoomOut', fontFile = 'Prompt-Medium.ttf', fontSize = 18, x = -1, y = -1},
    ['fsbInspect'] = { t = ctrl.s.i, target = 'bInspect', fontFile = 'Prompt-Medium.ttf', fontSize = 18, x = -1, y = -1},
}

local buttons = {
    ['bReload'] = { template = 'btn_beeg', btnColor = { 0.75, 0, 0, 1 }, h = 52, w = 148, anchors = { { a = a.tr, pa = a.tr, x = -166, y = 7 } }},
    ['bZoomIn'] = { template = 'btn_smol', btnColor = { 0, 0.75, 0, 1 }, h = 48, w = 56, anchors = { { a = a.tr, pa = a.tr, x = -116, y = 4 } }},
    ['bZoomOut'] = { template = 'btn_smol', btnColor = { 0, 0, 0.75, 1 }, h = 48, w = 56, anchors = { { a = a.tr, pa = a.tr, x = -66, y = 4 } }},
    ['bInspect'] = { template = 'btn_smol', btnColor = { 0, 0.75, 0.75, 1 }, h = 48, w = 56, anchors = { { a = a.tr, pa = a.tr, x = -16, y = 4 } }},
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
--[[
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
    ]]
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
    ctrl.power.f = {}
    ctrl.power.tx = {}

    ctrl.power.f.main = ctrl.frame:new(self.options.frame)

    for fname, fopts in pairs(subframes) do
        if type(fopts.target) == 'string' then fopts.target = self.f[fopts.target] end
        self.f[fname] = ctrl.frame:new(fopts)
    end

    ctrl.sf = ctrl.console.f.sf
    ConfigureScrollFrame(self, ctrl.sf)

    for tname, topts in pairs(textures) do
        if type(topts.target) == 'string' then topts.target = self.f[topts.target] end
        ctrl.power.tx[tname] = ctrl.tx:new(topts) 
    end


    --ctrl.btns:generate(buttons, self)
    --ctrl.fs:generate(fontstrings, self)

    self:debug(string.format('%sConsole Initialized %s', ctrl.c.b, date('%I:%M:%S', GetTime())))
    --_G.ctrl = ctrl.external
end

ctrl.console:init()
