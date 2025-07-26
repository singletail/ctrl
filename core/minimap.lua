--[[ ctrl - minimap.lua - t@wse.nyc - 8/7/24 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a, p = ctrl.c, ctrl.s, ctrl.a, ctrl.p

local mod = {
    name = 'minimap',
    color = c.v,
    symbol = s.tx,
    options = {
        frame = {
            name = 'clock',
            w = 1024,
            h = 128,
            a = a.tr,
            pa = a.tr,
            x = -60,
            y = -60,
            isMovable = nil,
            isResizable = nil,
        },
        events = {
            'PLAYER_ENTERING_WORLD',
            'ZONE_CHANGED',
            'ZONE_CHANGED_INDOORS',
            'PLAYER_STARTED_MOVING',
            'PLAYER_STOPPED_MOVING',
            'PLAYER_STARTED_TURNING',
            'PLAYER_STOPPED_TURNING',
            'UI_SCALE_CHANGED',
            'GARRISON_SHOW_LANDING_PAGE',
            'TAXI_NODE_STATUS_CHANGED',
        },
        timers = {
            1,
        }
    },
    zone = s.question,
    subzone = s.question,
    x = 0,
    y = 0,
}

ctrl.minimap = ctrl.mod:new(mod)

ctrl.minimap.mode = 0

local subframes = {
    ['loc'] = { target = 'main', w = 300, h = 400, strata = 'BACKGROUND', a=a.tl, pa=a.tl, x=0, y=0 },
}

local textures = {
    ['loctx'] = { target = 'loc', t = 'bluebk_full_256', path = ctrl.p.tx, l = -6 },
    ['ct'] = { t = 'pride_t', path = p.ux, l = -6 },
    ['cl'] = { t = 'pride_l', path = p.ux, l = -6 },
    ['cr'] = { t = 'pride_r', path = p.ux, l = -6 },
    ['cb'] = { t = 'pride_b', path = p.ux, l = -6 },
    ['t'] = { target = Minimap, t = 'pride_t', path = p.ux, l = -6 },
    ['l'] = { target = Minimap, t = 'pride_l', path = p.ux, l = -6 },
    ['r'] = { target = Minimap, t = 'pride_r', path = p.ux, l = -6 },
    ['b'] = { target = Minimap, t = 'pride_b', path = p.ux, l = -6 },
    ['lt'] = { target = 'loc', t = 'pride_t', path = p.ux, l = -6 },
    ['ll'] = { target = 'loc', t = 'pride_l', path = p.ux, l = -6 },
    ['lr'] = { target = 'loc', t = 'pride_r', path = p.ux, l = -6 },
    ['lb'] = { target = 'loc', t = 'pride_b', path = p.ux, l = -6 },
}

local fontstrings = {
    ['fsTime'] = { target = 'main', t = '', fontFile = 'Prompt-Bold.ttf', fontSize = 24, a = a.tl, pa = a.t, x=-50, y=-12},
    ['fsDate'] = { target = 'main', t = '', fontFile = 'Prompt-Medium.ttf', fontSize = 14, a = a.b, pa = a.b, x = 0, y = 6 },
    ['mapID'] = { target = 'loc', t = '', fontFile = 'Prompt-Regular.ttf', fontSize = 13, a = a.t, pa = a.t, x=0, y=-4},
    ['zone'] = { target = 'loc', t = '', fontFile = 'Prompt-Regular.ttf', fontSize = 18, a = a.t, pa = a.t, x = 0, y = -19 },
    ['subzone'] = { target = 'loc', t = '', fontFile = 'Prompt-Regular.ttf', fontSize = 12, a = a.t, pa = a.t, x = 0, y = -36 },
    ['coords'] = { target = 'loc', t = '', fontFile = 'SpaceMono-Bold.ttf', fontSize = 12, a = a.b, pa = a.b, x = 0, y = 14 },
    ['facing'] = { target = 'loc', t = '', fontFile = 'SpaceMono-Bold.ttf', fontSize = 12, a = a.b, pa = a.b, x = 0, y = 1 },
}

local timeTable = ctrl.newTable('')
local dateTable = ctrl.newTable('')

timeTable[1] = c.w
dateTable[1] = c.o


function ctrl.minimap:resize(frame, w, h)
    local framestoresize = {
        [0] = {
            { f = 'main', anchors = {{ t = Minimap, a = a.tl, pa = a.tl, x = 0, y = 64 }, { t = Minimap, a = a.br, pa = a.tr, x = 0, y = 8 }} },
            { f = 'loc', anchors = {{ t = Minimap, a = a.tl, pa = a.bl, x = 0, y = -8 }, { t = Minimap, a = a.br, pa = a.br, x = 0, y = -86 }} },
            { f = MinimapCluster, w=600, h=600, anchors={{ t = UIParent, a = a.tr, pa = a.tr, x = -16, y = -72 }, } },
            { f = MinimapCluster.MinimapContainer, w=600, h=600, anchors={{ t = MinimapCluster, a = a.tr, pa = a.tr, x = 0, y = 0 }, } },
            { f = Minimap, scale=1.5, w=400, h=400, anchors={{ t = MinimapCluster.MinimapContainer, a = a.tr, pa = a.tr, x = 0, y = 0 }, } },
            { f = MinimapBackdrop, w=600, h=600, anchors={{ t = MinimapCluster, a = a.tr, pa = a.tr, x = 0, y = 0 }, } },
            { f = MinimapCompassTexture, alpha=0 },
        },
        [1] = {
            { f = 'main', alpha=0,},
            { f = MinimapCluster, w=1200, h=800, anchors={{ t = UIParent, a = a.c, pa = a.c, x = 0, y = 0 }, } },
            { f = MinimapCluster.MinimapContainer, w=1200, h=800, anchors={{ t = MinimapCluster, a = a.c, pa = a.c, x = 0, y = 0 }, } },
            { f = Minimap, alpha = 0.5, scale=2, w=600, h=600, anchors={{ t = MinimapCluster.MinimapContainer, a = a.c, pa = a.c, x = 0, y = 0 }, } },
            { f = MinimapBackdrop, alpha = 0, w=1200, h=800, anchors={{ t = MinimapCluster, a = a.c, pa = a.c, x = 0, y = 0 }, } },
            { f = MinimapCompassTexture, alpha=0 },
        }
    }

    local frameTable = framestoresize[ctrl.minimap.mode]
    for _, frameEntry in ipairs(frameTable) do
        local f = frameEntry.f
        if type(f) == 'string' then f = ctrl.minimap.f[f] end
        f:ClearAllPoints()
        if frameEntry.w then f:SetWidth(frameEntry.w) end
        if frameEntry.h then f:SetHeight(frameEntry.h) end
        if frameEntry.alpha then f:SetAlpha(frameEntry.alpha) end
        if frameEntry.scale then f:SetScale(frameEntry.scale) end
        if frameEntry.anchors then
            for _, anch in ipairs(frameEntry.anchors) do
                if type(anch.t) == 'string' then anch.t = ctrl.minimap.f[anch.t] end
                f:SetPoint(anch.a, anch.t, anch.pa, anch.x, anch.y)
            end
        end
    end
    local tx = {
        [0] = {
            ['ct'] = { alpha = 1, anchors = { { t = self.f.main, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.tr, x = 1, y = -1 }} },
            ['cl'] = { alpha = 1, anchors = {{ t = self.f.main, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.bl, x = 0, y = -1 }} },
            ['cr'] = { alpha = 1, anchors = {{ t = self.f.main, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = self.f.main, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['cb'] = { alpha = 1, anchors = {{ t = self.f.main, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['t'] = { alpha = 1, anchors = {{ t = Minimap, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.tr, x = 1, y = -1 }} },
            ['l'] = { alpha = 1, anchors = {{ t = Minimap, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.bl, x = 0, y = -1 }} },
            ['r'] = { alpha = 1, anchors = {{ t = Minimap, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = Minimap, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['b'] = { alpha = 1, anchors = {{ t = Minimap, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['lt'] = { alpha = 1, anchors = {{ t = self.f.loc, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.tr, x = 1, y = -1 }} },
            ['ll'] = { alpha = 1, anchors = {{ t = self.f.loc, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.bl, x = 0, y = -1 }} },
            ['lr'] = { alpha = 1, anchors = {{ t = self.f.loc, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = self.f.loc, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['lb'] = { alpha = 1, anchors = {{ t = self.f.loc, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.br, x = 1, y = -1 }} },
        },
        [1] = {
            ['ct'] = { alpha = 0, anchors = { { t = self.f.main, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.tr, x = 1, y = -1 }} },
            ['cl'] = { alpha = 0, anchors = {{ t = self.f.main, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.bl, x = 0, y = -1 }} },
            ['cr'] = { alpha = 0, anchors = {{ t = self.f.main, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = self.f.main, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['cb'] = { alpha = 0, anchors = {{ t = self.f.main, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['t'] = { alpha = 0, anchors = {{ t = Minimap, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.tr, x = 1, y = -1 }} },
            ['l'] = { alpha = 0, anchors = {{ t = Minimap, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.bl, x = 0, y = -1 }} },
            ['r'] = { alpha = 0, anchors = {{ t = Minimap, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = Minimap, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['b'] = { alpha = 0, anchors = {{ t = Minimap, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['lt'] = { alpha = 0, anchors = {{ t = self.f.loc, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.tr, x = 1, y = -1 }} },
            ['ll'] = { alpha = 0, anchors = {{ t = self.f.loc, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.bl, x = 0, y = -1 }} },
            ['lr'] = { alpha = 0, anchors = {{ t = self.f.loc, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = self.f.loc, a = a.br, pa = a.br, x = 1, y = -1 }} },
            ['lb'] = { alpha = 0, anchors = {{ t = self.f.loc, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.br, x = 1, y = -1 }} },
        },
    }

    local textureTable = tx[ctrl.minimap.mode]
    for textureName, v in pairs(textureTable) do
        ctrl.minimap.tx[textureName]:ClearAllPoints()
        if v.alpha then ctrl.minimap.tx[textureName]:SetAlpha(v.alpha) end
        if v.anchors then
            for _, x in ipairs(v.anchors) do
                ctrl.minimap.tx[textureName]:SetPoint(x.a, x.t, x.pa, x.x, x.y)
            end
        end
    end

    if ctrl.minimap.mode == 0 then
        C_CVar.SetCVar('rotateMinimap', 0)
        Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
    else
        C_CVar.SetCVar('rotateMinimap', 1)
    end
end


function ctrl.minimap:UpdateClock()
    timeTable[2] = date(" %I"):gsub(' 0', ' ')
    timeTable[3] = date(":%M:%S ")
    ctrl.minimap.fs.fsTime:SetText(table.concat(timeTable))
    dateTable[2] = date('%A, %B %d, %Y'):gsub(' 0', ' ')
    ctrl.minimap.fs.fsDate:SetText(table.concat(dateTable))
end

local mapTypeStr = {
    [0] = 'Cosmic',
    [1] = 'World',
    [2] = 'Continent',
    [3] = 'Zone',
    [4] = 'Dungeon',
    [5] = 'Micro',
    [6] = 'Orphan',
}

function ctrl.minimap:UpdateLocNew()
    local mapID = C_Map.GetBestMapForUnit('player')
    local mapInfo = mapID and C_Map.GetMapInfo(mapID)
    if not mapInfo then return end
    local parentMapInfo = mapInfo.parentMapID and C_Map.GetMapInfo(mapInfo.parentMapID)

    local minimapText = GetMinimapZoneText()
    minimapText = minimapText or ''
    self.fs.zone:SetText(c.c .. minimapText)

    local subzone = GetSubZoneText()
    subzone = subzone or ''
    if subzone == minimapText then subzone = '' end
    self.fs.subzone:SetText(c.p..subzone)

    local pos = C_Map.GetPlayerMapPosition(mapID, 'player')
    if pos then
        posX = pos.x or 0
        posY = pos.y or 0
        if self.fs.coords then self.fs.coords:SetText('ㄕ ' .. tostring(posX * 100) .. ', ' .. tostring(posY* 100)) end
    end

    local facing = GetPlayerFacing()
    facing = facing or 0
    facing = math.deg(facing)
    if self.fs.facing then self.fs.facing:SetText(c.v .. 'ㄒ ' .. tostring(facing)) end

    local mapString = c.r .. 'ㄧ '
    if parentMapInfo and parentMapInfo.name then mapString = mapString .. c.r .. parentMapInfo.name .. c.d .. ' ' end
    if mapInfo and mapInfo.name then mapString = mapString .. c.o .. mapInfo.name .. c.d end
    if mapID then mapString = mapString .. c.y .. ' #' .. tostring(mapID) end
    if mapInfo and mapInfo.mapType then mapString = mapString .. c.v .. ' (' .. mapTypeStr[mapInfo.mapType] .. ')' end
    if self.fs.mapID then self.fs.mapID:SetText(mapString) end
end

function ctrl.minimap:tick(interval, count)
    if interval == 1 then
        self:UpdateClock()
    else
        self:UpdateLocNew()
    end
end

function ctrl.minimap.setup(self)
    ctrl.minimap.f.main = ctrl.frame.new(ctrl.minimap, ctrl.minimap.options.frame)
    ctrl.frame.generate(ctrl.minimap, subframes)
    ctrl.tx.generate(ctrl.minimap, textures)
    ctrl.fs.generate(ctrl.minimap, fontstrings)
end

ctrl.minimap:init()

function ctrl.minimap:configureFrames()
    ExpansionLandingPageMinimapButton:SetScale(0.5)
end

function ctrl.minimap.PLAYER_ENTERING_WORLD()
    ctrl.minimap:UpdateClock()
    ctrl.minimap:UpdateLocNew()
end

function ctrl.minimap.PLAYER_STARTED_MOVING(evt)
    ctrl.timer.register(ctrl.minimap, 1/30)
end

function ctrl.minimap.PLAYER_STARTED_TURNING(evt)
    ctrl.timer.register(ctrl.minimap, 1/30)
end

function ctrl.minimap.PLAYER_STOPPED_MOVING(evt)
    ctrl.timer.unregister(ctrl.minimap, 1/30)
end


