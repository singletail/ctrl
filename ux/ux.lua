--[[ ctrl - ux.lua - t@wse.nyc - 7/24/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local function _resize(self, f, w, h)
    if ctrl[self.mod].resize then ctrl[self.mod]:resize(f, w, h) end
end

local function _redraw(self, f)
    if ctrl[self.mod].redraw then ctrl[self.mod]:redraw(f) end
end

local function _hide(self)
    if self.class == 'frame' or self.class == 'subframe' or self.class == 'button' then
        self:Hide()
    else
        self:SetAlpha(0)
    end
end

local function _show(self)
    if self.class == 'frame' or self.class == 'subframe' or self.class == 'button' then
        self:Show()
    else
        self:SetAlpha(self.alpha)
    end
end

local function _getTx(f, t)
    local file, w, h, anchor, pa, x, y, l, path, alpha = unpack(t)
    path = path or ctrl.p.tx
    alpha = alpha or 1
    local tx = f:CreateTexture(nil, 'BACKGROUND', nil, l)
    tx:SetTexture(path .. file, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE', 'TRILINEAR')
    tx:SetSize(w, h)
    tx:SetPoint(anchor, f, pa, x, y)
    tx:SetAlpha(alpha)
    return tx
end

-- Superclass

ctrl.ux = {
    name = 'ux',
    color = ctrl.c.o,
    symbol = ctrl.s.ux,
    class = 'class',
    subclass = 'super',
    enabled = 1,
    c = {},

    w = 0,
    h = 0,
    x = 0,
    y = 0,
    a = 'TOPLEFT',
    pa = 'TOPLEFT',

    redraw = _redraw,
    resize = _resize,
    show = _show,
    hide = _hide,
    getTx = _getTx,
}

function ctrl.ux:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

--[[
local function off(self)
    for name, element in pairs(c) do
        if element.class == 'Fontstring' then
            element:SetText('')
        elseif element.class == 'Button' then
            if name ~= 'power' then
                element.enabled = nil
                element:refreshButton()
            end
        end
    end
    self.f:SetAlpha(0.5)
end

local function on(self)
    for name, element in pairs(c) do
        if element.class == 'Button' then
            element.enabled = 1
            element:refreshButton()
        end
    end
    self.f:SetAlpha(1)
end
]]

function ctrl.ux:generate(mod, template)
    if not mod.name then
        error('Bad argument')
        return
    end
    local ux = {}
    ux.c = {}
    local t
    t = t or 'simple'
    if type(template) == 'string' then
        t = ctrl.template:get(template)
    elseif type(template) == 'table' then
        t = template
    end
    ux.f = ctrl.frame:new(t.frame, mod)
    if t.subframes then ctrl.frame:generate(t.subframes, mod, ux) end
    if t.textures then ctrl.texture:generate(t.textures, mod, ux) end
    if t.buttons then ctrl.buttons:generate(t.buttons, mod, ux) end
    if t.fontstrings then ctrl.fontstring:generate(t.fontstrings, mod, ux) end
    --ux.off = off
    --ux.on = on
    return ux
end
