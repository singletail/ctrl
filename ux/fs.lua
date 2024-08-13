--[[ ctrl - fs.lua - t@wse.nyc - 9/1/22 ]] --

---@class ctrl
local ctrl = select(2, ...)

local C, c, s = ctrl, ctrl.c, ctrl.s

ctrl.fs = {
    name = 'fs',
    color = ctrl.c.w,
    symbol = ctrl.s.fs,
    class = 'Fontstring',
    subclass = '',
    t = 'text',
    font = 'regular',
    fontFlags = '',
    a = 'CENTER',
    pa = 'CENTER',
    jH = 'CENTER',
    jV = 'MIDDLE',
    ww = false,
}

function ctrl.fs:new(o)
    o = o or {}
    local meta = { __index = self }
    setmetatable(o, meta)
    setmetatable(self, { __index = ctrl.ux })

    o.anchors = o.anchors or {{ a = o.a, pa = o.pa, x = o.x, y = o.y }}
    o.fontFile = o.fontFile or 'Prompt-Regular.ttf'
    o.fontFile = ctrl.p.fnt .. o.fontFile
    o.fontSize = o.fontSize or 12
    o.fontFlags = o.fontFlags or ''

    local fs = o.target:CreateFontString()
    fs:SetFont(o.fontFile, o.fontSize, o.fontFlags)
    

    if o.w and o.h then fs:SetSize(o.w, o.h) end

    for an = 1, #o.anchors do
        fs:SetPoint(o.anchors[an].a, o.target, o.anchors[an].pa, o.anchors[an].x, o.anchors[an].y)
    end

    fs:SetTextColor(1, 1, 1, 1)
    fs:SetJustifyH(o.jH)
    fs:SetJustifyV(o.jV)
    fs:SetWordWrap(o.ww)
    fs:SetText(o.t)

    fs.name = o.n
    fs.info = o
    if o.target.info.class == 'Button' then o.target.fs = fs end

    return fs
end

function ctrl.fs:generate(tt, mod, ux)
    ux = ux or mod.ux
    for k, v in pairs(tt) do
        v.name = v.name or k
        if v.target == 'UIParent' then v.target = UIParent end
        if type(v.target) == 'string' then
            v.target = ux.c[v.target]
        end
        if not v.target then v.target = ux.f end
        ux.c[k] = ctrl.fs:new(v, mod)
    end
end
