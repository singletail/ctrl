--[[ ctrl - plates.lua - t@wse.nyc - 27 July 2025 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a


local UIParent = UIParent
local tostring = tostring
local tonumber = tonumber
local strsplit = strsplit

local GetTime = GetTime

local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local UnitGUID = UnitGUID
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

local UnitIsEnemy = UnitIsEnemy
local UnitReaction = UnitReaction
local UnitClassification = UnitClassification
local UnitCreatureType = UnitCreatureType
local UnitCreatureFamily = UnitCreatureFamily

local GUIDIsPlayer = C_PlayerInfo.GUIDIsPlayer
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local CreateFrame = CreateFrame

local mod = {
    name = 'plates',
    color = c.g,
    symbol = s.wipe,
    options = {
        events = {
            'UI_SCALE_CHANGED',
            'NAME_PLATE_CREATED',
            'NAME_PLATE_UNIT_ADDED',
            'NAME_PLATE_UNIT_REMOVED',
            'UNIT_HEALTH',
            'UNIT_MAXHEALTH',
            'UNIT_SPELLCAST_START',
            'UNIT_SPELLCAST_STOP',
            'UNIT_SPELLCAST_INTERRUPTED',
            'UNIT_SPELLCAST_CHANNEL_START',
            'UNIT_SPELLCAST_CHANNEL_STOP',
            'UNIT_SPELLCAST_INTERRUPTED',
            'UNIT_THREAT_LIST_UPDATE',
            'UNIT_THREAT_SITUATION_UPDATE',
            'UNIT_TARGET',
            'UNIT_NAME_UPDATE',
            'UNIT_TARGETABLE_CHANGED',
            'UNIT_ATTACK',
            'UNIT_CLASSIFICATION_CHANGED',
        },
    },
}

-- x, y = GetCursorPosition()
-- xPos, yPos, distance = ClosestGameObjectPosition(gameObjectID)
-- f:SetScript("OnEnter", function(self, motion)
--  	...
-- end)

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
    default = { w=0, h=0, x=0, y=0, a=a.tl, pa=a.tl, parent='base', alpha=1, scale=0.4, f='Prompt-Regular', fs=14, strata='BACKGROUND', layer='ARTWORK', level=0, fh=a.l, fv=a.t },
    path = {
        tx = [[Interface\AddOns\ctrl\assets\nameplate\]],
        font = [[Interface\AddOns\ctrl\assets\fnt\]],
    },
    f = {
        ['base'] = { w=320, h=48, a=a.c, pa=a.c, level=1 },
        ['health'] = { w=294, h=44, x=24, y=-2, level=2 },
        ['cast'] = { w=294, h=16, x=24, y=0, a=a.tl, pa=a.bl, level=4 },
        ['castbk'] = { w=294, h=16, x=0, y=0, a=a.tl, pa=a.tl, level=3, parent='cast' },
        ['top'] = { w=320, h=48, level=10 },
    },
    tx = {
        ['bk'] = { t='320_bk.png', level=-7, alpha=0.6 },
        ['cap'] = { t='320_cap_flat.png', h=48, w=24, level=-6, alpha=0.5 },
        ['health'] = { t='320_hbar_flat.png', parent='health', level=-6, alpha=0.5 },
        ['castbk'] = { t='320_hbar_flat.png', parent='castbk', level=-6, alpha=0.5 },
        ['cast'] = { t='320_hbar_flat.png', parent='cast', level=-5, alpha=0.5 },
        ['shadow'] = { t='320_shadow.png', parent='top', w=334, h=60, a=a.c, pa=a.c, level=-5, alpha=0.6 },
        ['frame'] = { t='320_frame.png', parent='top', level=-4, alpha=0.5 },
        ['glow'] = { t='320_glow.png', parent='top', w=334, h=60, a=a.c, pa=a.c, level=-2, alpha=0.1 },
        ['box'] = { t='box.png', parent='top', w=64, h=64, a=a.c, pa=a.c, level=-2, alpha=1 },
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
            rgba = { 0, 1, 0, 1 },
            frame = { 1, 1, 1, 0.1 },
        },
    },
}



-- Events

function ctrl.plates.UI_SCALE_CHANGED()
    ctrl.plates:redraw()
end

function ctrl.plates.NAME_PLATE_CREATED(evt)
    ctrl.plates:attach(evt[1])
end

function ctrl.plates.NAME_PLATE_UNIT_ADDED(evt)
    GetNamePlateForUnit(evt[1])['np']:AddUnit(evt[1])
end

function ctrl.plates.NAME_PLATE_UNIT_REMOVED(evt)
    GetNamePlateForUnit(evt[1])['np']:Reset()
end

function ctrl.plates.UNIT_HEALTH(evt)
    GetNamePlateForUnit(evt[1])['np']:DrawHealth(evt[1])
end

function ctrl.plates.UNIT_MAXHEALTH(evt)
    GetNamePlateForUnit(evt[1])['np']:DrawHealth(evt[1])
end

function ctrl.plates.UNIT_SPELLCAST_START(evt)
    GetNamePlateForUnit(evt[1])['np']:CastStart(evt)
end

function ctrl.plates.UNIT_SPELLCAST_STOP(evt)
    GetNamePlateForUnit(evt[1])['np']:CastStop(evt)
end

function ctrl.plates.UNIT_SPELLCAST_CHANNEL_START(evt)
    GetNamePlateForUnit(evt[1])['np']:CastStart(evt)
end

function ctrl.plates.UNIT_SPELLCAST_CHANNEL_STOP(evt)
    GetNamePlateForUnit(evt[1])['np']:CastStop(evt)
end

-- To Check

function ctrl.plates.UNIT_SPELLCAST_INTERRUPTED(evt)
    ctrl.plates:warn('UNIT_SPELLCAST_INTERRUPTED', evt[1], evt[2], evt[3])
    --GetNamePlateForUnit(evt[1])['np']:CastStop(evt)
end

-- Threat

function ctrl.plates.UNIT_THREAT_LIST_UPDATE(evt)
    local nameplate = GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:UpdateThreat() end
end

function ctrl.plates.UNIT_THREAT_SITUATION_UPDATE(evt)
    local nameplate = GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:UpdateThreat() end
end

-- ???

function ctrl.plates.UNIT_TARGET(evt)
    local nameplate = GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:UpdateTarget() end
    local targetplate = GetNamePlateForUnit('target')
    if targetplate and targetplate['np'] then targetplate['np']:UpdateTarget() end
end

function ctrl.plates.UNIT_NAME_UPDATE(evt)
    GetNamePlateForUnit(evt[1])['np']:AddUnit(evt[1])
end

function ctrl.plates.UNIT_TARGETABLE_CHANGED(evt)
    GetNamePlateForUnit(evt[1])['np']:AddUnit(evt[1])
end

function ctrl.plates.UNIT_ATTACK(evt)
    local nameplate = GetNamePlateForUnit(evt[1])
    if nameplate and nameplate['np'] then nameplate['np']:UpdateTarget() end
end

function ctrl.plates.UNIT_CLASSIFICATION_CHANGED(evt)
    GetNamePlateForUnit(evt[1])['np']:AddUnit(evt[1])
end

-- Spellcast Event Functions

local function OnUpdateSpell(self)
    local name, displayName, textureID, startTimeMs, endTimeMs, _, castID, notInterruptible, spellID = UnitCastingInfo(self.unit)
    if not name then name, displayName, textureID, startTimeMs, endTimeMs, _, notInterruptible, spellID = UnitChannelInfo(self.unit) end
    if not name then return end
    self.fs[8]:SetText(tostring(name)..' '..tostring(spellID))
    if notInterruptible then self.tx.cast:SetVertexColor(0, 0, 1, 0.5) else self.tx.cast:SetVertexColor(0.5, 0.5, 0, 1) end
    startTimeMs = startTimeMs or 0
    endTimeMs = endTimeMs or 1
    local time = ((GetTime() * 1000) - startTimeMs)
    local endtime = (endTimeMs - startTimeMs)
    local barWidth = theme.f.cast.w * (time/endtime)
    self.f.cast:SetWidth(barWidth)
end

local function CastStart(self, evt)
    self.f.cast:Show()
    self:UpdateTarget()
end

local function CastStop(self, evt)
    self.f.cast:Hide()
    self:UpdateTarget()
end

-- Draw

local function UpdateHealth(self)
    local h = UnitHealth(self.unit) or 0
    local hm = UnitHealthMax(self.unit) or 1
    local hp = math.floor((h / hm) * 100)
    local hmod, hstr = 1, ''
    if hm>1000000 then hmod=1000000;hstr='m' elseif hm>1000 then hmod=1000;hstr='k' end
    self.fs[5]:SetText(string.format('%d%%', hp))
    self.fs[6]:SetText(string.format('%.1f/%.1f%s', h/hmod, hm/hmod, hstr))
    self.f.health:SetWidth(hp * (theme.f.health.w / 100))
    self:UpdateTarget()
end



local function UpdateTarget(self)
    -- Target Name
    local target = self.unit..'target'
    if not UnitExists(target) then 
        ctrl.plates:debug('UpdateTarget', 'No target found', self.unit)
        self.fs[7]:SetText('')
        return
    end

    local targetName, col, icon = UnitName(target), c.w, s.target
    if UnitInRaid(target) or UnitInParty(target) then
        local role = UnitGroupRolesAssigned(target) or 'NONE'
        icon = s[role] or s.target; col = c[role] or c.w
    elseif UnitIsUnit(target, 'player') then
        icon = s.alert; col = c.p
    end
    self.fs[7]:SetText(string.format('%s%s %s', col, icon, targetName))
    ctrl.plates:debug('UpdateTarget', self.unit, targetName)
end

local function UpdateThreat(self)
    local col = {
        off = {1, 1, 1, 0},
        dim = {1, 1, 1, 0.2},
        orange = {1, 0.5, 0, 1},
        yellow = {1, 1, 0, 1},
        red = {1, 0, 0, 1},
    }
    local col_frame = 'dim'
    local col_glow = 'off'
    if not UnitAffectingCombat(self.unit) then
        if UnitIsUnit(self.unit, 'target') then col_frame = 'yellow' end
    else
        --if UnitIsUnit(self.unit, 'target') then col_frame = 'orange' else col_frame = 'red' end
        if IsInRaid() or IsInGroup() then
            local role = UnitGroupRolesAssigned('player')
            local threatStatus = UnitThreatSituation('player', self.unit)
    end
--[[
    if UnitAffectingCombat(self.unit) then
        self.tx.frame:SetVertexColor(c.rgba.r)
        if IsInRaid() or IsInGroup() then
            local role = UnitGroupRolesAssigned('player')
            local threatStatus = UnitThreatSituation('player', self.unit)
            if role == 'TANK' then
                if threatStatus == 3 then
                    self.tx.frame:SetVertexColor(c.rgba.c)
                    self.tx.glow:SetVertexColor(1, 1, 1, 0.2)
                elseif threatStatus == 2 then
                    self.tx.frame:SetVertexColor(c.rgba.o)
                    self.tx.glow:SetVertexColor(c.rgba.o)
                else
                    self.tx.frame:SetVertexColor(c.rgba.r)
                    self.tx.glow:SetVertexColor(c.rgba.r)
                end
            else
                if threatStatus == 3 then
                    self.tx.frame:SetVertexColor(c.rgba.r)
                    self.tx.glow:SetVertexColor(c.rgba.r)
                elseif threatStatus == 2 then
                    self.tx.frame:SetVertexColor(c.rgba.y)
                    self.tx.glow:SetVertexColor(c.rgba.o)
                else
                    self.tx.frame:SetVertexColor(c.rgba.g)
                    self.tx.glow:SetVertexColor(1, 1, 1, 0.2)
                end
            end
        end
    else
        self.tx.glow:SetVertexColor(1, 1, 1, 0.1)
        if UnitIsUnit(self.unit, 'target') then
            self.tx.frame:SetVertexColor(c.rgba.y)
        else
            self.tx.frame:SetVertexColor(1, 1, 1, 0.1)
        end
    end
    ]]
end

local function Draw(self)
    self.fs[1]:SetText(self.str.icon or s.question)
    self.fs[2]:SetText(self.color.hex .. (self.displayName or self.name or s.question))
    self.fs[3]:SetText(self.str.t1 or self.player.guildName or '')
    self.fs[4]:SetText(self.str.t2 or self.player.guildRank or'')
    self.tx.health:SetVertexColor(self.color.rgba[1], self.color.rgba[2], self.color.rgba[3], self.color.rgba[4])
    self.tx.cap:SetVertexColor(self.color.rgba[1], self.color.rgba[2], self.color.rgba[3], self.color.rgba[4])
    self.tx.frame:SetVertexColor(self.color.frame[1], self.color.frame[2], self.color.frame[3], self.color.frame[4])
    self.nameplate.UnitFrame:Hide()
end

-- Functions: Config

local function ConfigPlayer(self)
    self.player.pvpName = UnitPVPName(self.unit)
    self.player.class = select(2, UnitClass(self.unit))
    self.player.guildName, self.player.guildRank = GetGuildInfo(self.unit)
    self.displayName = self.unitPVPName or self.unitName
    cp(self.color.rgba, c.class[self.player.class])
    self.player.isFriend = C_FriendList.IsFriend(self.guid)
    self.str.icon = self.player.isFriend and s.heart or s[self.guildName] or s[self.player.class] or s.crit
    if self.player.isFriend then self.color.frame=c.rgba.p elseif s[self.player.guildName] then self.color.frame=c.rgba.c end
end

local function CheckDB(self)
    if ctrl.db[self.npc.npcId] then
        if ctrl.db[self.npc.npcId].icon then self.str.icon = ctrl.db[self.npc.npcId].icon end
        if ctrl.db[self.npc.npcId].t1 then self.str.t1 = ctrl.db[self.npc.npcId].t1 end
        if ctrl.db[self.npc.npcId].t2 then self.str.t2 = ctrl.db[self.npc.npcId].t2 end
        if ctrl.db[self.npc.npcId].c then cp(self.color.rgba, ctrl.db[self.npc.npcId].c) end
        if ctrl.db[self.npc.npcId].hex then self.color.hex = ctrl.db[self.npc.npcId].hex end
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
        cp(self.color.rgba, c.enemy[self.npc.classification])
        self.str.icon = s[self.npc.classification] or s.eightball
    else
        cp(self.color.rgba, c.reaction[self.npc.reaction])
        self.icon = s.reaction[self.npc.reaction] or s.eightball
    end
    self.str.t1 = self.npc.creatureType or ''
    if self.npc.creatureFamily and self.npc.creatureFamily ~= self.npc.creatureType then
        self.str.t1 = self.str.t1 .. ' - ' .. self.npc.creatureFamily end
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
    self:Draw()
    self.f.base:Show()
    self:UpdateTarget()
    self.f.cast:SetScript('OnUpdate', function() self:OnUpdateSpell() end)
end

local function Reset(self)
    cp(self, self.default)
    for _, v in ipairs(self.fs) do v:SetText('') end
    self.f.health:SetWidth(theme.f.health.w)
    self.f.cast:SetWidth(theme.f.cast.w)
    self.tx.frame:SetVertexColor(1, 1, 1, 0.5)
    self.tx.health:SetVertexColor(1, 1, 1, 0.5)
    self.tx.cap:SetVertexColor(1, 1, 1, 0.5)
    self.tx.frame:SetVertexColor(1, 1, 1, 0.5)
    self.tx.cast:SetVertexColor(1, 1, 1, 0.5)
    self.tx.castbk:SetVertexColor(0, 0, 0, 0.5)
    self.f.base:SetScale(theme.default.scale or 1)
    self.f.cast:SetScript('OnUpdate', nil)
    self:Hide()
end

local function Hide(self) self.f.base:Hide(); self.f.cast:Hide() end
local function ClearAllPoints(self) self.f.base:ClearAllPoints() end
local function SetParent(self, parent) self.f.base:SetParent(parent) end
local function SetPoint(self, anc, parent, panc, x, y) self.f.base:SetPoint(anc, parent, panc, x, y) end

function ctrl.plates:fn(np)
    np.Draw = Draw
    np.UpdateHealth = UpdateHealth
    np.UpdateTarget = UpdateTarget
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
    for i=1,40 do
        if not ctrl.np[i].nameplate then
            self:assign(ctrl.np[i], nameplate)
            return
        end
    end
end

-- Element Constructors

function ctrl.plates:opt(v)
    local opt = {}
    cp(opt, theme.default)
    cp(opt, v)
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
    np:Reset()
end

-- Setup & Generation

function ctrl.plates:redraw()
    for i=1,40 do
        if ctrl.np[i].nameplate then ctrl.np[i].nameplate.UnitFrame:Hide() end
    end
end

function ctrl.plates:new(i)
    local np = {}
    cp(np, template)
    cp(np, np.default)
    self:build(np)
    return np
end

function ctrl.plates:setup()
    ctrl.np = ctrl.np or {}
    for i=1,40 do ctrl.np[i] = ctrl.np[i] or self:new(i) end
end

ctrl.plates:init()
