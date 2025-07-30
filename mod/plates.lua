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
            'UNIT_HEALTH',
            'UNIT_MAXHEALTH',
            'UNIT_NAME_UPDATE',
            'UNIT_SPELLCAST_START',
            'UNIT_SPELLCAST_STOP',
            'UNIT_SPELLCAST_INTERRUPTIBLE',
            'UNIT_SPELLCAST_NOT_INTERRUPTIBLE',
            'UNIT_SPELLCAST_INTERRUPTED',
            'UNIT_SPELLCAST_CHANNEL_START',
            'UNIT_SPELLCAST_CHANNEL_STOP',
            'UNIT_SPELLCAST_CHANNEL_UPDATE',
            'UNIT_SPELLCAST_FAILED',
            'UNIT_SPELLCAST_FAILED_QUIET',
            'UNIT_TARGETABLE_CHANGED',
            'UNIT_THREAT_LIST_UPDATE',
            'UNIT_THREAT_SITUATION_UPDATE',
        },
    },
}

ctrl.plates = ctrl.mod:new(mod)

local theme = {
    default = { w=0, h=0, x=0, y=0, a=a.tl, pa=a.tl, parent='base', alpha=1, scale=0.4, f='Prompt-Regular', fs=14, strata='BACKGROUND', layer='ARTWORK', level=0, fh=a.l, fv=a.t },
    path = {
        tx = [[Interface\AddOns\ctrl\assets\nameplate\]],
        font = [[Interface\AddOns\ctrl\assets\fnt\]],
    },
    f = {
        ['base'] = { w=320, h=48, a=a.c, pa=a.c, level=1 },
        ['health'] = { w=294, h=44, x=24, y=-2, level=2 },
        ['cast'] = { w=294, h=16, x=24, y=0, a=a.tl, pa=a.bl, level=4 },
        ['top'] = { w=320, h=48, level=10 },
    },
    tx = {
        ['bk'] = { t='320_bk.png', level=-7, alpha=0.6 },
        ['cap'] = { t='320_cap_flat.png', h=48, w=24, level=-6, alpha=0.5 },
        ['health'] = { t='320_hbar_flat.png', parent='health', level=-6, alpha=0.5 },
        ['cast'] = { t='320_hbar_flat.png', parent='cast', level=-6, alpha=1 },
        ['shadow'] = { t='320_shadow.png', parent='top', w=334, h=60, a=a.c, pa=a.c, level=-5, alpha=0.6 },
        ['frame'] = { t='320_frame.png', parent='top', level=-4, alpha=0.5 },
        ['glow'] = { t='320_glow.png', parent='top', w=334, h=60, a=a.c, pa=a.c, level=-2, alpha=0.1 },
    },
    fs = {
        [1] = { fs=26, parent='top', x=0, y=0, w=48, h=48, fh=a.c, fv=a.m },
        [2] = { f='Prompt-Medium', fs=16, parent='top', w=240, h=14, x=42, y=-2 },
        [3] = { parent='top', w=200, h=14, x=42, y=-16 },
        [4] = { parent='top', w=120, h=14, x=42, y=-30 },
        [5] = { parent='top', h=14, w=52, x=-4, y=-2, a=a.tr, pa=a.tr, fh=a.r },
        [6] = { parent='top', h=14, w=80, x=-4, y=-16, a=a.tr, pa=a.tr, fh=a.r },
        [7] = { parent='top', h=14, w=160, x=-4, y=-30, a=a.tr, pa=a.tr, fh=a.r },
        [8] = { parent='cast', h=14, w=160, x=42, y=0, a=a.tl, pa=a.tl, fh=a.l }, --cast
        [9] = { f='SourceCodePro-Medium', fs=16, parent='top', x=42, y=-48, a=a.tl, pa=a.tl },
    },
}

local template = {
    f = {
        base = nil,
        health = nil,
        cast = nil,
        top = nil,
    },
    tx = {},
    fs = {},
    default = {
        unit = nil,
        guid = nil,
        name = nil,
        displayName = nil,
        isPlayer = nil,
        data = {
            target = nil,
            aggro = nil,
            health = 0,
            healthMax = 1,
            healthPct = 100,
        },
        player = {
            pvpName = nil,
            class = nil,
            guildName = nil,
            guildRank = nil,
            isFriend = nil,
        },
        npc = {
            npcId = nil,
            spawnIndex = nil,
            reaction = nil,
            classification = nil,
            creatureType = nil,
            creatureFamily = nil,
        },
        str = {
            icon = s.question,
            t1 = '',
            t2 = '',
        },
        color = {
            hex = '|cffffffff',
            rgba = { 0, 0, 0, 1 },
            frame = { 1, 1, 1, 0.1 },
        },
    },
}

-- Events

function ctrl.plates.NAME_PLATE_CREATED(evt)
    for i=1,40 do if not ctrl.np[i].nameplate then ctrl.np[i]:Attach(evt[1]) return end end
end

function ctrl.plates.NAME_PLATE_UNIT_ADDED(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:Assign(evt[1]) end
end

function ctrl.plates.UNIT_NAME_UPDATE(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:Assign(evt[1]) end
end

function ctrl.plates.UNIT_HEALTH(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:DrawHealth(evt[1]) end
end

function ctrl.plates.UNIT_MAXHEALTH(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:DrawHealth(evt[1]) end
end

function ctrl.plates.UNIT_TARGETABLE_CHANGED(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:Assign(evt[1]) end
end

function ctrl.plates.NAME_PLATE_UNIT_REMOVED(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:Reset() end
end

function ctrl.plates.UNIT_SPELLCAST_START(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:Cast(evt) end
end

function ctrl.plates.UNIT_SPELLCAST_STOP(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:CastEnd(evt) end
end

function ctrl.plates.UNIT_SPELLCAST_INTERRUPTIBLE(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:warn('UNIT_SPELLCAST_INTERRUPTIBLE', evt[1])
end

function ctrl.plates.UNIT_SPELLCAST_NOT_INTERRUPTIBLE(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:warn('UNIT_SPELLCAST_NOT_INTERRUPTIBLE', evt[1])
end

function ctrl.plates.UNIT_SPELLCAST_INTERRUPTED(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:notice('UNIT_SPELLCAST_INTERRUPTED', evt[1], evt[2], evt[3])
end

function ctrl.plates.UNIT_SPELLCAST_CHANNEL_START(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:notice('UNIT_SPELLCAST_CHANNEL_START', evt[1], evt[2], evt[3])
end

function ctrl.plates.UNIT_SPELLCAST_CHANNEL_STOP(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:notice('UNIT_SPELLCAST_CHANNEL_STOP', evt[1], evt[2], evt[3])
end

function ctrl.plates.UNIT_SPELLCAST_CHANNEL_UPDATE(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:notice('UNIT_SPELLCAST_CHANNEL_UPDATE', evt[1], evt[2], evt[3])
end

function ctrl.plates.UNIT_SPELLCAST_FAILED(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:notice('UNIT_SPELLCAST_FAILED', evt[1], evt[2], evt[3])
end

function ctrl.plates.UNIT_SPELLCAST_FAILED_QUIET(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:notice('UNIT_SPELLCAST_FAILED_QUIET', evt[1], evt[2], evt[3])
end

function ctrl.plates.UNIT_THREAT_LIST_UPDATE(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:notice('UNIT_THREAT_LIST_UPDATE', evt[1])
end

function ctrl.plates.UNIT_THREAT_SITUATION_UPDATE(evt)
    local nameplate = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not nameplate then return end
    ctrl.plates:notice('UNIT_THREAT_SITUATION_UPDATE', evt[1])
end



-- Functions: Init

local function ConfigPlayer(self)
    self.player.pvpName = UnitPVPName(self.unit)
    self.player.class = select(2, UnitClass(self.unit))
    self.player.guildName, self.player.guildRank = GetGuildInfo(self.unit)
    self.displayName = self.unitPVPName or self.unitName
    self.color.rgba = c.class[self.player.class] or c.rgba.black
    self.player.isFriend = C_FriendList.IsFriend(self.guid)
    self.str.icon = self.player.isFriend and s.heart or s[self.guildName] or s[self.player.class] or s.crit
    if self.player.isFriend then self.color.frame=c.rgba.p elseif s[self.player.guildName] then self.color.frame=c.rgba.c end
end

local function CheckDB(self)
    if ctrl.db[self.npc.npcId] then
        self.str.icon = ctrl.db[self.npc.npcId].icon
        self.str.t1 = ctrl.db[self.npc.npcId].t1
        self.str.t2 = ctrl.db[self.npc.npcId].t2
        self.color.rgba = ctrl.db[self.npc.npcId].c
        self.color.hex = ctrl.db[self.npc.npcId].hex
    end
end

local function ConfigNPC(self)
    local _, _, _, _, _, npcId, spawnId = strsplit("-", self.guid)
    self.npc.npcId = tonumber(npcId)
    self.npc.spawnIndex = bit.rshift(bit.band(tonumber(string.sub(spawnId, 1, 5), 16), 0xffff8), 3)
    if self.npc.spawnIndex and tonumber(self.npc.spawnIndex)>0 then self.displayName=self.name..' '..tostring(self.npc.spawnIndex) end
    self.npc.reaction = UnitReaction(self.unit, 'player')
    self.npc.classification = UnitClassification(self.unit)
    self.npc.creatureType = UnitCreatureType(self.unit)
    self.npc.creatureFamily = UnitCreatureFamily(self.unit)
    if UnitIsEnemy('player', self.unit) then
        self.color.rgba = c.enemy[self.npc.classification] or c.rgba.black
        self.str.icon = s[self.npc.classification] or s.eightball
    else
        self.color.rgba = c.reaction[self.npc.reaction] or c.rgba.black
        self.icon = s.reaction[self.npc.reaction] or s.eightball
    end
    self.str.t1 = self.npc.creatureType or ''
    if self.npc.creatureFamily and self.npc.creatureFamily ~= self.npc.creatureType then
        self.str.t1 = self.str.t1 .. ' - ' .. self.npc.creatureFamily end
    self.str.t2 = tostring(self.npc.npcId)
    self:CheckDB()
end


-- Functions: Assignment

local function Attach(self, nameplate)
    self.nameplate = nameplate
    nameplate.np = self
    self.f.base:ClearAllPoints()
    self.f.base:SetParent(nameplate)
    self.f.base:SetPoint(a.c, nameplate, a.c, 0, 0)
end

local function Assign(self, unit)
    self.unit = unit
    self.guid = UnitGUID(unit)
    self.name = UnitName(unit)
    self.isPlayer = C_PlayerInfo.GUIDIsPlayer(self.guid)
    if self.isPlayer then self:ConfigPlayer() else self:ConfigNPC() end
    self:Draw()
    self.f.base:Show()
    self.f.base:SetScript('OnUpdate', function() self:Update() end)
end

local function Reset(self)
    self.f.base:SetScript('OnUpdate', nil)
    self.f.cast:Hide()
    self.f.base:Hide()
    ctrl.merge(self, self.default)
    for _, v in ipairs(self.fs) do
        v:SetText('')
    end
end

--

-- TODO: Throttle, change to events-only
-- TODO: add/remove onUpdate from spell events
-- TODO: Threat

local function Update(self) 
    if not self.unit then return end
    self:UpdateSpell()
    if self.nameplate.UnitFrame:IsShown() then self.nameplate.UnitFrame:Hide() end
    if self.isPlayer then self:UpdatePlayer() else self:UpdateNPC() end
    self:Target()
end

local function UpdateSpell(self)
    local name, displayName, textureID, startTimeMs, endTimeMs, _, castID, notInterruptible, spellID = UnitCastingInfo(self.unit)
    if not name then name, displayName, textureID, startTimeMs, endTimeMs, _, notInterruptible, spellID = UnitChannelInfo(self.unit) end
    if not name then self.f.cast:Hide(); return end
    if notInterruptible then self.tx.cast:SetVertexColor(0, 0, 1, 1) else self.tx.cast:SetVertexColor(0, 0.5, 0, 1) end
    local progressPercent = (GetTime() * 1000 - startTimeMs) / (endTimeMs - startTimeMs)
    self.f.cast:SetWidth(progressPercent * (theme.f.cast.w / 100))
    self.fs[8]:SetText(tostring(name)..' '..tostring(spellID))
    if not self.f.cast:IsShown() then self.f.cast:Show() end
end

local function UpdatePlayer(self)
end

local function UpdateNPC(self)
    if UnitIsUnit('target', self.unit) then
        self.tx.frame:SetVertexColor(1, 1, 0, 1)
    elseif UnitAffectingCombat(self.unit) then
         self.tx.frame:SetVertexColor(1, 0, 0, 1)
    else
         self.tx.frame:SetVertexColor(1, 0, 0, 0.1)
    end
end

local function Cast(self, evt)
--[[
    local spellId = evt[3]
    self.f.cast:Show()
    self.tx.cast:SetVertexColor(1, 0, 0, 1)
    local spellInfo = C_Spell.GetSpellInfo(spellId)
    self.fs[8]:SetText(spellInfo.name or '?')
    ]]
end

local function CastEnd(self, evt)
--[[
    self.fs[8]:SetText('')
    self.f.cast:Hide()
    ]]
end

local function Target(self)
    if not UnitExists(self.unit..'target') then return end
    local target = UnitName(self.unit..'target' or '')
    self.fs[7]:SetText(target)
end

--

local function DrawHealth(self)
    local h = UnitHealth(self.unit) or 0
    local hm = UnitHealthMax(self.unit) or 1
    local hp = math.floor((h / hm) * 100)
    self.f.health:SetWidth(hp * (theme.f.health.w / 100))
    self.fs[5]:SetText(string.format('%d%%', hp))
    local hmod, hstr = 1, ''
    if hm>1000000 then hmod=1000000;hstr='m' elseif hm>1000 then hmod=1000;hstr='k' end
    self.fs[6]:SetText(string.format('%.1f/%.1f%s', h/hmod, hm/hmod, hstr))
end

local function DrawPlayer(self)
    self.fs[3]:SetText(self.player.guildName or '')
    self.fs[4]:SetText(self.player.guildRank or '')
    self.fs[8]:SetText(self.player.class or '')
end

local function DrawNPC(self)
    self.fs[3]:SetText(self.str.t1 or '')
    self.fs[4]:SetText(self.str.t2 or '')
end

local function DrawColor(self)
    self.tx.health:SetVertexColor(self.color.rgba[1], self.color.rgba[2], self.color.rgba[3], self.color.rgba[4])
    self.tx.cap:SetVertexColor(self.color.rgba[1], self.color.rgba[2], self.color.rgba[3], self.color.rgba[4])
    self.tx.frame:SetVertexColor(self.color.frame[1], self.color.frame[2], self.color.frame[3], self.color.frame[4])
end

local function Draw(self)
    if self.isPlayer then self:DrawPlayer() else self:DrawNPC() end
    self.fs[1]:SetText(self.str.icon or s.question)
    self.fs[2]:SetText(self.color.hex .. (self.displayName or self.name or s.question))
    self:DrawColor()
    self.nameplate.UnitFrame:Hide()
end

function ctrl.plates:fn(np)
    np.Assign = Assign
    np.Attach = Attach
    np.Cast = Cast
    np.CastEnd = CastEnd
    np.CheckDB = CheckDB
    np.ConfigPlayer = ConfigPlayer
    np.ConfigNPC = ConfigNPC
    np.Draw = Draw
    np.DrawColor = DrawColor
    np.DrawHealth = DrawHealth
    np.DrawPlayer = DrawPlayer
    np.DrawNPC = DrawNPC
    np.Reset = Reset
    np.Target = Target
    np.Update = Update
    np.UpdateNPC = UpdateNPC
    np.UpdatePlayer = UpdatePlayer
    np.UpdateSpell = UpdateSpell
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
    np.f.base:SetScale(theme.default.scale or 1)
    np.f.cast:Hide()
    np.f.base:Hide()
    return np
end

function ctrl.plates:generate()
    ctrl.np = ctrl.np or {}
    for i=1,40 do
        ctrl.np[i] = ctrl.np[i] or self:new(i)
    end
end

function ctrl.plates:setup()
    self:generate()
end

ctrl.plates:init()
