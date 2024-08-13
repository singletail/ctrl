--[[ ctrl - info.lua - t@wse.nyc - 8/7/24 ]]
--

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'space1999',
    color = c.o,
    symbol = s.info,
    options = {
        frame = {
            name = 'info',
            w = 512,
            h = 384,
            x = 200,
            y = -200,
            isResizable = 1,
            isMovable = 1,
            globalName = 'space1999',
        },
        events = {
            'UI_SCALE_CHANGED'
        },
        timers = {
            1,
        },
    }
}

ctrl.space1999 = ctrl.mod:new(mod)

local subframes = {
    --['bk'] = { anchors = { { a = a.tl, pa = a.tl, x = 12, y = -36 }, { a = a.br, pa = a.br, x = -12, y = 12 } } },
    --['sf'] = { subclass = 'ScrollingMessageFrame', target = 'bk', anchors = { { a = a.tl, pa = a.tl, x = 20, y = -20 }, { a = a.br, pa = a.br, x = -16, y = 14 } } },
}

local textures = {
    ['tx'] = { t = 'top', path = ctrl.p[1999], l = -7 },
    --['bktx'] = { target = 'bk', t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
}

local fft = 'Prompt-Light.ttf'
local ffv = 'PrintChar21-Medium.ttf'
local fsl = 48
local top = 18
local fs = 24
local fst = 24
local fsv = 21
local spa = 4

local fontstrings = {
    ['fsTitle'] = { t = ctrl.c.w .. s.info, fontFile = fft, fontSize = 60, a = a.tl, pa = a.tl, x = 56, y = -60 },
    ['fst_servertime'] = { t = ctrl.c.y .. 'serverTime:', fontFile = fft, fontSize = fst, a = a.tr, pa = a.t, x = fsl, y = -100 },
    ['fsv_servertime'] = { t = ctrl.c.g .. '--', fontFile = ffv, fontSize = fsv, a = a.tl, pa = a.t, x = fsl, y = -100 },
    ['fst_useuiscale'] = { t = ctrl.c.r .. 'useUiScale:', fontFile = fft, fontSize = fst, a = a.tr, pa = a.tr, x = fsl, y = -150 },
    ['fsv_useuiscale'] = { t = ctrl.c.g .. '--', fontFile = ffv, fontSize = fsv, a = a.tl, pa = a.tl, x = fsl, y = -150 },
    ['fst_uiscale'] = { t = ctrl.c.r .. 'uiScale:', fontFile = fft, fontSize = fst, a = a.tr, pa = a.tr, x = fsl, y = -200 },
    ['fsv_uiscale'] = { t = ctrl.c.g .. '--', fontFile = ffv, fontSize = fsv, a = a.tl, pa = a.tl, x = fsl, y = -200 },
    ['fst_pscreenHeight'] = { t = ctrl.c.o .. 'physicalScreenHeight:', fontFile = fft, fontSize = fst, a = a.tr, pa = a.tr, x = fsl, y = -250 },
    ['fsv_pscreenHeight'] = { t = ctrl.c.g .. '--', fontFile = ffv, fontSize = fsv, a = a.tl, pa = a.tl, x = fsl, y = -250 },
    ['fst_pscreenWidth'] = { t = ctrl.c.o .. 'physicalScreenWidth:', fontFile = fft, fontSize = fst, a = a.tr, pa = a.tr, x = fsl, y = -300 },
    ['fsv_pscreenWidth'] = { t = ctrl.c.g .. '--', fontFile = ffv, fontSize = fsv, a = a.tl, pa = a.tl, x = fsl, y = -300 },
    ['fst_screenHeight'] = { t = ctrl.c.o .. 'screenHeight:', fontFile = fft, fontSize = fst, a = a.tr, pa = a.tr, x = fsl, y = -250 },
    ['fsv_screenHeight'] = { t = ctrl.c.g .. '--', fontFile = ffv, fontSize = fsv, a = a.tl, pa = a.tl, x = fsl, y = -250 },
    ['fst_screenWidth'] = { t = ctrl.c.o .. 'screenWidth:', fontFile = fft, fontSize = fst, a = a.tr, pa = a.tr, x = fsl, y = -300 },
    ['fsv_screenWidth'] = { t = ctrl.c.g .. '--', fontFile = ffv, fontSize = fsv, a = a.tl, pa = a.tl, x = fsl, y = -300 },
    ['fst_uiparentscale'] = { t = ctrl.c.y .. 'uiParent scale:', fontFile = fft, fontSize = fst, a = a.tr, pa = a.tr, x = fsl, y = -350 },
    ['fsv_uiparentscale'] = { t = ctrl.c.g .. '--', fontFile = ffv, fontSize = fsv, a = a.tl, pa = a.tl, x = fsl, y = -350 },
}

local function ts()
    local gst = GetServerTime()
    return string.format('%s%s%s', c.r, date('%I:%M:%S', gst), c.d)
end
--[[
function ctrl.info:update()
    self.ux.c['fsv_servertime']:SetText(ts())
    self.ux.c['fsv_useuiscale']:SetText(GetCVar('useUiScale'))
    self.ux.c['fsv_uiscale']:SetText(GetCVar('uiScale'))
    local pw, ph = GetPhysicalScreenSize()
    self.ux.c['fsv_pscreenWidth']:SetText(math.floor(pw))
    self.ux.c['fsv_pscreenHeight']:SetText(math.floor(ph))
    self.ux.c['fsv_screenHeight']:SetText(math.floor(GetScreenHeight()))
    self.ux.c['fsv_screenWidth']:SetText(math.floor(GetScreenWidth()))
    local u = (math.floor(UIParent:GetScale() * 1000)) / 1000
    self.ux.c['fsv_uiparentscale']:SetText(tostring(u))
    self:redraw()
end

local function updateScale()
    local uis = UIParent:GetScale()
    local newScale = 1 - uis
    if newScale < 0.5 then newScale = 0.5 end
    ctrl.info.ux.f:SetScale(newScale)
end

function ctrl.info:resize()
    self.ux.f.r:SetSize(128, 128)
    self.ux.f.r.on:SetAllPoints(self.ux.f.r)
    self.ux.f.r.off:SetAllPoints(self.ux.f.r)
end

function ctrl.info:redraw()
    local list = { 'servertime', 'useuiscale', 'uiscale', 'pscreenHeight', 'pscreenWidth', 'screenHeight', 'screenWidth',
        'uiparentscale' }
    local cnt = 1
    for k, v in pairs(fontstrings) do
        local this = 0
        local name = strsub(k, 5)
        for kk, vv in ipairs(list) do
            if vv == name then this = kk end
        end

        if strsub(k, 1, 3) == 'fst' then
            self.ux.c[k]:ClearAllPoints()
            self.ux.c[k]:SetPoint(a.tr, self.ux.f, a.t, fsl - 8, -1 * (top + (this * (fs + spa))))
        elseif strsub(k, 1, 3) == 'fsv' then
            self.ux.c[k]:ClearAllPoints()
            self.ux.c[k]:SetPoint(a.tl, self.ux.f, a.t, fsl + 8, -1 * (top + (this * (fs + spa))) - 2)
        end
    end
end

local buttons = {
    ['bTest'] = {
        template = 'btn_smol',
        btnColor = { 0, 0, 1.0, 1 },
        h = 128,
        w = 196,
        anchors = { { a = a.br, pa = a.br, x = -16, y = 4 } }
    },
}

function ctrl.info:tick()
    self:update()
end

function ctrl.info.UI_SCALE_CHANGED()
    updateScale()
end


local msgTab = ctrl.newTable('')
msgTab[1] = c.y
msgTab[2] = ' '
msgTab[3] = ' cast '
msgTab[4] = c.o
msgTab[5] = ' '
msgTab[6] = ' on '
msgTab[7] = c.r
msgTab[8] = ' '

local function getBuffer(t)
    return table.concat(t, c.d)
end

function ctrl.info.SPELL_CAST_SUCCESS(evt)
    --
end
]]


function ctrl.space1999.setup(self)
    self.ux.f = ctrl.frame:new(self.options.frame, self)

    ctrl.tx:generate(textures, self)
    --ctrl.btns:generate(buttons, self)
    --ctrl.fs:generate(fontstrings, self)
end

ctrl.space1999:init()
