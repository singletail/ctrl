--[[ ctrl - plates.lua - t@wse.nyc - 27 July 2025 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'plates',
    color = c.g,
    symbol = s.wipe,
    options = {
        width = 192,
        height = 48,
        events = {
            'NAME_PLATE_CREATED',
            'NAME_PLATE_UNIT_ADDED',
            'NAME_PLATE_UNIT_REMOVED',
            'UNIT_HEALTH',
        },
        debug = {
            showClickableArea = nil,
        }
    },
}

ctrl.plates = ctrl.mod:new(mod)

local default = {
    f = {},
    tx = {},
    fs = {},
    guid = nil,
    unit = nil,
    unitName = nil,
    color = { 1, 1, 1, 1 },
}

local classColor = {
    DEATHKNIGHT = { 0.38, 0.06, 0.11, 1, },
    DEMONHUNTER = { 0.32, 0.9, 0.4, 1, },
    DRUID = { 0.5, 0.25, 0.02, 1, },
    HUNTER = { 0.33, 0.41, 0.22, 1, },
    MAGE = { 0.2, 0.4, 0.46, 1, },
    MONK = { 0.0, 0.5, 0.28, 1, },
    PALADIN = { 0.46, 0.27, 0.36, 1, },
    PRIEST = { 0.5, 0.5, 0.5, 1, },
    ROGUE = { 0.5, 0.48, 0.2, 1, },
    SHAMAN = { 0.0, 0.22, 0.43, 1, },
    WARLOCK = { 0.27, 0.25, 0.4, 1, },
    WARRIOR = { 0.39, 0.3, 0.21, 1, },
}

function ctrl.plates:configure(unit)
    local namePlateFrame = C_NamePlate.GetNamePlateForUnit(unit)
    local nameplate = namePlateFrame and namePlateFrame.nameplate
    if not nameplate then return end

    nameplate.unit = unit
    nameplate.guid = UnitGUID(unit)
    nameplate.unitName = UnitName(unit) or 'Unknown'
    nameplate.class = select(2, UnitClass(unit))
    nameplate.color = classColor[nameplate.class] or { 1, 1, 1, 1 }

    --temporary
    nameplate.fs.fs1:SetText(nameplate.unitName or '')
    nameplate.fs.fs2:SetText(nameplate.guid or '')
    nameplate.fs.fs3:SetText('Hi there.')
    nameplate.fs.fs4:SetText('-')
    nameplate.fs.fs5:SetText('-')
    nameplate.fs.fs6:SetText('-')

    namePlateFrame.UnitFrame.HealthBarsContainer.healthBar:SetAlpha(0)
    namePlateFrame.UnitFrame.HealthBarsContainer.border:SetAlpha(0)
    namePlateFrame.UnitFrame.HealthBarsContainer.background:SetAlpha(0)
    namePlateFrame.UnitFrame.name:SetAlpha(0)

    nameplate:updateHealth()
    nameplate:setColor()

    nameplate.f.main:Show()
end

local function updateHealth(self)
    if not self.unit then return end
    local h = UnitHealth(self.unit) or 0
    local mh = UnitHealthMax(self.unit) or 1
    local p = math.floor((h / mh) * 100)
    self.f.hp:SetWidth(1.68 * p)
    self.fs.fs4:SetText(string.format('%d%%', p))
    self.fs.fs5:SetText(string.format('%.1fm/%.1fm', h / 1000000, mh / 1000000))
end

local function setColor(self)
    self.tx.cap:SetVertexColor(self.color[1], self.color[2], self.color[3], self.color[4])
    self.tx.hp:SetVertexColor(self.color[1], self.color[2], self.color[3], self.color[4])
end

function ctrl.plates:reset(unit)
    local unitFrame = C_NamePlate.GetNamePlateForUnit(unit)
    local nameplate = unitFrame and unitFrame.nameplate
    if not nameplate then return end
    nameplate.unit = nil
    nameplate.guid = nil
    nameplate.unitName = nil
    nameplate.fs.icon:SetText('')
    nameplate.fs.fs1:SetText('')
    nameplate.fs.fs2:SetText('')
    nameplate.fs.fs3:SetText('')
    nameplate.f.main:Hide()
end

function ctrl.plates.NAME_PLATE_CREATED(evt)
    local namePlateFrame = evt[1]
    ctrl.plates:debug('NAME_PLATE_CREATED', namePlateFrame)
    if ctrl.plates.options.debug.showClickableArea then
        local tex = namePlateFrame:CreateTexture(nil, "OVERLAY")
        tex:SetAllPoints(namePlateFrame)
        tex:SetColorTexture(1, 0, 0, 0.5)
    end
    ctrl.plates:create(namePlateFrame)
end

function ctrl.plates.NAME_PLATE_UNIT_ADDED(evt)
    local unit = evt[1] or ''
    if not unit or unit == '' then return end
    ctrl.plates:debug('NAME_PLATE_UNIT_ADDED', unit)
    ctrl.plates:configure(unit)
end

function ctrl.plates.NAME_PLATE_UNIT_REMOVED(evt)
    local unit = evt[1] or ''
    if not unit or unit == '' then return end
    ctrl.plates:debug('NAME_PLATE_UNIT_REMOVED', unit)
    ctrl.plates:reset(unit)
end

function ctrl.plates.UNIT_HEALTH(evt)
    local unit = evt[1] or ''
    if not unit or unit == '' then return end
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
    if not nameplate or not nameplate.nameplate then return end
    C_NamePlate.GetNamePlateForUnit(unit).nameplate:updateHealth()
end

local frames = {
    ['hp'] = { target='main', w=168, h=34, x=24, y=-2, a=a.tl, pa=a.tl },
    ['top'] = { target='main', w=192, h=48, x=0, y=0, a=a.tl, pa=a.tl },
}

local textures = {
    ['bk'] = { t='bk_cut.png', l=-7, al=1 },
    ['cap'] = { t='cap64_cut.png', h=49, w=24, a=a.tl, pa=a.tl, x=0, y=0, l=-6, al=1 },
    ['hp'] = { t='box.png', target='hp', l=-6, al=1 },
    ['shad'] = { t='shadow.png', target='top', x=-4, y=0, l=-5, al=1 },
    ['frame'] = { t='frame.png', target='top', l=-4, al=1 },
    ['glow'] = { t='glow.png', target='top', w=208, h=52, a=a.c, x=0, y=6, pa=a.c, l=-2, al=0.1 },
}

local fontstrings = {
    ['icon'] = { fontFile='Prompt-Medium', fontSize=16, t=s.ghost, target='top', x=0, y=0, a=a.tl, pa=a.tl, w=30, h=36, jH='CENTER', jV='MIDDLE' },
    ['fs1'] = { fontFile='Prompt-Bold', fontSize=10, t="", target='top', x=28, y=-3, a=a.tl, pa=a.tl },
    ['fs2'] = { fontFile='Prompt-Regular', fontSize=9, t="", target='top', x=28, y=-14, a=a.tl, pa=a.tl },
    ['fs3'] = { fontFile='Prompt-Regular', fontSize=9, t="", target='top', x=28, y=-24, a=a.tl, pa=a.tl },
    ['fs4'] = { fontFile='Prompt-Bold', fontSize=10, t="", target='top', x=-4, y=-3, a=a.tr, pa=a.tr },
    ['fs5'] = { fontFile='Prompt-Regular', fontSize=9, t="", target='top', x=-4, y=-14, a=a.tr, pa=a.tr },
    ['fs6'] = { fontFile='Prompt-Regular', fontSize=9, t="", target='top', x=-4, y=-24, a=a.tr, pa=a.tr },
}

function ctrl.plates:addFrames(nameplate)
    for k, v in pairs(frames) do
        local o = ctrl.cp(v)
        o.target = o.target or 'main'
        if type(o.target)=='string' then o.target=nameplate.f[o.target] end
        nameplate.f[k] = ctrl.frame.new(ctrl.plates, o)
    end
end

function ctrl.plates:addTextures(nameplate)
    for k, v in pairs(textures) do
        local o = ctrl.cp(v)
        o.target = o.target or 'main'
        if type(o.target)=='string' then o.target=nameplate.f[o.target] end
        o.path = o.path or ctrl.p.np
        nameplate.tx[k] = ctrl.tx.new(ctrl.plates, o)
    end
end

function ctrl.plates:addFontStrings(nameplate)
    for k, v in pairs(fontstrings) do
        local o = ctrl.cp(v)
        o.target = o.target or 'main'
        if type(o.target)=='string' then o.target=nameplate.f[o.target] end
        nameplate.fs[k] = ctrl.fs.new(ctrl.plates, o)
    end
end

function ctrl.plates:addFunctions(nameplate)
    nameplate.updateHealth = updateHealth
    nameplate.setColor = setColor
end

function ctrl.plates:create(namePlateFrame)
    local nameplate = ctrl.cp(default)
    local o = { target=namePlateFrame, w=self.options.width, h=self.options.height, a=a.c, pa=a.c }
    nameplate.f.main = ctrl.frame.new(ctrl.plates, o)
    self:addFrames(nameplate)
    self:addTextures(nameplate)
    self:addFontStrings(nameplate)
    self:addFunctions(nameplate)
    ctrl.nameplate[#ctrl.nameplate+1] = nameplate
    namePlateFrame.nameplate = nameplate
    return nameplate
end

function ctrl.plates:setup()
    ctrl.nameplate = ctrl.nameplate or {}
end

ctrl.plates:init()
