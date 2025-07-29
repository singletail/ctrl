--[[ ctrl - plates.lua - t@wse.nyc - 27 July 2025 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'plates',
    color = c.g,
    symbol = s.wipe,
    options = {
        events = {
            'NAME_PLATE_CREATED',
            'NAME_PLATE_UNIT_ADDED',
            'NAME_PLATE_UNIT_REMOVED',
        },
    },
}

ctrl.plates = ctrl.mod:new(mod)

local theme = {
    default = { w=0, h=0, x=0, y=0, a=a.tl, pa=a.tl, parent='base', alpha=1, scale=1, f='Prompt-Regular', fs=7, strata='BACKGROUND', layer='ARTWORK', level=0, fh=a.l, fv=a.t },
    path = {
        tx = [[Interface\AddOns\ctrl\assets\nameplate\]],
        font = [[Interface\AddOns\ctrl\assets\fnt\]],
    },
    f = {
        ['base'] = { w=160, h=24, a=a.c, pa=a.c, level=1 },
        ['health'] = { w=147, h=22, x=12, y=-1, level=2 },
        ['cast'] = { w=147, h=8, x=12, y=0, level=4 },
        ['top'] = { w=160, h=24, level=10 },
    },
    tx = {
        ['bk'] = { t='320_bk.png', level=-7, alpha=0.6 },
        ['cap'] = { t='320_cap_flat.png', h=24, w=12, level=-6, alpha=0.5 },
        ['health'] = { t='320_hbar_flat.png', target='health', level=-6, alpha=0.5 },
        ['shadow'] = { t='320_shadow.png', target='top', w=167, h=30, level=-5, alpha=0.6 },
        ['frame'] = { t='320_frame.png', target='top', level=-4, alpha=0.5 },
        ['glow'] = { t='320_glow.png', target='top', w=167, h=30, a=a.c, pa=a.c, level=-2, alpha=0.1 },
    },
    fs = {
        [1] = { fs=13, parent='top', x=-1, y=-1, w=24, h=24, fh=a.c, fv=a.m },
        [2] = { f='Prompt-Medium', fs=8, parent='top', w=120, h=7, x=20, y=-1 },
        [3] = { parent='top', w=100, h=7, x=20, y=-8 },
        [4] = { parent='top', w=60, h=7, x=20, y=-15 },
        [5] = { parent='top', h=7, w=26, x=-2, y=-1, a=a.tr, pa=a.tr, fh=a.r },
        [6] = { parent='top', h=7, w=40, x=-2, y=-8, a=a.tr, pa=a.tr, fh=a.r },
        [7] = { parent='top', h=7, w=80, x=-2, y=-15, a=a.tr, pa=a.tr, fh=a.r },
    },
}

local template = {
    f = {
        base = nil,
        top = nil,
    },
    bar = {
        health = nil,
        cast = nil,
    },
    tx = {},
    fs = {},
    fn = {},
    default = {
        is = {
            on = nil,
            player = nil,
            npc = nil,
        },
        unit = nil,
        guid = nil,
        npcId = nil,
        name = nil,
        data = {
            target = nil,
            aggro = nil,
            health = 0,
            healthMax = 1,
            healthPct = 100,
            spawnIndex = nil,
        },
        player = {
            pvpName = nil,
            class = nil,
            guildName = nil,
            guildRank = nil,
            ilvl = nil,
        },
        npc = {
            reaction = nil,
            classification = nil,
            creatureType = nil,
            creatureFamily = nil,
        },
        db = {
            icon = '',
            t1 = '',
            t2 = '',
        },
        color = {
            hex = '|cffffffff',
            rgba = { r=1, g=1, b=1, a=1 },
        },
    },
}

-- Events

function ctrl.plates.NAME_PLATE_CREATED(evt)
    ctrl.plates:debug('NAME_PLATE_CREATED', evt[1])
    ctrl.plates:attach(evt[1])
end

function ctrl.plates.NAME_PLATE_UNIT_ADDED(evt)
    ctrl.plates:debug('NAME_PLATE_UNIT_ADDED', evt[1])
    --local np = C_NamePlate.GetNamePlateForUnit(evt[1])
    --ctrl.plates:assign(np)
end

function ctrl.plates.NAME_PLATE_UNIT_REMOVED(evt)
    ctrl.plates:debug('NAME_PLATE_UNIT_REMOVED', evt[1])
    --local np = C_NamePlate.GetNamePlateForUnit(evt[1])
    --ctrl.plates:release(np)
end

function ctrl.plates:attach(nameplate)
    for i=1,40 do
        if not ctrl.np[i].nameplate then
            ctrl.np[i]:Attach(nameplate)
            return
        end
    end
end

function ctrl.plates:release(np)
    for i=1,40 do
        if ctrl.np[i].unit == np.unit then
            ctrl.np[i]:Reset()
            return
        end
    end
end

-- Functions

local function Attach(self, nameplate)
    ctrl.plates:debug('Attach', tostring(nameplate.unitToken), tostring(self.index))
    self.nameplate = nameplate
    --self.unit = unit
    --self.guid = UnitGUID(self.unit)
    --self.name = UnitName(self.unit) or 'Unknown'
    --local np = C_NamePlate.GetNamePlateForUnit(unit)
    self.f.base:ClearAllPoints()
    self.f.base:SetParent(nameplate)
    self.f.base:SetPoint(a.c, nameplate, a.c, 0, 0)
end

local function Reset(self)
    ctrl.plates:debug('Reset', tostring(self.unit), tostring(self.index))
    --ctrl.merge(self, self.default)
    --self:ClearAllPoints()
    --self:SetPoint(a.tl, UIParent, a.tl, 20, ((self.index-1) * -26)-100)
end

local function SetPoint(self, anc, tar, panc, x, y)
    self.f.base:SetPoint(anc, tar, panc, x, y)
end

-- Constructors

function ctrl.plates:opt(v)
    local opt = ctrl.cp(theme.default)
    ctrl.merge(opt, v)
    if not opt.anchors then opt.anchors = {{ a=opt.a, pa=opt.pa, x=opt.x, y=opt.y }} end
    return opt
end

function ctrl.plates:fAdd(np, k, v)
    local opt = self:opt(v)
    if type(opt.parent) == 'string' then opt.parent = np.f[opt.parent] or np.f.base or UIParent end
    np.f[k] = CreateFrame('Frame', nil, opt.parent)
    np.f[k]:SetFrameStrata(opt.strata)
    if opt.level then np.f[k]:SetFrameLevel(opt.level) end
    np.f[k]:SetSize(opt.w, opt.h)
    np.f[k]:SetParent(opt.parent)
    self:anchor(np.f[k], opt)
    np.f[k]:SetAlpha(opt.alpha or 1)
end

function ctrl.plates:txAdd(np, k, v)
    local opt = self:opt(v)
    if type(opt.parent) == 'string' then opt.parent = np.f[opt.parent] or np.f.base or UIParent end
    np.tx[k] = opt.parent:CreateTexture(nil, opt.layer, nil, opt.level)
    np.tx[k]:SetTexture(theme.path.tx..opt.t, a.w.c, a.w.c, 'TRILINEAR')
    np.tx[k]:SetParent(opt.parent)
    if opt.w>0 and opt.h>0 then np.tx[k]:SetSize(opt.w, opt.h); self:anchor(np.tx[k], opt) else
    np.tx[k]:SetSize(opt.parent:GetWidth(), opt.parent:GetHeight()); np.tx[k]:SetAllPoints(opt.parent) end
    np.tx[k]:SetAlpha(opt.alpha or 1)
end

function ctrl.plates:fsAdd(np, k, v)
    local opt = self:opt(v)
    if type(opt.parent) == 'string' then opt.parent = np.f[opt.parent] or np.f.base or UIParent end
    np.fs[k] = opt.parent:CreateFontString()
    np.fs[k]:SetParent(opt.parent)
    np.fs[k]:SetFontObject(ctrl.font(opt.f, opt.fs, ''))
    np.fs[k]:SetJustifyH(opt.fh); np.fs[k]:SetJustifyV(opt.fv)
    if opt.w > 0 and opt.h > 0 then np.fs[k]:SetSize(opt.w, opt.h) end
    self:anchor(np.fs[k], opt)
end

function ctrl.plates:anchor(e, opt)
    for n = 1, #opt.anchors do e:SetPoint(opt.anchors[n].a, opt.parent, opt.anchors[n].pa, opt.anchors[n].x, opt.anchors[n].y) end
end

function ctrl.plates:fn(np)
    np.SetPoint = SetPoint
    np.Reset = Reset
    np.Attach = Attach
end

function ctrl.plates:build(np)
    self:fAdd(np, 'base', theme.f.base)
    for k,v in pairs(theme.f) do if k ~= 'base' then self:fAdd(np, k, v) end end
    for k,v in pairs(theme.tx) do self:txAdd(np, k, v) end
    for k,v in pairs(theme.fs) do self:fsAdd(np, k, v) end
    self:fn(np)
end

function ctrl.plates:new(i)
    local np = ctrl.cp(template)
    np.index = i
    ctrl.merge(np, np.default)
    self:build(np)
    return np
end

function ctrl.plates:test(i)
    local np = ctrl.np[i]
    if not np then self:error('error: np ' .. tostring(i) .. ' not found.'); return end
    np:SetPoint(a.tl, UIParent, a.tl, 20, ((i-1) * -26)-100)
    for k, v in pairs(np.fs) do v:SetText(tostring(k)..' '..i) end
end

function ctrl.plates:generate()
    ctrl.np = ctrl.np or {}
    for i=1,40 do
        ctrl.np[i] = ctrl.np[i] or self:new(i)
        self:test(i)
    end
end

function ctrl.plates:setup()
    self:generate()
end

ctrl.plates:init()
