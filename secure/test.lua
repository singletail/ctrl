--[[ ctrl - secure/frame.lua - t@wse.nyc - 8/18/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

ctrl.secure = ctrl.secure or {}

local default = {
    f = {
        class = 'Frame',
        parent = UIParent,
        template = 'SecureFrameTemplate',
        globalName = nil,
        w = 256,
        h = 256,
        x = 0,
        y = -0,
        a = 'TOPLEFT',
        pa = 'TOPLEFT',
        strata = 'BACKGROUND',
        isMovable = 1,
        isResizable = 1,
        isClipsChildren = nil,
        isClampedToScreen = true,
    },
    tx = {
        name = nil,
        drawLayer = 'ARTWORK',
        templateName = nil,
        subLevel = -7,
        filter = 'TRILINEAR',
        wrap = 'CLAMPTOBLACKADDITIVE',
        path = [[Interface\AddOns\ctrl\assets\tx\]],
        t = 'checkengine40',
        alpha = 1,
        x=0,
        y=0,
        w=nil,
        h=nil,
        a='CENTER',
        pa='CENTER',
    },
    btn = {
        name = nil,
        class = 'Button',
        w = 128,
        h = 128,
        templateName = 'SecureActionButtonTemplate',
        a = 'TOPLEFT',
        pa = 'TOPLEFT',
        x = 0,
        y = 0,
    },
}

local function resize(self, w, h)
    local fw = self:GetWidth()
    local fh = self:GetHeight()
    if fw < 36 then self:SetWidth(36) end
    if fh < 36 then self:SetHeight(36) end
end

local scripts = {
    resize = {
        ['OnSizeChanged'] = function(self, w, h) resize(self, w, h) end,
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

local function securetexture(o)
    o = o or {}
    for k, v in pairs(default.tx) do o[k] = o[k] or v end
    local tx = o.f:CreateTexture(o.name, o.drawLayer, o.templateName, o.subLevel)
    tx:SetTexture(o.path..o.t, o.wrap, o.wrap, o.filter)
    if tonumber(o.w) and tonumber(o.h) then
        tx:SetSize(o.w, o.h)
        tx:SetPoint(o.a, o.f, o.pa, o.x, o.y)
    else
        tx:SetSize(o.f:GetWidth(), o.f:GetHeight())
        tx:SetAllPoints(o.f)
    end
    tx:SetAlpha(o.alpha)
    return tx
end

local function securesizer(f)
    local b = CreateFrame("Button", nil, f)
    b:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
    b:SetSize(16, 16)
    b.parent = f
    b.off = securetexture({f=b, t='drag_off', alpha=0.5 })
    b.on = securetexture({f=b, t='drag_on', alpha=0 })
    for e, fn in pairs(scripts.sizer) do b:SetScript(e, fn) end
    for e, fn in pairs(scripts.resizer) do f:SetScript(e, fn) end
    return b
end

local function secureframe(o)
    o = o or {}
    for k, v in pairs(default.f) do o[k] = o[k] or v end
    local f = CreateFrame(o.class, o.globalName, o.parent, o.template)
    f:SetPoint(o.a, o.parent, o.pa, o.x, o.y)
    f:SetSize(o.w, o.h)
    f:SetFrameStrata(o.strata)
    --f:SetClipsChildren(o.isClipsChildren)
    f:SetClampedToScreen(o.isClampedToScreen)
    if parent == UIParent then f:SetToplevel(true) end
    if o.isMovable then
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag('LeftButton')
        for e, fn in pairs(scripts.move) do f:SetScript(e, fn) end
    end
    if o.isResizable then
        f:EnableMouse(true)
        f:SetResizable(true)
        f.sizer = securesizer(f)
        for e, fn in pairs(scripts.resize) do f:SetScript(e, fn) end
    end
    return f
end

local function securebutton(o)
    o = o or {}
    for k, v in pairs(default.btn) do o[k] = o[k] or v end
    local btn = CreateFrame('Button', n, f, 'SecureActionButtonTemplate')
    btn:SetSize(o.w, o.h)
    btn:SetPoint(o.a, o.f, o.pa, o.x, o.y)
    btn:RegisterForClicks('AnyDown')
    return btn
end

local pre = [[
    local s = self:GetAttribute('s')
    local t = newtable(strsplit('|', s))
    local m = '/focus target\n/cleartarget\n'
    for i = 1, #t do
        m = m .. '/target ' .. t[i] .. '\n'
    end
    m = m .. '/cast [exists,nodead,harm] Disrupt\n/target focus\n/clearfocus\n/startattack'
    self:SetAttribute('macrotext', m)
]]


local pre2 = [[
    local a = self:GetAttribute('a')
    local s = self:GetAttribute('s')
    local i = self:GetAttribute('i')
    local t = newtable(strsplit('|', s))
    local m = a .. t[i]
    self:SetAttribute('macrotext', m)
    i = i + 1
    if i >= #t then i = 1 end
    self:SetAttribute('i', i)
]]

local function configureSecureButton2(btn)
    btn:SetAttribute('a', '/targetenemy [harm][nodead]\n/startattack\n/cast ')
    btn:SetAttribute('s', 'Overpower|Mortal Strike|Slam')
    btn:SetAttribute('i', 1)
    btn:SetAttribute('type', 'macro')
    btn:SetAttribute('macrotext', '/targetenemy')
end

function compileSecureBtn2(btn, f)
    SecureHandlerWrapScript(btn, 'OnClick', f, pre2)
    SetOverrideBindingClick(btn, true, 'Y', 'CtrlSecureBtnTest2')
end



local function configureSecureButton(btn)
    btn:SetAttribute('s', 'Cursedforge Stoneshaper|Void Bound Howler|Cursedheart Invader|Turned Speaker|Ghastly Voidsoul|Forgebound Mender|Cursedforge Mender|Speaker Brokk|Molten Hound|Blazing Fireguard|Dark Iron Primalist')
    btn:SetAttribute('type', 'macro')
    btn:SetAttribute('macrotext', '/targetenemy')
end

function compileSecureBtn(btn, f)
    SecureHandlerWrapScript(btn, 'OnClick', f, pre)
    SetOverrideBindingClick(btn, true, 'Z', 'CtrlSecureBtnTest')
end

function ctrl.secure.setup()
    local f = secureframe({globalName='ctrlsecure',w=256,h=167})
    f.tx = securetexture({f=f,t='screen_384',path=[[Interface\AddOns\ctrl\assets\1999\]]})
    f.btn = securebutton({f=f,globalName='CtrlSecureBtnTest',w=128,h=128,a='CENTER',pa='CENTER'})
    f.btn.tx = securetexture({f=f.btn,w=128,h=128})
    configureSecureButton(f.btn)
    configureSecureButton2(f.btn2)
    compileSecureBtn(f.btn, f)
    compileSecureBtn2(f.btn2, f)
end

