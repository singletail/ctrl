--[[ ctrl - nameplates.lua - t@wse.nyc - 27 July 2025 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'nameplates',
    color = c.g,
    symbol = s.wipe,
    options = {
        events = {
            'NAME_PLATE_CREATED',
            'NAME_PLATE_UNIT_ADDED',
            'NAME_PLATE_UNIT_REMOVED',
            'UNIT_HEALTH',
        },
    },
}

ctrl.nameplates = ctrl.mod:new(mod)

--[[

TODO:

- Fix computing health bar width
- Redo health event trigger
- Icon
- Target
- New graphics (select?)
- guid caching
- inspect?


]]

local default_cp = {
    f = {},
    tx = {},
    fs = {},
    guid = nil,
    unit = nil,
    isPlayer = nil,
    icon = '',
    unitName = nil,
    unitPVPName = nil,
    displayName = nil,
    unitClass = nil,
    unitReaction = nil,
    classification = nil,
    target = nil,
    color = { 1, 1, 1, 1 },
    hex = c.w,
    guildName = nil,
    guildRank = nil,
    health = 0,
    healthMax = 1,
    healthPct = 100,
    npcId = nil,
    spawnIndex = nil,
    t1 = nil,
    t2 = nil,
    creatureType = nil,
    creatureFamily = nil,
}


-- Update Events

local function UpdateNPC(self) --every frame
    if UnitIsUnit(self.unit, 'target') then
        self.tx.frame:SetVertexColor(0.8, 0.8, 0.2, 1)
        self.tx.frame:SetAlpha(1)
        self.tx.healthBar:SetAlpha(0.8)
        self.tx.cap:SetAlpha(0.8)
        self.f.main:SetScale(0.8)
    elseif UnitAffectingCombat(self.unit) then
        self.tx.frame:SetVertexColor(0.8, 0.2, 0.2, 1)
        self.tx.frame:SetAlpha(0.5)
        self.tx.healthBar:SetAlpha(0.7)
        self.tx.cap:SetAlpha(0.7)
        self.f.main:SetScale(0.7)
    else
        self.tx.frame:SetVertexColor(1, 1, 1, 1)
        self.tx.frame:SetAlpha(0.5)
        self.tx.healthBar:SetAlpha(0.6)
        self.tx.cap:SetAlpha(0.6)
        self.f.main:SetScale(0.6)
    end

    if UnitExists(self.unit..'target') then
        self.target = UnitName(self.unit..'target')
        if UnitIsUnit(self.target, 'player') then self.target = c.y..'㍡ '..self.target end
    else
        self.target = ''
    end
    self.fs.fs6:SetText(self.target or '')

end

function ctrl.nameplates.UNIT_HEALTH(evt)
    local np = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not np or not np.cp then return nil end
    np.cp:UpdateHealth()
end

local function Reset(self)
    self.f.main:SetScript('OnUpdate', nil)
    self.unit = nil
    self.guid = nil
    self.icon = ''
    self.isPlayer = nil
    self.unitName = nil
    self.unitPVPName = nil
    self.unitClass = nil
    self.unitReaction = nil
    self.classification = nil
    self.target = nil
    self.color = { 1, 1, 1, 1 }
    self.hex = c.w
    self.guildName = nil
    self.guildRank = nil
    self.health = 0
    self.healthMax = 1
    self.healthPct = 100
    self.npcId = nil
    self.spawnIndex = nil
    self.t1 = nil
    self.t2 = nil
    self.creatureType = nil
    self.creatureFamily = nil
    self.fs.icon:SetText('')
    self.fs.fs1:SetText('')
    self.fs.fs2:SetText('')
    self.fs.fs3:SetText('')
    self.fs.fs4:SetText('')
    self.fs.fs5:SetText('')
    self.fs.fs6:SetText('')
    self.f.main:Hide()
end

local function SetPlayerIcon(self)
    if C_FriendList.IsFriend(self.guid) then 
        self.hex = c.p
        self.icon = c.p..'㎠'
    elseif s[self.guildName] then 
        self.icon = c.c..s[self.guildName]
        self.hex = c.c
    elseif s[self.unitClass] then
        self.icon = c.w..s[self.unitClass]
        self.hex = c.w
    else
        self.icon = c.w..s.crit
    end
end

local function ConfigureNPC(self)
    self.isPlayer = nil

    local _, _, _, _, _, npcId, spawnId = strsplit("-", self.guid)
    self.npcId = tonumber(npcId)
    self.spawnIndex = bit.rshift(bit.band(tonumber(string.sub(spawnId, 1, 5), 16), 0xffff8), 3)
    self.classification = UnitClassification(self.unit)
    self.unitReaction = UnitReaction(self.unit, 'player')
    self.creatureType = UnitCreatureType(self.unit)
    self.creatureFamily = UnitCreatureFamily(self.unit)
    if self.creatureType == self.creatureFamily then self.creatureFamily = nil end

    if ctrl.db[self.npcId] then
        local db = ctrl.db[self.npcId]
        if db.s then self.icon = db.s end
        if db.c then self.color = db.c end
        if db.hex then self.hex = db.hex end
        if db.t1 then self.t1 = db.t1 end
        if db.t2 then self.t2 = db.t2 end
    elseif UnitIsEnemy('player', self.unit) then
        self.color = c.enemy[self.classification] or c.rgba.black
        self.icon = c.w..s[self.classification] or c.w..s.eightball
    else
        self.color = c.reaction[self.unitReaction] or c.rgba.black
        self.icon = c.w..s.reaction[self.unitReaction] or c.w..s.eightball
    end

    if self.spawnIndex and tonumber(self.spawnIndex) > 0 then
        self.displayName = string.format('%s%s %d', self.hex, self.unitName, self.spawnIndex)
    else
        self.displayName = self.hex .. (self.unitName or 'Unknown')
    end

    self.fs.fs1:SetText(self.displayName)
    self.fs.icon:SetText(self.icon)

    if self.t1 then
        self.fs.fs2:SetText(self.t1)
    else
        self.fs.fs2:SetText(tostring(self.creatureType) .. ' - ' .. tostring(self.creatureFamily))
    end

    if self.t2 then
        self.fs.fs3:SetText(self.t2)
    else
        self.fs.fs3:SetText('npcId ' .. self.npcId)
    end

    self.tx.healthBar:SetVertexColor(self.color[1], self.color[2], self.color[3], self.color[4])
end

local function ConfigurePlayer(self)
    self.isPlayer = 1
    self.unitPVPName = UnitPVPName(self.unit)
    self.unitClass = select(2, UnitClass(self.unit))
    self.color = c.class[self.unitClass] or c.rgba.black
    local guildName, guildRankName = GetGuildInfo(self.unit)
    self.guildName = guildName
    self.guildRank = guildRankName
    self:SetPlayerIcon()
    self.displayName = self.hex .. self.unitPVPName or self.unitName or 'Unknown'
end

local function SetUnit(self, unit)
    self.unit = unit
    self.guid = UnitGUID(unit)
    self.unitName = UnitName(unit)
    self.f.main:SetScale(1)
    if C_PlayerInfo.GUIDIsPlayer(self.guid) then
        self:ConfigurePlayer()
    else
        self:ConfigureNPC()
    end
    self:Refresh()
    self:UpdateHealth()
    self.f.main:SetScript('OnUpdate', function()
        self:Update()
    end)
end

local function UpdatePlayer(self)
    --
end



local function Update(self)
    if not self.unit then return end
    if self.isPlayer then
        self:UpdatePlayer()
    else
        self:UpdateNPC()
    end
end

local function UpdateHealth(self)
    if not self.unit then return end
    self.health = UnitHealth(self.unit) or 0
    self.healthMax = UnitHealthMax(self.unit) or 1
    self.healthPct = math.floor((self.health / self.healthMax) * 100)

    self.healthBarWidth = self.healthBarWidth or 168
    self.f.healthBar:SetWidth(self.healthPct * (self.healthBarWidth / 100))
    self.fs.fs4:SetText(string.format('%d%%', self.healthPct))
    self.fs.fs5:SetText(string.format('%.1f/%.1fm', self.health / 1000000, self.healthMax / 1000000))
end

local function Refresh(self)
    self.fs.icon:SetText(self.icon or '?')
    self.fs.fs1:SetText(self.displayName)
    if self.isPlayer then
        self.fs.fs2:SetText(self.guildName or '')
        self.fs.fs3:SetText(self.guildRank or '')
    end
    self.tx.cap:SetVertexColor(self.color[1], self.color[2], self.color[3], self.color[4])
    self.tx.healthBar:SetVertexColor(self.color[1], self.color[2], self.color[3], self.color[4])

    self:HideBlizzard()
    self.f.main:Show()
end

local function HideBlizzard(self)
    if not self.np.UnitFrame then return end
    self.np.UnitFrame:Hide()
end

--

local theme = { --160
    width = 160,
    height = 24,
    scale = 1,
    frames = {
        ['healthBar'] = { w=147, h=22, x=12, y=-1, a=a.tl, pa=a.tl },
        ['top'] = { w=160, h=24, x=0, y=0, a=a.tl, pa=a.tl },
    },
    textures = {
        ['bk'] = { t='320_bk.png', l=-7, al=0.6 },
        ['cap'] = { t='320_cap_flat.png', h=24, w=12, a=a.tl, pa=a.tl, x=0, y=0, l=-6, al=0.5 },
        ['healthBar'] = { t='320_hbar_flat.png', target='healthBar', l=-6, al=0.5 },
        ['shadow'] = { t='320_shadow.png', target='top', w=167, h=30, x=0, y=0, l=-5, al=0.6 },
        ['frame'] = { t='320_frame.png', target='top', l=-4, al=0.5 },
        ['glow'] = { t='320_glow.png', target='top', w=167, h=30, a=a.c, x=0, y=0, pa=a.c, l=-2, al=0.1 },
    },
    fontstrings = {
        ['icon'] = { fontFile='Prompt-Regular', fontSize=13, t=s.ghost, target='top', x=-1, y=-1, a=a.tl, pa=a.tl, w=24, h=24, jH='CENTER', jV='MIDDLE' },
        ['fs1'] = { fontFile='Prompt-Medium', fontSize=7, t="", target='top', w=120, h=7, x=20, y=-1, a=a.tl, pa=a.tl },
        ['fs2'] = { fontFile='Prompt-Regular', fontSize=7, t="", target='top', w=100, h=7, x=20, y=-8, a=a.tl, pa=a.tl },
        ['fs3'] = { fontFile='Prompt-Regular', fontSize=7, t="", target='top', w=60, h=7, x=20, y=-15, a=a.tl, pa=a.tl },
        ['fs4'] = { fontFile='Prompt-Regular', fontSize=7, t="", target='top', h=7, w=26, x=-2, y=-1, a=a.tr, pa=a.tr, jH='RIGHT' },
        ['fs5'] = { fontFile='Prompt-Regular', fontSize=7, t="", target='top', h=7, w=40, x=-2, y=-8, a=a.tr, pa=a.tr, jH='RIGHT' },
        ['fs6'] = { fontFile='Prompt-Regular', fontSize=7, t="", target='top', h=7, w=80, x=-2, y=-15, a=a.tr, pa=a.tr, jH='RIGHT' },
    },
}



function ctrl.nameplates:addFrames(cp)
    for k, v in pairs(theme.frames) do
        local opt = ctrl.cp(v)
        opt.target = opt.target or 'main'
        if type(opt.target) == 'string' then opt.target = cp.f[opt.target] end
        cp.f[k] = ctrl.frame.new(self, opt)
    end
    cp.healthBarWidth = theme.frames.healthBar.w
end

function ctrl.nameplates:addTextures(cp)
    for k, v in pairs(theme.textures) do
        local opt = ctrl.cp(v)
        opt.target = opt.target or 'main'
        if type(opt.target)=='string' then opt.target = cp.f[opt.target] end
        opt.path = opt.path or ctrl.p.np
        cp.tx[k] = ctrl.tx.new(self, opt)
    end
end

function ctrl.nameplates:addFontStrings(cp)
    for k, v in pairs(theme.fontstrings) do
        local opt = ctrl.cp(v)
        opt.target = opt.target or 'main'
        if type(opt.target) == 'string' then opt.target = cp.f[opt.target] end
        cp.fs[k] = ctrl.fs.new(self, opt)
    end
end

function ctrl.nameplates:addFunctions(cp)
    cp.SetUnit = SetUnit
    cp.ConfigurePlayer = ConfigurePlayer
    cp.ConfigureNPC = ConfigureNPC
    cp.Reset = Reset
    cp.UpdateHealth = UpdateHealth
    cp.HideBlizzard = HideBlizzard
    cp.Refresh = Refresh
    cp.SetPlayerIcon = SetPlayerIcon
    cp.Update = Update
    cp.UpdateNPC = UpdateNPC
    cp.UpdatePlayer = UpdatePlayer
end

function ctrl.nameplates:addComponents(cp)
    self:addFrames(cp)
    self:addTextures(cp)
    self:addFontStrings(cp)
    self:addFunctions(cp)
end

function ctrl.nameplates:create(np)
    local cp = ctrl.cp(default_cp)
    local opt = { target=np, w=theme.width, h=theme.height, a=a.c, pa=a.c }
    cp.f.main = ctrl.frame.new(self, opt)
    self:addComponents(cp)
    cp.f.main:SetScale(theme.scale)
    ctrl.nameplate[#ctrl.nameplate+1] = cp
    np.cp = cp
    cp.np = np
    self:debug('Nameplate created (' .. tostring(#ctrl.nameplate) .. ')')
end

--

function ctrl.nameplates.NAME_PLATE_UNIT_REMOVED(evt)
    local np = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not np or not np.cp then return nil end
    np.cp:Reset()
end

function ctrl.nameplates.NAME_PLATE_CREATED(evt)
    ctrl.nameplates:create(evt[1])
end

function ctrl.nameplates.NAME_PLATE_UNIT_ADDED(evt)
    local np = C_NamePlate.GetNamePlateForUnit(evt[1])
    if not np or not np.cp then return nil end
    np.cp:SetUnit(evt[1])
end

local hookHealth = function(unitFrame)
    local np = unitFrame:GetParent()
    if not np or not np.cp or not np.cp.unit then return end
    ctrl.nameplates:debug('UNIT_HEALTH hook for ' .. np.cp.unit)
    np.cp:UpdateHealth()
end

function ctrl.nameplates:hooks()
    hooksecurefunc("CompactUnitFrame_UpdateHealth", hookHealth)
end

function ctrl.nameplates:setup()
    ctrl.nameplate = ctrl.nameplate or {}
    --self:hooks()
end

ctrl.nameplates:init()
