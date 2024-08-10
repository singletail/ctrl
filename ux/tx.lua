--[[ ctrl - tx.lua - t@wse.nyc - 7/21/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

ctrl.tx = {
    name = 'tx',
    color = ctrl.c.o,
    symbol = ctrl.s.tx,
    class = 'Texture',
    subclass = '',
    t = 'dolby',
    w = 0,
    h = 0,
    x = 0,
    y = 0,
    l = -8,
    al = 1,
    a = 'CENTER',
    pa = 'CENTER',
    path = ctrl.p.tx,
    lvl = 'ARTWORK',
    wrap = 'CLAMPTOBLACKADDITIVE',
    filter = 'TRILINEAR',
}

function ctrl.tx:new(o, mod)
    o = o or {}
    local meta = { __index = self }
    setmetatable(o, meta)
    setmetatable(self, { __index = ctrl.ux })
    o.target = o.target or UIParent
    if not o.anchors then
        o.anchors = {}
        o.anchors[1] = { a = o.a, pa = o.pa, x = o.x, y = o.y }
    end

    local tx = o.target:CreateTexture(nil, o.lvl, nil, o.l)
    tx:SetTexture(o.path .. o.t, o.wrap, o.wrap, o.filter)
    if o.w == 0 then
        tx:SetSize(o.target:GetWidth(true), o.target:GetHeight(true))
        tx:SetAllPoints(o.target)
    else
        tx:SetSize(o.w, o.h)
        for an = 1, #o.anchors do
            tx:SetPoint(o.anchors[an].a, o.target, o.anchors[an].pa, o.anchors[an].x, o.anchors[an].y)
        end
    end
    tx:SetAlpha(o.al)
    return tx
end

function ctrl.tx:generate(tt, mod, ux)
    ux = ux or mod.ux
    for k, v in pairs(tt) do
        v.name = v.name or k
        if v.target == 'UIParent' then v.target = UIParent end
        if type(v.target) == 'string' then v.target = ux.c[v.target] end
        if not v.target then v.target = ux.f end
        ux.c[k] = ctrl.tx:new(v, mod)
    end
end
