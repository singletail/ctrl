--[[ ctrl - frame.lua - t@wse.nyc - 7/24/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

ctrl.frame = {
    name = "frame",
    class = 'Frame',
    subclass = 'Frame',
    globalName = nil,
    w = 128,
    h = 128,
    x = 0,
    y = 0,
    a = 'TOPLEFT',
    pa = 'TOPLEFT',
    strata = 'DIALOG',
    isMovable = 0,
    isResizable = 0,
    isClipsChildren = 0,
}

ctrl.frame.scripts = {
    resize = {
        ['OnSizeChanged'] = function(self, w, h) self.mod:resize(self, w, h) end,
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

function ctrl.frame:gettx(f, t)
    local file, w, h, anchor, pa, x, y, l, path, alpha = unpack(t)
    path = path or ctrl.p.tx
    alpha = alpha or 1
    local tx = f:CreateTexture(nil, 'ARTWORK', nil, l)
    tx:SetTexture(path .. file, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE', 'TRILINEAR')
    if w == 0 or w == nil then
        tx:SetSize(f:GetWidth(), f:GetHeight())
        tx:SetAllPoints(f)
    else
        tx:SetSize(w, h)
        tx:SetPoint(anchor, f, pa, x, y)
    end
    tx:SetAlpha(alpha)
    return tx
end

function ctrl.frame:sizer(f, o)
    f.r = CreateFrame("Button", nil, f)
    f.r:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
    f.r:SetSize(16, 16)
    f.r.parent = f
    f.r.off = self:gettx(f.r, { 'drag_off', 16, 16, 'BOTTOMRIGHT', 'BOTTOMRIGHT', -2, 1, -5, ctrl.p.ux, 0.5 })
    f.r.on = self:gettx(f.r, { 'drag_on', 16, 16, 'BOTTOMRIGHT', 'BOTTOMRIGHT', -2, 1, -4, ctrl.p.ux, 0 })
    for e, fn in pairs(ctrl.frame.scripts.sizer) do f.r:SetScript(e, fn) end
    for e, fn in pairs(ctrl.frame.scripts.resizer) do f:SetScript(e, fn) end
end

function ctrl.frame:new(o, mod)
    o = o or {}
    local meta = { __index = self }
    setmetatable(o, meta)
    setmetatable(self, { __index = ctrl.ux })

    o.target = o.target or UIParent

    if not o.anchors then
        o.anchors = {}
        o.anchors[1] = { a = o.a, pa = o.pa, x = o.x, y = o.y }
    end

    local f = CreateFrame(o.subclass, o.globalName, o.target)
    f:SetFrameStrata(o.strata)
    f:SetSize(o.w, o.h)

    for an = 1, #o.anchors do
        f:SetPoint(o.anchors[an].a, o.target, o.anchors[an].pa, o.anchors[an].x, o.anchors[an].y)
    end

    o.mod = mod
    f.mod = mod
    f.name = o.name .. '.f'

    if o.target == UIParent then
        f:SetToplevel(true)

        if o.isMovable == 1 then
            f:EnableMouse(true)
            f:SetMovable(true)
            f:RegisterForDrag('LeftButton')
            for e, fn in pairs(ctrl.frame.scripts.move) do f:SetScript(e, fn) end
        end
        if o.isResizable == 1 then
            f:EnableMouse(true)
            f:SetResizable(true)
            self:sizer(f, o)
        end
        if o.isClipsChildren == 1 then f:SetClipsChildren(true) end
        f:SetClampedToScreen(true)
        for e, fn in pairs(ctrl.frame.scripts.resize) do f:SetScript(e, fn) end
    end

    f.info = o
    return f
end

function ctrl.frame:generate(subframetable, mod, ux)
    ux = ux or mod.ux
    for k, v in pairs(subframetable) do
        v.name = v.name or k
        if v.target == 'UIParent' then v.target = UIParent end
        if type(v.target) == 'string' then v.target = ux.c[v.target] end
        if not v.target then v.target = ux.f end
        ux.c[k] = ctrl.frame:new(v, mod)
    end
end

function ctrl.frame:secure(...)
    local mod, p, w, h, x, y, isMovable, isResizable = ...
    if mod == nil then
        self:debug('mod is nil!')
        return nil
    end
    p = p or UIParent
    w = w or 128
    h = h or 64
    x = x or 0
    y = y or 0
    isMovable = isMovable or 1
    isResizable = isResizable or 1
    local f = CreateFrame("Frame", nil, p, 'SecureFrameTemplate')
    f:SetPoint('TOPLEFT', p, 'TOPLEFT', x, y)
    f:SetSize(w, h)
    f:SetToplevel(true)
    f:EnableMouse(true)
    f:SetClipsChildren(true)
    f:SetClampedToScreen(true)
    f.mod = mod
    if isMovable then
        f:SetMovable(true)
        f:RegisterForDrag('LeftButton')
        for e, fn in pairs(self.scripts.move) do f:SetScript(e, fn) end
    end
    if isResizable then
        f:SetResizable(true)
        self:sizer(f, {})
        for e, fn in pairs(self.scripts.resize) do f:SetScript(e, fn) end
        for e, fn in pairs(self.scripts.sizer) do f.r:SetScript(e, fn) end
        for e, fn in pairs(self.scripts.resizer) do f:SetScript(e, fn) end
    end
    return f
end
