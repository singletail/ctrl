--[[ ctrl - tgt.lua - t@wse.nyc - 8/7/24 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'tgt',
    color = c.g,
    symbol = s.target,
    options = {
        numFontStrings = 12,
        timers = {
            1
        },
        events = {
            'PLAYER_TARGET_CHANGED',
        },
        frame = {
            name = 'ctrltgt',
            target = ctrl.power.f.main,
            isClipsChildren = 1,
        },
    }
}

ctrl.tgt = ctrl.mod:new(mod)

ctrl.tgt.db = {
    player = {},
    mob = {},
    target = {},
    targetType = nil,
}

local playerTable = {}
local mobTable = {}

local textures = {
    ['tbluebk'] = { target='main', t='LCDbig.png', l=-8, al=0.6 },
}

function ctrl.tgt:createFontStrings()
    local iconSettings = {t='', target='main', fontFile=ctrl.prefs.mod.tgt.font.file, fontSize=ctrl.prefs.mod.tgt.icon.size, x=12, y=-20, a=a.tl, pa=a.tl,}
    ctrl.tgt.fs['fsicon'] = ctrl.fs.new(ctrl.tgt, iconSettings)
    local defaultfs = {t='', target='main', fontFile=ctrl.prefs.mod.tgt.font.file, fontSize=ctrl.prefs.mod.tgt.font.size, x=0, y=0, a=a.t, pa=a.t, jH=a.c}
    for i=1, self.options.numFontStrings do
        local o = ctrl.cp(defaultfs)
        o.t="fs"..i
        o.y = ctrl.prefs.mod.tgt.font.top - ((ctrl.prefs.mod.tgt.font.spacing + ctrl.prefs.mod.tgt.font.size) * (i-1))
        ctrl.tgt.fs['fs'..i] = ctrl.fs.new(ctrl.tgt, o)
    end
end

function ctrl.tgt:makeRoomForIcon()
    local newX = (ctrl.prefs.mod.tgt.icon.size / 2)
    for i=1,3 do
        local fs = ctrl.tgt.fs['fs'..i]
        local y = fs:GetTop()
        fs:ClearAllPoints()
        fs:SetPoint(a.t, ctrl.tgt.f.main, a.t, newX, y)
    end
end

function ctrl.tgt:noIcon()
    for i=1,3 do
        local fs = ctrl.tgt.fs['fs'..i]
        local y = fs:GetTop()
        fs:ClearAllPoints()
        fs:SetPoint(a.t, ctrl.tgt.f.main, a.t, 0, y)
    end
end

local guildicon = {
    ["The Immortal Taint"]  = c.c .. '䀈',
    ["Tainted Angels"]      = c.p .. '㌦',
    ["Taintcraft"]          = c.o .. '䂭',
    ["Power Word Taint"]    = c.y .. '㍋',
    ["War Taint"]           = c.v .. '㎆',
    ["Taint of the Titans"] = c.b .. '㏛',
    ["Taint"]               = c.o .. '㏠',
    ["Bear Taint"]          = c.v .. '󱙵',
    ["Tainter Tots"]        = c.v .. '󱜚',
    ["Tainted Love"]        = c.v .. '㎡',
    ["Taint of Madness"]    = c.v .. '䅡',
    ["Taint No Thang"]      = c.v .. '〡',
    ["Spreading Taint"]     = c.v .. '㐃',
}

function ctrl.tgt:loaddbplayer(guid)
    wipe(ctrl.tgt.db.target)
    for k,v in pairs(ctrl.tgt.db.player[guid]) do
        ctrl.tgt.db.target[k] = v
    end
end

function ctrl.tgt:loaddbmob(guid)
    wipe(ctrl.tgt.db.target)
    for k,v in pairs(ctrl.tgt.db.mob[guid]) do
        ctrl.tgt.db.target[k] = v
    end
end

local selectionTypeString = {
    [0] = [[Hostile]],
    [1] = [[Unfriendly]],
    [2] = [[Neutral]],
    [3] = [[Friendly]],
    [4] = [[Player]],
    [5] = [[Player (Extended)]],
    [6] = [[Party]],
    [7] = [[Party (War Mode)]],
    [8] = [[Friend]],
    [9] = [[Dead]],
    [10] = [[Commentator Team 1]],
    [11] = [[Commentator Team 2]],
    [12] = [[Self]],
    [13] = [[Friendly (Battleground)]],
}


function ctrl.tgt:updatePlayer(guid) -- slow but constant
    ctrl.tgt.db.player[guid].inGroup = IsGUIDInGroup(guid)
    ctrl.tgt.db.player[guid].isDead = UnitIsDead('target')
    ctrl.tgt.db.player[guid].isGhost = UnitIsGhost('target')
    ctrl.tgt.db.player[guid].isAFK = UnitIsAFK('target')
    ctrl.tgt.db.player[guid].isDND = UnitIsDND('target')
    ctrl.tgt.db.player[guid].isConnected = UnitIsConnected('target')
    if ctrl.tgt.db.player[guid].inGroup then
        ctrl.tgt.db.player[guid].role = UnitGroupRolesAssigned('target')
    end
    local gn, gr, _, rr = GetGuildInfo('target')
    ctrl.tgt.db.player[guid].guild = gn
    ctrl.tgt.db.player[guid].guildRank = gr
    ctrl.tgt.db.player[guid].realm = rr

    if ctrl.tgt.db.player[guid].isFriend then
        ctrl.tgt.db.player[guid].icon = c.r..s.heart
    elseif ctrl.tgt.db.player[guid].role then
        ctrl.tgt.db.player[guid].icon = ctrl.tgt.db.player[guid].hexColor .. s[ctrl.tgt.db.player[guid].role]
    elseif guildicon[ctrl.tgt.db.player[guid].guild] then
        ctrl.tgt.db.player[guid].icon = guildicon[ctrl.tgt.db.player[guid].guild]
    else
        ctrl.tgt.db.player[guid].icon = nil
    end
end

function ctrl.tgt:updatePlayerOncePerSession(guid)
    -- NotifyInspect(unit) etc
end

function ctrl.tgt:updatePlayerFast(guid)
    -- Range
    ctrl.tgt.db.player[guid].inCombat = UnitAffectingCombat('target')
    ctrl.tgt.db.player[guid].target = UnitGUID('targettarget')
    ctrl.tgt.db.player[guid].targetName = UnitName('targettarget')
    if ctrl.tgt.db.player[guid].inCombat and UnitExists("target") and UnitExists(ctrl.tgt.db.player[guid].target) then
        local isTanking, status, scaledPercentage, rawPercentage, rawThreat = UnitDetailedThreatSituation('target', ctrl.tgt.db.player[guid].target)
        ctrl.tgt.db.player[guid].scaledPercentage = scaledPercentage
        ctrl.tgt.db.player[guid].isTanking = isTanking
    end
    ctrl.tgt.db.player[guid].health = UnitHealth('target')
    ctrl.tgt.db.player[guid].maxHealth = UnitHealthMax('target')
    ctrl.tgt.db.player[guid].healthPct = math.floor((ctrl.tgt.db.player[guid].health / ctrl.tgt.db.player[guid].maxHealth) * 100)
    ctrl.tgt.db.player[guid].range = ctrl.unitRange('target')
end

function ctrl.tgt:createnewplayer(guid)
    ctrl.tgt.db.player[guid] = {}
    ctrl.tgt.db.player[guid].guid = guid
    ctrl.tgt.db.player[guid].name = UnitName('target')
    ctrl.tgt.db.player[guid].displayName = UnitName('target')
    ctrl.tgt.db.player[guid].pvpName = UnitPVPName('target')
    ctrl.tgt.db.player[guid].race = UnitRace('target')
    ctrl.tgt.db.player[guid].class = UnitClass('target')
    ctrl.tgt.db.player[guid].level = UnitLevel('target')
    ctrl.tgt.db.player[guid].unitSex = UnitSex('target')
    ctrl.tgt.db.player[guid].isFriend = C_FriendList.IsFriend(guid)
    ctrl.tgt.db.player[guid].isIgnored = C_FriendList.IsIgnored('target')
    ctrl.tgt.db.player[guid].bnAccountInfo =  C_BattleNet.GetGameAccountInfoByGUID(guid)
    local red, green, blue, alpha = UnitSelectionColor('target', true)
    ctrl.tgt.db.player[guid].color = CreateColor( red, green, blue, alpha )
    ctrl.tgt.db.player[guid].hexColor = '|c' .. ctrl.tgt.db.player[guid].color:GenerateHexColor()
    ctrl.tgt.db.player[guid].selectionType = UnitSelectionType('target', true)
    ctrl.tgt.db.player[guid].selectionTypeString = selectionTypeString[ctrl.tgt.db.player[guid].selectionType]
end


function ctrl.tgt:loadplayer(guid)
    if ctrl.tgt.db.player.guid then
        self:loaddbplayer(guid)
    else
        self:createnewplayer(guid)
        self:loaddbplayer(guid)
    end
    ctrl.tgt.db.targetType = 'Player'
    ctrl.tgt.updatePlayerOncePerSession(ctrl.tgt, guid)
    ctrl.tgt.updatePlayer(ctrl.tgt, guid)
    ctrl.tgt.updatePlayerFast(ctrl.tgt, guid)
end

function ctrl.tgt:updateMobFast(guid)
    -- Range
    ctrl.tgt.db.mob[guid].inCombat = UnitAffectingCombat('target')
    ctrl.tgt.db.mob[guid].target = UnitGUID('targettarget')
    ctrl.tgt.db.mob[guid].targetName = UnitName('targettarget')
    if ctrl.tgt.db.mob[guid].inCombat then
        local isTanking, status, scaledPercentage, rawPercentage, rawThreat = UnitDetailedThreatSituation('player', 'target')
        ctrl.tgt.db.mob[guid].scaledPercentage = scaledPercentage
        ctrl.tgt.db.mob[guid].isTanking = isTanking
    end
    ctrl.tgt.db.mob[guid].health = UnitHealth('target')
    ctrl.tgt.db.mob[guid].maxHealth = UnitHealthMax('target')
    ctrl.tgt.db.mob[guid].healthPct = math.floor((ctrl.tgt.db.mob[guid].health / ctrl.tgt.db.mob[guid].maxHealth) * 100)
    ctrl.tgt.db.mob[guid].range = ctrl.unitRange('target')
end

function ctrl.tgt:createnewmob(guid)
    ctrl.tgt.db.mob[guid] = {}
    ctrl.tgt.db.mob[guid].guid = guid
    ctrl.tgt.db.mob[guid].name = UnitName('target')
    ctrl.tgt.db.mob[guid].displayName = UnitName('target')
    ctrl.tgt.db.mob[guid].race = UnitRace('target')
    ctrl.tgt.db.mob[guid].class = UnitClass('target')
    ctrl.tgt.db.mob[guid].level = UnitLevel('target')
    ctrl.tgt.db.mob[guid].effectiveLevel = UnitEffectiveLevel('target')
    ctrl.tgt.db.mob[guid].unitSex = UnitSex('target')

    ctrl.tgt.db.mob[guid].unitClassification = UnitClassification('target')
    ctrl.tgt.db.mob[guid].unitCreatureFamily = UnitCreatureFamily('target')
    ctrl.tgt.db.mob[guid].unitCreatureType = UnitCreatureType('target')

    local red, green, blue, alpha = UnitSelectionColor('target', true)
    ctrl.tgt.db.mob[guid].color = CreateColor( red, green, blue, alpha )
    ctrl.tgt.db.mob[guid].hexColor = '|c' .. ctrl.tgt.db.mob[guid].color:GenerateHexColor()

    ctrl.tgt.db.mob[guid].selectionType = UnitSelectionType('target', true)
    ctrl.tgt.db.mob[guid].selectionTypeString = selectionTypeString[ctrl.tgt.db.mob[guid].selectionType]

    local unitType, _, _, _, _, npcId, spawnUid = strsplit("-", guid)
    ctrl.tgt.db.mob[guid].spawnUid = spawnUid
    ctrl.tgt.db.mob[guid].npcId = npcId
    ctrl.tgt.db.mob[guid].unitType = unitType
    if unitType == "Creature" or unitType == "Vehicle" then
        local sID, sTime = ctrl.tgt:spawnId(spawnUid)
        ctrl.tgt.db.mob[guid].spawnId = sID
        ctrl.tgt.db.mob[guid].spawnTime = sTime
        if sID and sID > 0 then
            ctrl.tgt.db.mob[guid].displayName = string.format('%s %d', ctrl.tgt.db.mob[guid].name, sID)
        end
    end
    ctrl.tgt.db.mob[guid].range = 0
end

function ctrl.tgt:spawnId(spawnUid)
    local spawnEpoch = GetServerTime() - (GetServerTime() % 2^23)
    local spawnEpochOffset = bit.band(tonumber(string.sub(spawnUid, 5), 16), 0x7fffff)
    local spawnIndex = bit.rshift(bit.band(tonumber(string.sub(spawnUid, 1, 5), 16), 0xffff8), 3)
    local spawnTime = spawnEpoch + spawnEpochOffset
    return spawnIndex, spawnTime
end

function ctrl.tgt:loadmob(guid)
    if ctrl.tgt.db.mob.guid then
        self:loaddbmob(guid)
    else
        self:createnewmob(guid)
        self:loaddbmob(guid)
    end
    ctrl.tgt.db.targetType = 'Mob'
end


function ctrl.tgt:checktarget()
    local guid = UnitGUID('target')
    if ctrl.tgt.db.target and ctrl.tgt.db.target.guid == guid then return end
    if UnitIsPlayer('target') then
        self:loadplayer(guid)
    else
        self:loadmob(guid)
    end
end

function ctrl.tgt:drawPlayer(guid)
    wipe(playerTable)
    playerTable[1] = tostring(ctrl.tgt.db.player[guid].hexColor) .. tostring(ctrl.tgt.db.player[guid].pvpName)
    playerTable[2] = c.g..tostring(ctrl.tgt.db.player[guid].guild or '')
    playerTable[3] = c.b..tostring(ctrl.tgt.db.player[guid].guildRank or '')

    local classString = ''
    if ctrl.tgt.db.player[guid].role then
        classString = ctrl.tgt.db.player[guid].role .. ' '
    end
    playerTable[4] = ''
    playerTable[5] = classString .. c.y..tostring(ctrl.tgt.db.player[guid].level) .. ' ' .. c.g..tostring(ctrl.tgt.db.player[guid].race) .. ' ' .. c.b..tostring(ctrl.tgt.db.player[guid].class)
    playerTable[6] = c.o .. 'Target: ' .. c.y .. (UnitName('targettarget') or '')
    local hStr = ctrl.healthPctStr(ctrl.healthPct('target'))
    local combatStr = ctrl.tgt.db.player[guid].inCombat and c.p..' Combat' or ''
    local tankingStr = ctrl.tgt.db.player[guid].isTanking and c.r..' Tanking' or ''
    local scaledPercentageStr = ctrl.tgt.db.player[guid].scaledPercentage and c.o .. ctrl.tgt.db.player[guid].scaledPercentage .. '%' or ''
    local deadStr = ctrl.tgt.db.player[guid].isDead and c.r..' Dead' or ''
    local ghostStr = ctrl.tgt.db.player[guid].isGhost and c.a..' Ghost' or ''
    local afkStr = ctrl.tgt.db.player[guid].isAFK and c.y..' AFK' or ''
    local dndStr = ctrl.tgt.db.player[guid].isDND and c.o..' DND' or ''
    local offlineStr = ctrl.tgt.db.player[guid].isConnected and '' or c.w..' Offline'
    playerTable[7] = c.o .. 'Range: ' .. c.y .. tostring(ctrl.tgt.db.player[guid].range)
    playerTable[8] = hStr .. combatStr .. tankingStr .. scaledPercentageStr .. deadStr .. ghostStr .. afkStr .. dndStr .. offlineStr
    playerTable[9] = ''
    playerTable[10] = ''
    playerTable[11] = ''
    playerTable[12] = tostring(guid)
    for i=1, ctrl.tgt.options.numFontStrings do
        ctrl.tgt.fs['fs'..i]:SetText(playerTable[i] or '?')
    end
    if ctrl.tgt.db.player[guid].icon then
        self:makeRoomForIcon()
        ctrl.tgt.fs['fsicon']:SetText(ctrl.tgt.db.player[guid].icon)
    else
        ctrl.tgt.fs['fsicon']:SetText('')
        self:noIcon()
    end
end

function ctrl.tgt:drawMob(guid)
    wipe(mobTable)
    mobTable[1] = tostring(ctrl.tgt.db.mob[guid].hexColor) .. tostring(ctrl.tgt.db.mob[guid].displayName)
    
    local ucStr = ctrl.tgt.db.mob[guid].unitClassification and ctrl.firstToUpper(ctrl.tgt.db.mob[guid].unitClassification) .. ' ' or ''
    local utStr = ctrl.tgt.db.mob[guid].unitType and ctrl.tgt.db.mob[guid].unitType .. ' ' or ''
    local ucfStr = ctrl.tgt.db.mob[guid].unitCreatureFamily and tostring(ctrl.tgt.db.mob[guid].unitCreatureFamily) .. ' ' or ''
    local uctStr = ctrl.tgt.db.mob[guid].unitCreatureType and ctrl.tgt.db.mob[guid].unitCreatureType ~= ctrl.tgt.db.mob[guid].unitCreatureFamily and tostring(ctrl.tgt.db.mob[guid].unitCreatureType) or ''
    mobTable[2] = ucStr .. utStr .. ucfStr .. uctStr

    local levelStr = c.y..tostring(ctrl.tgt.db.mob[guid].level)
    if ctrl.tgt.db.mob[guid].level ~= ctrl.tgt.db.mob[guid].effectiveLevel then levelStr = levelStr .. c.o.. ' (' .. tostring(ctrl.tgt.db.mob[guid].effectiveLevel) .. ')' end
    if ctrl.tgt.db.mob[guid].race then levelStr = levelStr .. ' ' .. c.g..ctrl.tgt.db.mob[guid].race end
    if ctrl.tgt.db.mob[guid].class then levelStr = levelStr .. ' ' .. c.v..ctrl.tgt.db.mob[guid].class end
    mobTable[3] = levelStr
    mobTable[4] = ''

    local hStr = ctrl.healthPctStr(ctrl.healthPct('target'))
    local combatStr = ctrl.tgt.db.mob[guid].inCombat and c.p..' Combat' or ''
    local tankingStr = ctrl.tgt.db.mob[guid].isTanking and c.r..' Tanking' or ''
    local scaledPercentageStr = ctrl.tgt.db.mob[guid].scaledPercentage and c.o .. ctrl.tgt.db.mob[guid].scaledPercentage .. '%' or ''
    mobTable[5] = hStr .. combatStr .. tankingStr .. scaledPercentageStr

    local tgtStr = UnitName('targettarget') and c.o .. 'Target: ' .. c.y .. UnitName('targettarget') or ''
    mobTable[6] = tgtStr
    mobTable[7] = c.o .. 'Range: ' .. c.y .. tostring(ctrl.tgt.db.mob[guid].range)

    local t1, t2, t3, symbol = '', '', '', ''
    if _G.CtrlDB then
        local entry = _G.CtrlDB[tonumber(ctrl.tgt.db.mob[guid].npcId)]
        if entry then
            entry.t1 = entry.t1 or ''
            entry.t2 = entry.t2 or ''
            entry.t3 = entry.t3 or ''
            entry.symbol = entry.symbol or ''
            self:makeRoomForIcon()
            local col = entry.color or c.w
            t1 = col..entry.t1 or ''
            t2 = col..entry.t2 or ''
            t3 = col..entry.t3 or ''
            symbol = col..entry.symbol or ''
            ctrl.tgt.fs['fsicon']:SetText(symbol)
        else
            ctrl.tgt.fs['fsicon']:SetText('')
            self:noIcon()
        end
    end

    mobTable[8] = t1
    mobTable[9] = t2
    mobTable[10] = t3
    mobTable[11] = ''
    mobTable[12] = c.a..'NpcId: '..(ctrl.tgt.db.mob[guid].npcId or '?')
    for i=1,self.options.numFontStrings do
        if ctrl.tgt.fs['fs'..i] then ctrl.tgt.fs['fs'..i]:SetText(mobTable[i]) end
    end
end

function ctrl.tgt:drawEmpty()
    for i=1,ctrl.tgt.options.numFontStrings do
        if ctrl.tgt.fs['fs'..i] then ctrl.tgt.fs['fs'..i]:SetText('-') end
    end
end

function ctrl.tgt:update()
    local guid = UnitGUID('target')
    if not guid then
        wipe(ctrl.tgt.db.target)
        ctrl.tgt.db.targetType = nil
        return
    end

    if ctrl.tgt.db.target and ctrl.tgt.db.target.guid == guid then
        if ctrl.tgt.db.targetType == 'Player' then
            self:updatePlayerFast(guid)
        else
            self:updateMobFast(guid)
        end
    else
        self:checktarget()
    end

    if ctrl.tgt.db.targetType == 'Player' then
        self:drawPlayer(guid)
    elseif ctrl.tgt.db.targetType == 'Mob' then
        self:drawMob(guid)
    else
        self:drawEmpty()
    end
end

function ctrl.tgt:tick(interval)
    ctrl.tgt:update()
end

function ctrl.tgt.PLAYER_TARGET_CHANGED()
    ctrl.tgt:update()
end

function ctrl.tgt:prefs()
    self.options.frame.w = ctrl.prefs.mod.tgt.frame.width
    self.options.frame.h = ctrl.prefs.ui.height
end

function ctrl.tgt:setup()
    self:prefs()
    self.f.main = ctrl.frame:new(self.options.frame)
    ctrl.tx.generate(ctrl.tgt, textures)
    self:createFontStrings()
    self:registerCtrlFrame(3, self.f.main)
end

ctrl.tgt:init()
