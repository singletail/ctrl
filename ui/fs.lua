--[[ ctrl - ui/fs.lua - t@wse.nyc - 8/14/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'fs',
    color = c.r,
    symbol = s.frame,
}

ctrl.fs = ctrl.mod:new(mod)

local default = {
    fontFile = 'Prompt-Regular.ttf',
    fontSize = 12,
    fontFlags = '',
    a = 'LEFT',
    pa = 'LEFT',
    x = 0,
    y = 0,
    jH = 'LEFT',
    jV = 'MIDDLE',
    ww = false,
    fontPath = ctrl.p.fnt,
}

function ctrl.fs.new(module, o)
    o = o or {}


    if type(o.target) == 'string' then o.target = module.f[o.target] or module.btn[o.target] or module.f.main end
    o.x = o.x or 0
    o.y = o.y or 0
    o.a = o.a or default.a
    o.pa = o.pa or default.pa
    o.anchors = o.anchors or {{ a = o.a, pa = o.pa, x = o.x, y = o.y }}
    o.fontPath = o.fontPath or default.fontPath
    o.fontFile = o.fontFile or default.fontFile
    o.fontFile = o.fontPath .. o.fontFile
    o.fontSize = o.fontSize or default.fontSize
    o.fontFlags = o.fontFlags or default.fontFlags
    o.jH = o.jH or default.jH
    o.jV = o.jV or default.jV
    o.ww = o.ww or default.ww
    o.t = o.t or ''


    local fs = o.target:CreateFontString()
    fs:SetFont(o.fontFile, o.fontSize, o.fontFlags)
    fs:SetText(o.t)

    if tonumber(o.w) and tonumber(o.h) then fs:SetSize(o.w, o.h) end
    for an = 1, #o.anchors do
        fs:SetPoint(o.anchors[an].a, o.target, o.anchors[an].pa, o.anchors[an].x, o.anchors[an].y)
    end
    fs:SetTextColor(1, 1, 1, 1)
    fs:SetJustifyH(o.jH)
    fs:SetJustifyV(o.jV)

    --fs:SetWordWrap(o.ww)

    fs:SetText(o.t)
    return fs
end

function ctrl.fs.generate(module, tt, container)
    container = container or module.fs
    for k, v in pairs(tt) do
        if v.target == 'UIParent' then v.target = UIParent end
        if type(v.target) == 'string' then v.target = module.f[v.target] or module.btn[v.target] end
        container[k] = ctrl.fs.new(module, v)
    end
end