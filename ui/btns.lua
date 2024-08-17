--[[ ctrl - ui/btns.lua - t@wse.nyc - 8/14/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'btns',
    color = c.r,
    symbol = s.frame,
}

ctrl.btns = ctrl.mod:new(mod)

local default = {
    class = 'Button',
    subclass = 'SPST',
    path = ctrl.p.btns,
    strata = 'DIALOG',
    w = 25.6,
    h = 25.6,
    anchors = {
        { a = 'CENTER', pa = 'TOPLEFT', x = 0, y = 0 }
    },
    t = {},
    l = {},
}

local function mouseUp(self, btn, ...)
    if self.enabled == 1 then
        if self.info.subclass == 'SPST' then
            self:showValue(1)
            self.module:click(self, self.info)
        elseif self.info.subclass ~= 'LIGHT' then
            self.module:click(self, self.info)
        else
            ctrl.log(ctrl, 5, 'Warning: button subclass not found: ', self.info.subclass)
        end
    end
    --[[ctrl.log(ctrl, 8,
        ctrl.c.b .. 'button ' .. tostring(btn.name) .. ' enabled:' ..
        tostring(btn.enabled) .. ' value:' .. tostring(btn.value))]]
    self:refresh(btn)
end

local function mouseDown(self)
    if self.enabled == 1 then
        if self.info.subclass == 'NC' or self.info.subclass == 'SPST' then
            self:showValue(0)
        elseif self.info.subclass ~= 'LIGHT' then
            self:showValue(1)
        end
    end
end

local function btnTexture(f, set)
    set.level = set.level or 'ARTWORK'
    set.wrap = set.wrap or 'CLAMPTOBLACKADDITIVE'
    set.filter = set.filter or 'LINEAR'
    set.alphaMode = set.alphaMode or 'BLEND'
    local tex = f:CreateTexture(nil, set.level, nil, set.layer)
    tex:SetBlendMode(set.alphaMode)
    tex:SetTexture(set.path .. set.file, set.wrap, set.wrap, set.filter)
    tex:SetSize(f:GetWidth(true), f:GetHeight(true))
    tex:SetAllPoints(f)
    return tex
end

local function showValue(self, value)
    value = value or self.value
    for i = 1, #self.info.values do
        local intval = self.info.values[i]
        for j = 1, #self.t.v[intval] do
            if intval == value then
                self.t.v[intval][j]:SetAlpha(self.p.v[value][j])
            else
                self.t.v[intval][j]:SetAlpha(0)
            end
        end
    end
end

local function setValue(self, value)
    if value == nil or value == false then value = 0 end
    if value == true then value = 1 end
    self.value = value
    self:showValue(self.value)
end

local function getValue(self)
    return self.value
end

local function getValueNil(self)
    if self.value == 0 then
        return nil
    else
        return self.value
    end
end

local function setEnabled(self, enabled)
    if enabled == nil or enabled == false then
        enabled = 0
    elseif enabled == true then
        enabled = 1
    end
    self.enabled = enabled
    if self.p.e then
        for i = 1, #self.p.e do
            local ax = 0
            if i == enabled then ax = 1 end
            for j = 1, #self.p.e[i] do
                self.t.e[i][j]:SetAlpha(self.p.e[i][j] * ax)
            end
        end
    end
end

local function getEnabled(self)
    return self.enabled
end

local function getEnabledNil(self)
    if self.enabled == 1 then
        return 1
    else
        return nil
    end
end

local function setColor(self, r, g, b, alpha)
    self.btnColor = { r, g, b, alpha }
    for i = 1, #self.c do
        self.c[i]:SetVertexColor(r, g, b, alpha)
    end
end

local function refresh(self)
    self:setEnabled(self.enabled)
    self:showValue(self.value)
end

local function _on(self)
    self:setValue(1)
    self:refresh()
end

local function _off(self)
    self:setValue(0)
    self:refresh()
end

local function _toggle(self)
    self:setValue(abs(self.value - 1))
    self:refresh()
end

function ctrl.btns.new(module, o)
    o = o or {}
    if o.template then ctrl.template:loadTemplateItem('btn', o) end

    --local meta = { __index = self }
    --setmetatable(o, meta)
    --setmetatable(self, { __index = ctrl.ux })

    local btn = CreateFrame('Frame', nil, o.target)
    btn:SetFrameStrata('DIALOG')
    btn:SetSize(o.w, o.h)
    for an = 1, #o.anchors do
        btn:SetPoint(o.anchors[an].a, o.target, o.anchors[an].pa, o.anchors[an].x, o.anchors[an].y)
    end
    btn:SetClipsChildren(false)
    btn:EnableMouse(true)

    btn.name = o.name
    btn.module = module
    btn.info = o
    btn.btnColor = o.btnColor or { 1.0, 1.0, 0.7, 1.0 }
    btn.ts = {}                         -- temp holding texture info
    btn.t = { s = {}, e = {}, v = {}, } --textures - static / enabled / value
    btn.p = { e = {}, v = {}, }         --alpha for those textures
    btn.c = {}                          -- textures that need SetVertexColor

    btn.on = _on
    btn.off = _off
    btn.toggle = _toggle

    if o.texture.static then
        for i = 1, #o.texture.static do
            btn.t.s[i] = btnTexture(btn, o.texture.static[i])
            if o.texture.static[i].color then btn.c[#btn.c + 1] = btn.t.s[i] end
        end
    end

    if o.texture.enabled then
        for i = 0, 1 do
            for j = 1, #o.texture.enabled[i] do
                btn.t.e[i] = btn.t.e[i] or {}
                btn.t.e[i][j] = btnTexture(btn, o.texture.enabled[i][j])
                btn.p.e[i] = btn.p.e[i] or {}
                btn.p.e[i][j] = o.texture.enabled[i][j].alpha
                if o.texture.enabled[i][j].color then btn.c[#btn.c + 1] = btn.t.e[i][j] end
            end
        end
    end

    if o.texture.value then
        for i = 1, #o.values do
            local value = o.values[i]
            if o.texture.value[value] then
                local textureset = o.texture.value[value]
                for j = 1, #o.texture.value[value] do
                    btn.t.v[value] = btn.t.v[value] or {}
                    btn.t.v[value][j] = btnTexture(btn, o.texture.value[value][j])
                    btn.p.v[value] = btn.p.v[value] or {}
                    btn.p.v[value][j] = o.texture.value[value][j].alpha
                    if o.texture.value[value][j].color then btn.c[#btn.c + 1] = btn.t.v[value][j] end
                end
            end
        end
    end

    btn.setEnabled = setEnabled
    btn.getEnabled = getEnabled
    btn.getEnabledNil = getEnabledNil
    btn.setValue = setValue
    btn.getValue = getValue
    btn.getValueNil = getValueNil

    btn.showValue = showValue
    btn.refresh = refresh
    btn.refreshButton = refresh
    btn.setColor = setColor
    btn.mouseUp = mouseUp
    btn.mouseDown = mouseDown

    btn.enabled = 1
    btn.value = 1
    btn:setColor(btn.btnColor[1], btn.btnColor[2], btn.btnColor[3], btn.btnColor[4])

    local scripts = {
        ["OnMouseDown"] = function(bt, ...) bt:mouseDown(bt, ...) end,
        ["OnMouseUp"] = function(bt, ...) bt:mouseUp(bt, ...) end,
    }
    for func, script in pairs(scripts) do
        btn:SetScript(func, script)
    end

    btn:refresh()
    return btn
end

function ctrl.btns.generate(module, btntable, container)
    container = container or module.btn
    for k, v in pairs(btntable) do
        v.name = v.name or k
        if v.target == 'UIParent' then v.target = UIParent end
        print('*** btns generate ', v.name, v.target)
        if type(v.target) == 'string' then v.target = module.f[v.target] end
        container[k] = ctrl.btns.new(module, v)
    end
end
