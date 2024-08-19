--[[ ctrl - ui/frame.lua - t@wse.nyc - 8/14/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

ctrl.frame = {
    name = 'frame',
    color = c.r,
    symbol = s.frame,
}

--ctrl.frame = ctrl.mod:new(mod)

local default = {
    class = 'Frame',
    target = UIParent,
    template = nil,
    globalName = nil,
    w = 128,
    h = 128,
    x = 0,
    y = 0,
    a = 'TOPLEFT',
    pa = 'TOPLEFT',
    strata = 'DIALOG',
    isMovable = nil,
    isResizable = nil,
    isClipsChildren = nil,
}

local scripts = {
    resize = {
        ['OnSizeChanged'] = function(self, w, h) self:resize(self, w, h) end,
    },
    move = {
        ['OnEnter'] = function(f) end,
        ['OnLeave'] = function(f) end,
        ['OnReceiveDrag'] = function(f) end,
        ['OnDragStart'] = function(f) f:StartMoving() end,
        ['OnDragStop'] = function(f) f:StopMovingOrSizing() end,
    },
    resizer = {
        ['OnEnter'] = function(f) end,
        ['OnLeave'] = function(f) end,
    },
    sizer = {
        ['OnMouseDown'] = function(f) f.parent:StartSizing() end,
        ['OnMouseUp'] = function(f) f.parent:StopMovingOrSizing() end,
        ['OnEnter'] = function(f) f.on:SetAlpha(1) end,
        ['OnLeave'] = function(f) f.on:SetAlpha(0) end,
    }
}

local function sizer(f)
    f.r = CreateFrame("Button", nil, f)
    f.r:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
    f.r:SetSize(16, 16)
    f.r.parent = f
    f.r.off = ctrl.tx:new( {target=f.r, t='drag_off', w=16, h=16, a='BOTTOMRIGHT', pa='BOTTOMRIGHT', x=-2, y=1, l=-5, path=ctrl.p.ux, al=0.5 })
    f.r.on  = ctrl.tx:new( {target=f.r, t='drag_on',  w=16, h=16, a='BOTTOMRIGHT', pa='BOTTOMRIGHT', x=-2, y=1, l=-5, path=ctrl.p.ux, al=0 })
    for e, fn in pairs(scripts.sizer) do f.r:SetScript(e, fn) end
    for e, fn in pairs(scripts.resizer) do f:SetScript(e, fn) end
end


function ctrl.frame.new(module, o)
    o = o or {}
    o.target = o.target or default.target
    o.globalName = o.globalName or nil
    o.class = o.class or default.class
    o.template = o.template or default.template
    o.w = o.w or default.w
    o.h = o.h or default.h
    o.x = o.x or default.x
    o.y = o.y or default.y
    o.a = o.a or default.a
    o.pa = o.pa or default.pa
    o.strata = o.strata or default.strata
    o.isMovable = o.isMovable or default.isMovable
    o.isResizable = o.isResizable or default.isResizable
    o.isClipsChildren = o.isClipsChildren or default.isClipsChildren
    if not o.anchors then o.anchors = {{ a = o.a, pa = o.pa, x = o.x, y = o.y }} end



    local f = CreateFrame(o.class, o.globalName, o.target, o.template)
    f:SetSize(o.w, o.h)
    for an = 1, #o.anchors do
        f:SetPoint(o.anchors[an].a, o.target, o.anchors[an].pa, o.anchors[an].x, o.anchors[an].y)
    end
    f:SetParent(o.target)
    f:SetFrameStrata(o.strata)
    f:SetClampedToScreen(true)
    if o.isClipsChildren then f:SetClipsChildren(true) end
    if o.isMovable then
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag('LeftButton')
        for e, fn in pairs(scripts.move) do f:SetScript(e, fn) end
    end
    if o.isResizable then
        f:EnableMouse(true)
        f:SetResizable(true)
        sizer(f)
        for e, fn in pairs(scripts.sizer) do f.r:SetScript(e, fn) end
        for e, fn in pairs(scripts.resizer) do f:SetScript(e, fn) end
    end
    local r = function(self, w, h)
        if module.resize then
            module:resize(self, w, h)
        end
    end
    f:SetScript('OnSizeChanged', r)
    return f
end

function ctrl.frame.generate(module, frametable, container)
    container = container or module.f
    for k, v in pairs(frametable) do
        if v.target == 'UIParent' then v.target = UIParent end
        if type(v.target) == 'string' then v.target = module.f[v.target] or module.btn[v.target] or UIParent end
        container[k] = ctrl.frame.new(module, v)
    end
end