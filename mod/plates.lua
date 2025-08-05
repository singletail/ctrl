--[[ ctrl - plates.lua - t@wse.nyc - 27 July 2025 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local UIParent, GetTime, CreateFrame, tostring, tonumber, strsplit = UIParent, GetTime, CreateFrame, tostring, tonumber, strsplit
local UnitExists, UnitIsUnit, UnitName, UnitGUID, UnitHealth, UnitHealthMax, UnitClass, UnitRace = UnitExists, UnitIsUnit, UnitName, UnitGUID, UnitHealth, UnitHealthMax, UnitClass, UnitRace
local UnitIsEnemy, UnitInRaid, UnitInParty, UnitGroupRolesAssigned = UnitIsEnemy, UnitInRaid, UnitInParty, UnitGroupRolesAssigned
local UnitReaction, UnitClassification, UnitCreatureType, UnitCreatureFamily = UnitReaction, UnitClassification, UnitCreatureType, UnitCreatureFamily
local GUIDIsPlayer, GetNamePlateForUnit = C_PlayerInfo.GUIDIsPlayer, C_NamePlate.GetNamePlateForUnit

local mod = {
    name = 'plates',
    color = c.g,
    symbol = s.wipe,
    options = {
        timers = { 0.25 },
        events = {
            'NAME_PLATE_CREATED',
            'NAME_PLATE_UNIT_ADDED',
            'NAME_PLATE_UNIT_REMOVED',
            'RAID_TARGET_UPDATE',
            'UI_SCALE_CHANGED',
            'UNIT_CLASSIFICATION_CHANGED',
            'UNIT_HEALTH',
            'UNIT_NAME_UPDATE',
            'UNIT_MAXHEALTH',
            'UNIT_SPELLCAST_CHANNEL_START',
            'UNIT_SPELLCAST_CHANNEL_STOP',
            'UNIT_SPELLCAST_START',
            'UNIT_SPELLCAST_STOP',
            'UNIT_TARGETABLE_CHANGED',
            'UNIT_THREAT_LIST_UPDATE',
            'UNIT_THREAT_SITUATION_UPDATE',
            --'UNIT_SPELLCAST_INTERRUPTED',
            --'UNIT_TARGET',
            --'UNIT_ATTACK',
        },
    },
}

ctrl.plates = ctrl.mod:new(mod)

local function cp(t, vals)
    for k, v in pairs(vals) do
        if type(v) == 'table' then
            t[k] = t[k] or {}
            cp(t[k], v)
        else
            t[k] = v
        end
    end
end

local theme = {
    default = { w=0, h=0, x=0, y=0, a=a.tl, pa=a.tl, parent='base', alpha=1, scale=0.5, f='Prompt-Regular', fs=14, strata='BACKGROUND', layer='ARTWORK', level=0, fh=a.l, fv=a.t },
    path = {
        tx = [[Interface\AddOns\ctrl\assets\nameplate\]],
        font = [[Interface\AddOns\ctrl\assets\fnt\]],
    },
    f = {
        ['base'] = { w = 320, h = 48, a = a.br, pa = a.br, x=100, y=-100, level = 1 },
        ['health'] = { w = 294, h = 44, x = 24, y = -2, level = 2 },
        ['cast'] = { w = 294, h = 18, x = 24, y = 0, a = a.tl, pa = a.bl, level = 4 },
        ['castbk'] = { w = 294, h = 18, x = 0, y = 0, a = a.tl, pa = a.tl, level = 3, parent = 'cast' },
        ['top'] = { w = 320, h = 48, level = 10 },
    },
    tx = {
        ['warn'] = { t = 'warn.png', a = a.c, pa = a.c, level = -7, w = 400, h = 170, alpha = 0.7 },
        ['bk'] = { t = '320_bk.png', level = -6, alpha = 0.6 },
        ['cap'] = { t = '320_cap_flat.png', h = 48, w = 24, level = -5, alpha = 0.5 },
        ['health'] = { t = '320_hbar_flat.png', parent = 'health', level = -5, alpha = 0.5 },
        ['castbk'] = { t = '320_hbar_flat.png', parent = 'castbk', level = -6, alpha = 0.5 },
        ['cast'] = { t = '320_hbar_flat.png', parent = 'cast', level = -5, alpha = 0.5 },
        ['shadow'] = { t = '320_shadow.png', parent = 'top', w = 334, h = 60, a = a.c, pa = a.c, level = -4, alpha = 0.6 },
        ['frame'] = { t = '320_frame.png', parent = 'top', level = -3, alpha = 0.5 },
        ['glow'] = { t = '320_glow.png', parent = 'top', w = 334, h = 60, a = a.c, pa = a.c, level = -2, alpha = 0.1 },
    },
    fs = {
        [1] = { fs = 26, parent = 'top', x = 0, y = 0, w = 48, h = 48, fh = a.c, fv = a.m },
        [2] = { f = 'Prompt-Medium', fs = 16, parent = 'top', w = 240, h = 14, x = 42, y = -2 },
        [3] = { parent = 'top', w = 220, h = 14, x = 42, y = -16.5 },
        [4] = { parent = 'top', w = 180, h = 14, x = 42, y = -30 },
        [5] = { parent = 'top', h = 14, w = 60, x = -4, y = -2, a = a.tr, pa = a.tr, fh = a.r },
        [6] = { parent = 'top', h = 14, w = 120, x = -4, y = -16, a = a.tr, pa = a.tr, fh = a.r },
        [7] = { parent = 'top', h = 14, w = 160, x = -4, y = -30, a = a.tr, pa = a.tr, fh = a.r },
        [8] = { parent = 'cast', h = 14, w = 160, x = 42, y = 0, a = a.tl, pa = a.tl, fh = a.l }, --cast
        [9] = { f = 'SourceCodePro-Medium', fs = 16, parent = 'top', x = 42, y = -48, a = a.tl, pa = a.tl },
    },
}

local template = {
    f = {
        base = nil,
        health = nil,
        cast = nil,
        castbk = nil,
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
        raidTarget = nil,
        player = {
            pvpName = nil,
            class = nil,
            race = nil,
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
            kick = nil,
        },
        str = {
            icon = nil,
            t1 = nil,
            t2 = nil,
        },
        color = {
            hex = '|cffffffff',
            rgba = { 0, 1, 0, 1 },
            frame = { 1, 1, 1, 0.1 },
        },
    },
}

function ctrl.plates.NAME_PLATE_CREATED(evt) ctrl.plates:attach(evt[1]) end
function ctrl.plates.NAME_PLATE_UNIT_ADDED(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:AddUnit(evt[1]) end end
function ctrl.plates.NAME_PLATE_UNIT_REMOVED(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:Reset() end end
function ctrl.plates.RAID_TARGET_UPDATE() ctrl.plates:refreshAll() end
function ctrl.plates.UI_SCALE_CHANGED() ctrl.plates:refreshAll() end
function ctrl.plates.UNIT_CLASSIFICATION_CHANGED(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:AddUnit(evt[1]) end end
function ctrl.plates.UNIT_HEALTH(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:UpdateHealth(evt[1]) end end
function ctrl.plates.UNIT_NAME_UPDATE(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:AddUnit(evt[1]) end end
function ctrl.plates.UNIT_MAXHEALTH(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:UpdateHealth(evt[1]) end end
function ctrl.plates.UNIT_SPELLCAST_CHANNEL_START(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:CastStart(evt) end end
function ctrl.plates.UNIT_SPELLCAST_CHANNEL_STOP(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:CastStop(evt) end end
function ctrl.plates.UNIT_SPELLCAST_START(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:CastStart(evt) end end
function ctrl.plates.UNIT_SPELLCAST_STOP(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:CastStop(evt) end end
function ctrl.plates.UNIT_TARGETABLE_CHANGED(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:AddUnit(evt[1]) end end
function ctrl.plates.UNIT_THREAT_LIST_UPDATE(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:UpdateTargetName() end end
function ctrl.plates.UNIT_THREAT_SITUATION_UPDATE(evt) if GetNamePlateForUnit(evt[1]) and GetNamePlateForUnit(evt[1])['np'] then GetNamePlateForUnit(evt[1])['np']:UpdateTargetName() end end


-- Spellcast Event Functions

local function OnUpdateSpell(self)
    local name, _, _, startTimeMs, endTimeMs, _, _, notInterruptible, spellID = UnitCastingInfo(self.unit)
    if not name then name, _, _, startTimeMs, endTimeMs, _, notInterruptible, spellID = UnitChannelInfo(self.unit) end
    if not name then return end
    self.fs[8]:SetText(tostring(name) .. ' ' .. tostring(spellID))
    if notInterruptible then self.tx.cast:SetVertexColor(0, 0, 1, 0.5) else self.tx.cast:SetVertexColor(0.5, 0.5, 0, 1) end
    startTimeMs = startTimeMs or 0
    endTimeMs = endTimeMs or 1
    local time = ((GetTime() * 1000) - startTimeMs)
    local endtime = (endTimeMs - startTimeMs)
    local barWidth = theme.f.cast.w * (time / endtime)
    self.f.cast:SetWidth(barWidth)
end

local function CastStart(self, evt)
    self.f.cast:Show()
    local spellId = evt[3]
    if self.npc.kick and self.npc.kick == spellId then
        self.tx.warn:Show()
        ctrl.sfx:play('alert23')
    end
end

local function CastStop(self, evt)
    self.tx.warn:Hide()
    self.f.cast:Hide()
end

local function UpdateRaidTarget(self)
    self.raidTarget = GetRaidTargetIndex(self.unit) or nil
end

local function UpdateHealth(self)
    local h = UnitHealth(self.unit) or 0
    local hm = UnitHealthMax(self.unit) or 1
    if hm == 0 then
        self.fs[5]:SetText('')
        self.fs[6]:SetText('')
        self.f.health:SetWidth(0)
        return
    end
    local hp = math.floor((h / hm) * 100)
    local hmod, hstr = 1, ''
    if hm > 1000000 then
        hmod = 1000000; hstr = 'm'
    elseif hm > 1000 then
        hmod = 1000; hstr = 'k'
    end
    self.fs[5]:SetText(string.format('%d%%', hp))
    self.fs[6]:SetText(string.format('%.1f/%.1f%s', h / hmod, hm / hmod, hstr))
    self.f.health:SetWidth(hp * (theme.f.health.w / 100))
end

local function UpdateTargetName(self)
    local target = self.unit .. 'target'
    if not UnitExists(target) then self.fs[7]:SetText('') return end
    local targetName, col, icon = UnitName(target), c.w, s.target
    if UnitInRaid(target) or UnitInParty(target) then
        local role = UnitGroupRolesAssigned(target) or 'NONE'
        icon = s[role] or s.target; col = c[role] or c.w
    elseif UnitIsUnit(target, 'player') then
        icon = s.alert; col = c.p
    end
    self.fs[7]:SetText(string.format('%s%s %s', col, icon, targetName))
end

local function UpdateTargetFrame(self)
    local fc = {1, 1, 1, 0.1}
    if self.raidTarget then cp(fc, c.raid[self.raidTarget])
    elseif UnitAffectingCombat(self.unit) then
        if UnitIsUnit(self.unit, 'target') then cp(fc, c.hi.o) else cp(fc, c.hi.r) end
    else
        if UnitIsUnit(self.unit, 'target') then cp(fc, c.hi.y) else cp(fc, self.color.frame) end
    end
    self.tx.frame:SetVertexColor(fc[1],fc[2],fc[3],fc[4])
end

local function UpdateThreat(self)
    local threat = UnitThreatSituation('player', self.unit)
    if not threat then self.tx.glow:SetVertexColor(1, 1, 1, 0.1) return end
    local tcol = {[0]={1,0,0,0.5},[1]={1,0.5,0,0.5},[2]={1,0.9,0,0.5},[3]={0,1,0,0.5}}
    if UnitGroupRolesAssigned('player') == 'TANK' then threat = math.abs(threat * -1) end
    self.tx.glow:SetVertexColor(tcol[threat][1], tcol[threat][2], tcol[threat][3], tcol[threat][4])
end

local function Draw(self)
    if self.raidTarget then
        self.fs[1]:SetText(s.raid[self.raidTarget])
        self.tx.frame:SetVertexColor(c.raid[self.raidTarget][1], c.raid[self.raidTarget][2], c.raid[self.raidTarget][3], c.raid[self.raidTarget][4])
    else
        self.fs[1]:SetText(self.str.icon or s.question)
        self.tx.frame:SetVertexColor(self.color.frame[1], self.color.frame[2], self.color.frame[3], self.color.frame[4])
    end
    self.fs[2]:SetText(self.color.hex .. (self.displayName or self.name or s.question))
    self.fs[3]:SetText(self.str.t1 or self.player.guildName or '')
    self.fs[4]:SetText(self.str.t2 or self.player.guildRank or self.npc.npcId or '')
    self.tx.health:SetVertexColor(self.color.rgba[1], self.color.rgba[2], self.color.rgba[3], self.color.rgba[4])
    self.tx.cap:SetVertexColor(self.color.rgba[1], self.color.rgba[2], self.color.rgba[3], self.color.rgba[4])
    self.tx.glow:SetVertexColor(1, 1, 1, 0)
    if self.nameplate.UnitFrame and self.nameplate.UnitFrame:IsShown() then self.nameplate.UnitFrame:Hide() end
end

local function Refresh(self)
    self:UpdateRaidTarget()
    self:Draw()
    self:UpdateHealth()
    self:UpdateTargetName()
    self:UpdateTargetFrame()
    if not self.isPlayer then self:UpdateThreat() end
end

-- Functions: Config

local function ConfigPlayer(self)
    self.player.pvpName = UnitPVPName(self.unit)
    self.player.class = select(2, UnitClass(self.unit))
    self.player.race = UnitRace(self.unit)
    local guildName, guildRank = GetGuildInfo(self.unit)
    self.player.guildName = guildName
    self.player.guildRank = guildRank
    self.displayName = self.unitPVPName or self.unitName
    if c.class[self.player.class] then cp(self.color.rgba, c.class[self.player.class]) else ctrl.plates:warn('No Class', self.player.class) end
    self.player.isFriend = C_FriendList.IsFriend(self.guid)
    self.str.icon = self.player.isFriend and s.heart or s[self.player.guildName] or s[self.player.class] or s.crit
    if self.player.isFriend then cp(self.color.frame, c.rgba.p) elseif c.guild[self.player.guildName] then cp(self.color.frame, c.guild[self.player.guildName]) end
end

local function CheckDB(self)
    if ctrl.db.npcId[self.npc.npcId] then
        if ctrl.db.npcId[self.npc.npcId].i then self.str.icon = ctrl.db.npcId[self.npc.npcId].i end
        if ctrl.db.npcId[self.npc.npcId].t1 then self.str.t1 = ctrl.db.npcId[self.npc.npcId].t1 end
        if ctrl.db.npcId[self.npc.npcId].t2 then self.str.t2 = ctrl.db.npcId[self.npc.npcId].t2 end
        if ctrl.db.npcId[self.npc.npcId].c then cp(self.color.rgba, ctrl.db.npcId[self.npc.npcId].c) end
        if ctrl.db.npcId[self.npc.npcId].hex then self.color.hex = ctrl.db.npcId[self.npc.npcId].hex end
        if ctrl.db.npcId[self.npc.npcId].kick then self.npc.kick = ctrl.db.npcId[self.npc.npcId].kick end
    end
end

local function ConfigNPC(self)
    local _, _, _, _, _, npcId, spawnId = strsplit("-", self.guid)
    self.npc.npcId = tonumber(npcId)
    if spawnId then
        self.npc.spawnIndex = bit.rshift(bit.band(tonumber(string.sub(spawnId, 1, 5), 16), 0xffff8), 3)
        if self.npc.spawnIndex and tonumber(self.npc.spawnIndex)>0 then self.displayName=self.name..' '..tostring(self.npc.spawnIndex) end
    else
        self.displayName = self.name
    end
    self.npc.reaction = UnitReaction(self.unit, 'player')
    self.npc.classification = UnitClassification(self.unit)
    self.npc.creatureType = UnitCreatureType(self.unit)
    self.npc.creatureFamily = UnitCreatureFamily(self.unit)
    if UnitIsEnemy('player', self.unit) then
        cp(self.color.rgba, c.enemy[self.npc.classification])
        self.str.icon = s[self.npc.classification] or s.eightball
    else
        cp(self.color.rgba, c.reaction[self.npc.reaction])
        self.str.icon = s.reaction[self.npc.reaction] or s.eightball
    end
    self.str.t1 = self.npc.creatureType or ''
    if self.npc.creatureFamily and self.npc.creatureFamily ~= self.npc.creatureType then
        self.str.t1 = self.str.t1 .. ' - ' .. self.npc.creatureFamily
    end
    self.str.t2 = tostring(self.npc.npcId)
    self:CheckDB()
end

-- Functions: Assignment

local function AddUnit(self, unit)
    if not unit or not UnitExists(unit) then return end
    self.unit = unit
    self.guid = UnitGUID(unit)
    self.name = UnitName(unit)
    self.isPlayer = GUIDIsPlayer(self.guid)
    if self.isPlayer then self:ConfigPlayer() else self:ConfigNPC() end
    self.f.cast:SetScript('OnUpdate', function() self:OnUpdateSpell() end)
    self.f.base:Show()
    self:Refresh()
end

local function Reset(self)
    self.unit = nil
    self.guid = nil
    self.name = nil
    self.displayName = nil
    self.isPlayer = nil
    self.player = {}
    self.npc = {}
    self.str = {}
    self.color = {}
    self.color.hex = '|cffffffff'
    self.color.rgba = { 0, 1, 0, 1 }
    self.color.frame = { 1, 1, 1, 0.1 }
    for _, v in ipairs(self.fs) do v:SetText('') end
    self.f.health:SetWidth(theme.f.health.w)
    self.f.cast:SetWidth(theme.f.cast.w)
    self.tx.frame:SetVertexColor(1, 1, 1, 0.5)
    self.tx.health:SetVertexColor(1, 1, 1, 0.5)
    self.tx.cap:SetVertexColor(1, 1, 1, 0.5)
    self.tx.frame:SetVertexColor(1, 1, 1, 0.5)
    self.tx.cast:SetVertexColor(1, 1, 1, 0.5)
    self.tx.castbk:SetVertexColor(0, 0, 0, 0.5)
    self.tx.warn:SetVertexColor(1, 0.9, 0, 1)
    self.f.base:SetScale(theme.default.scale or 1)
    self.f.cast:SetScript('OnUpdate', nil)
    self.tx.warn:Hide()
    self.f.cast:Hide()
    self.f.charm:Hide()
    self:Hide()
end

local function Hide(self) self.f.base:Hide(); self.f.cast:Hide() end
local function ClearAllPoints(self) self.f.base:ClearAllPoints() end
local function SetParent(self, parent) self.f.base:SetParent(parent) end
local function SetPoint(self, anc, parent, panc, x, y) self.f.base:SetPoint(anc, parent, panc, x, y) end

function ctrl.plates:fn(np)
    np.Draw = Draw
    np.Refresh = Refresh
    np.UpdateHealth = UpdateHealth
    np.UpdateRaidTarget = UpdateRaidTarget
    np.UpdateTargetName = UpdateTargetName
    np.UpdateTargetFrame = UpdateTargetFrame
    np.UpdateThreat = UpdateThreat
    np.OnUpdateSpell = OnUpdateSpell
    np.CastStart = CastStart
    np.CastStop = CastStop

    np.ConfigPlayer = ConfigPlayer
    np.ConfigNPC = ConfigNPC
    np.CheckDB = CheckDB

    np.AddUnit = AddUnit
    np.Reset = Reset
    np.Hide = Hide

    np.ClearAllPoints = ClearAllPoints
    np.SetParent = SetParent
    np.SetPoint = SetPoint
end

-- Assign

function ctrl.plates:assign(np, nameplate)
    np.nameplate = nameplate
    nameplate.np = np
    np:ClearAllPoints()
    np:SetParent(nameplate)
    np:SetPoint(a.c, nameplate, a.c, 0, 0)
end

function ctrl.plates:attach(nameplate)
    for i = 1, 40 do
        if not ctrl.np[i].nameplate then
            self:assign(ctrl.np[i], nameplate)
            return
        end
    end
end

-- Constructors

function ctrl.plates:opt(v)
    local opt = {}
    cp(opt, theme.default)
    cp(opt, v)
    if not opt.anchors then opt.anchors = { { a = opt.a, pa = opt.pa, x = opt.x, y = opt.y } } end
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
    np.tx[k]:SetTexture(theme.path.tx .. opt.t, a.w.c, a.w.c, 'TRILINEAR')
    np.tx[k]:SetParent(opt.parent)
    if opt.w > 0 and opt.h > 0 then
        np.tx[k]:SetSize(opt.w, opt.h); self:anchor(np.tx[k], opt)
    else
        np.tx[k]:SetSize(opt.parent:GetWidth(), opt.parent:GetHeight()); np.tx[k]:SetAllPoints(opt.parent)
    end
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
    for n = 1, #opt.anchors do
        e:SetPoint(opt.anchors[n].a, opt.parent, opt.anchors[n].pa, opt.anchors[n].x, opt.anchors[n].y)
    end
end

local function charmScript(self)
    local cur = GetRaidTargetIndex(self.np.unit)
    if self.i == 9 then
        if cur then SetRaidTarget(self.np.unit, cur) end
    elseif self.i ~= cur then
        SetRaidTarget(self.np.unit, self.i)
    end
    self.np.f.charm:Hide()
end

local function charmFrame(np)
    np.f.charm = ctrl.frame.new(ctrl.plates,{target=np.f.base, w=181, h=20, x=0, y=0, a=a.br, pa=a.tr})
    np.f.charm.tx = ctrl.tx.new(ctrl.plates,{target=np.f.charm, t='box.png'})
    np.f.charm.tx:SetVertexColor(0, 0, 0, 0.5)
    np.f.charm.btn = np.f.charm.btn or {}
    for i=1,9 do
        np.f.charm.btn[i] = ctrl.frame.new(ctrl.plates,{target=np.f.charm, w=18, h=18, x=((i-1)*20)+1, y=2, a=a.l, pa=a.l})
        np.f.charm.btn[i].tx = ctrl.tx.new(ctrl.plates, {target=np.f.charm.btn[i], t='box.png', al=0.2})
        np.f.charm.btn[i].fs = ctrl.fs.new(ctrl.plates, {target=np.f.charm.btn[i], t=s.raid[i], fontSize=17, x=0, y=0, a=a.tl, pa=a.tl, w=19, h=19, fh=a.c, fv=a.m})
        np.f.charm.btn[i].np = np
        np.f.charm.btn[i].i = i
        np.f.charm.btn[i]:SetScript('OnMouseUp', charmScript)
    end
    np.f.base.np = np
    np.f.base:EnableMouse(true)
    np.f.base:SetPassThroughButtons('LeftButton', 'MiddleButton')
    np.f.base:SetScript('OnMouseDown', function(self)
        if self.np.f.charm:IsShown() then self.np.f.charm:Hide() else self.np.f.charm:Show() end
    end)
    np.f.charm:Hide()
end

function ctrl.plates:build(np)
    self:fAdd(np, 'base', theme.f.base)
    for k, v in pairs(theme.f) do if k ~= 'base' then self:fAdd(np, k, v) end end
    for k, v in pairs(theme.tx) do self:txAdd(np, k, v) end
    for k, v in pairs(theme.fs) do self:fsAdd(np, k, v) end
    self:fn(np)
    np.f.base:SetScale(theme.default.scale or 1)
    charmFrame(np)
    np:Reset()
end

-- Setup & Generation

function ctrl.plates:refreshAll()
    for i = 1, 40 do if ctrl.np and ctrl.np[i] and ctrl.np[i].unit then ctrl.np[i]:Refresh() end end
end

function ctrl.plates.tick()
    ctrl.plates:refreshAll()
end

function ctrl.plates:new(i)
    local np = {i=i}
    cp(np, template)
    cp(np, np.default)
    self:build(np)
    return np
end

function ctrl.plates:setup()
    ctrl.np = ctrl.np or {}
    for i = 1, 40 do ctrl.np[i] = ctrl.np[i] or self:new(i) end
end

ctrl.plates:init()
