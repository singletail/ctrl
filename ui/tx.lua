--[[ ctrl - ui/tx.lua - t@wse.nyc - 8/14/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'tx',
    color = c.o,
    symbol = s.frame,
}

ctrl.tx = ctrl.mod:new(mod)

function ctrl.tx.new(module, o)
    o = o or {}
    if type(o.target) == 'string' then o.target = module.f[o.target] end
    if not o.target then o.target = UIParent end
    o.w = o.w or 0
    o.h = o.h or 0
    o.x = o.x or 0
    o.y = o.y or 0
    o.l = o.l or -8
    o.al = o.al or 1
    o.a = o.a or 'CENTER'
    o.pa = o.pa or 'CENTER'
    o.path = o.path or ctrl.p.tx
    o.lvl = o.lvl or 'ARTWORK'
    o.wrap = o.wrap or a.w.c
    o.filter = o.filter or 'TRILINEAR'
    if not o.anchors then o.anchors = {{ a = o.a, pa = o.pa, x = o.x, y = o.y }} end

    local tx = o.target:CreateTexture(nil, o.lvl, nil, o.l)
    print('=== texture: ' .. o.path , o.t)

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

function ctrl.tx.generate(module, textable, container)
    container = container or module.tx
    for k, v in pairs(textable) do
        if v.target == 'UIParent' then v.target = UIParent end
        if type(v.target) == 'string' then v.target = module.f[v.target] end
        container[k] = ctrl.tx.new(module, v)
    end
end