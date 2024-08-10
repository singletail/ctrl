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
        },
        events = {
            'PLAYER_ENTERING_WORLD',
            'ZONE_CHANGED',
            'ZONE_CHANGED_INDOORS',
            'PLAYER_STARTED_MOVING',
            'PLAYER_STOPPED_MOVING',
            --'DISPLAY_SIZE_CHANGED',
            'UI_SCALE_CHANGED',
            'GARRISON_SHOW_LANDING_PAGE',
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

local subframes = {
    ['loc'] = { target = UIParent, w = 300, h = 300 },
}

local textures = {
    --['tx'] = { t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
    --['loctx'] = { target = 'loc', t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
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
    ['fsTime'] = { t = 'T', fontFile = 'Countdown-Regular.otf', fontSize = 32, a = a.tl, pa = a.t, x=-64, y=-2},
    ['fsDate'] = { t = 'D', fontFile = 'Data70-Regular.otf', fontSize = 18, a = a.b, pa = a.b, x = 0, y = 4 },
    ['fsZone'] = { target = 'loc', t = 'Z', fontFile = 'Prompt-Bold.ttf', fontSize = 21, a = a.t, pa = a.t, x = 0, y = -5 },
    ['fsSub'] = { target = 'loc', t = 'S', fontFile = 'Prompt-Medium.ttf', fontSize = 16, a = a.c, pa = a.c, x = 0, y = -4 },
    ['fsCoords'] = { target = 'loc', t = 'C', fontFile = 'SpaceMono-Bold.ttf', fontSize = 12, a = a.b, pa = a.b, x = -3, y = 4 },
}

local timeTable = ctrl.newTable('')
local dateTable = ctrl.newTable('')
local coords_table = ctrl.newTable('')
local zone_table = ctrl.newTable('')
local sub_table = ctrl.newTable('')

timeTable[1] = c.w
dateTable[1] = c.o
coords_table[1] = c.y
zone_table[1] = c.b
sub_table[1] = c.v

function ctrl.minimap:resize()
    local b = {
        ['f'] = { { t = Minimap, a = a.tl, pa = a.tl, x = 0, y = 64 }, { t = Minimap, a = a.br, pa = a.tr, x = 0, y = 8 } },
        --['tx'] = { { t = self.ux.f, a = a.tl, pa = a.tl, x = 0, y = 0 }, { t = self.ux.f, a = a.br, pa = a.br, x = 0, y = 0 } },
        ['loc'] = { { t = Minimap, a = a.tl, pa = a.bl, x = 0, y = -8 }, { t = Minimap, a = a.br, pa = a.br, x = 0, y = -72 } },
        --['loctx'] = { { t = self.ux.c.loc, a = a.tl, pa = a.tl, x = 0, y = 0 }, { t = self.ux.c.loc, a = a.br, pa = a.br, x = 0, y = 0 } },
        ['ct'] = { { t = self.ux.f, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.ux.f, a = a.br, pa = a.tr, x = 1, y = -1 } },
        ['cl'] = { { t = self.ux.f, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.ux.f, a = a.br, pa = a.bl, x = 0, y = -1 } },
        ['cr'] = { { t = self.ux.f, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = self.ux.f, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['cb'] = { { t = self.ux.f, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = self.ux.f, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['t'] = { { t = Minimap, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.tr, x = 1, y = -1 } },
        ['l'] = { { t = Minimap, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.bl, x = 0, y = -1 } },
        ['r'] = { { t = Minimap, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = Minimap, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['b'] = { { t = Minimap, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['lt'] = { { t = self.ux.c.loc, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.ux.c.loc, a = a.br, pa = a.tr, x = 1, y = -1 } },
        ['ll'] = { { t = self.ux.c.loc, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.ux.c.loc, a = a.br, pa = a.bl, x = 0, y = -1 } },
        ['lr'] = { { t = self.ux.c.loc, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = self.ux.c.loc, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['lb'] = { { t = self.ux.c.loc, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = self.ux.c.loc, a = a.br, pa = a.br, x = 1, y = -1 } },
    }
    for t, v in pairs(b) do
        self.ux.c[t]:ClearAllPoints()
        for _, x in ipairs(v) do
            self.ux.c[t]:SetPoint(x.a, x.t, x.pa, x.x, x.y)
        end
    end
end

function ctrl.minimap:UpdateClock()
    timeTable[2] = date(" %I"):gsub(' 0', ' ')
    timeTable[3] = date(":%M:%S ")
    ctrl.minimap.ux.c.fsTime:SetText(table.concat(timeTable))
    dateTable[2] = date('%A, %B %d, %Y'):gsub(' 0', ' ')
    ctrl.minimap.ux.c.fsDate:SetText(table.concat(dateTable))
end

function ctrl.minimap:UpdateLocation()
    local mapId = C_Map.GetBestMapForUnit('player')

    zone_table[2] = GetZoneText() or "Unknown"
    ctrl.minimap.ux.c.fsZone:SetText(table.concat(zone_table))

    sub_table[2] = GetMinimapZoneText() or "Unknown"
    ctrl.minimap.ux.c.fsSub:SetText(table.concat(sub_table))

    if not mapId then
        self.x = 0
        self.y = 0
    else
        local position = C_Map.GetPlayerMapPosition(mapId, 'player')
        if position then
            if position.x ~= self.x or position.y ~= self.y then
                self.x = position.x
                self.y = position.y
            end
        end
    end
    if self.x and self.y then
        coords_table[2] = string.format('%.5f', math.floor(self.x * 10000000) / 100000)
        coords_table[3] = string.format('%.5f', math.floor(self.y * 10000000) / 100000)
    end
    ctrl.minimap.ux.c.fsCoords:SetText(table.concat(coords_table, ' '))
end

function ctrl.minimap:tick(interval, count)
    if interval == 1 then
        self:UpdateClock()
    else
        self:UpdateLocation()
    end
end

function ctrl.minimap:setup()
    self.ux.f = ctrl.frame:new(self.options.frame, self)
    self.ux.c.f = self.ux.f
    ctrl.frame:generate(subframes, self)
    ctrl.tx:generate(textures, self)
    ctrl.fs:generate(fontstrings, self)
end

ctrl.minimap:init()

-- pre-load:

local function minimapComputeSize()
    local screenW, screenH = GetPhysicalScreenSize()
    return {
        w = math.floor(screenH / 4),
        h = math.floor(screenH / 4),
        x = -16,
        y = -72,
        s = 1.5,
    }
end

local function minimapConfigure()
    Minimap:SetZoom(0)
    C_CVar.SetCVar('rotateMinimap', nil)
    MinimapCompassTexture:Hide()
    Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
    ExpansionLandingPageMinimapButton:SetScale(0.5)
end

local function minimapSetup()
    local x = minimapComputeSize()
    local frames = {
        { f = MinimapCluster,                  p = UIParent,                        s = 1,   w = x.w,       h = x.h,      a = { a = a.tr, pa = a.tr, x = x.x, y = x.y } },
        { f = MinimapCluster.MinimapContainer, p = MinimapCluster,                  s = 1,   w = x.w,       h = x.h },
        { f = Minimap,                         p = MinimapCluster.MinimapContainer, s = x.s, w = x.w / x.s, h = x.h / x.s },
        { f = MinimapBackdrop,                 p = MinimapCluster,                  s = 1,   w = x.w,       h = x.h },
    }
    for _, f in ipairs(frames) do
        f.f:ClearAllPoints()
        f.f:SetScale(f.s)
        f.f:SetSize(f.w, f.h)
        if f.a then
            f.f:SetPoint(f.a.a, f.p, f.a.pa, f.a.x, f.a.y)
        else
            f.f:SetAllPoints(f.p)
        end
    end
end

local function minimap()
    minimapConfigure()
    minimapSetup()
end

minimap()

function ctrl.minimap.DISPLAY_SIZE_CHANGED()
    minimap()
end

function ctrl.minimap.UI_SCALE_CHANGED()
    minimap()
end

function ctrl.minimap.PLAYER_ENTERING_WORLD()
    minimap()
    ctrl.minimap:UpdateClock()
    ctrl.minimap:UpdateLocation()
end

function ctrl.minimap.PLAYER_STARTED_MOVING(evt)
    ctrl.timer.register(ctrl.minimap, 1/30)
end

function ctrl.minimap.PLAYER_STOPPED_MOVING(evt)
    ctrl.timer.unregister(ctrl.minimap, 1/30)
end

--[[
local function moveSubframes()
    --MinimapCluster.TrackingFrame:ClearAllPoints()
    --MinimapCluster.TrackingFrame:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 6, -36)
    Minimap.ZoomIn:ClearAllPoints()
    Minimap.ZoomIn:SetSize(8, 8)
    Minimap.ZoomIn:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', -4, -6)
    Minimap.ZoomOut:ClearAllPoints()
    Minimap.ZoomOut:SetSize(8, 8)
    Minimap.ZoomOut:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', -4, -18)
end
]]





--[[


function ctrl.minimap:UpdateText()
    coords_table[2] = self:x()
    coords_table[3] = self:y()
    zone_table[2] = self.settings.zone
    sub_table[2] = self.settings.subzone
    self.frame.string['zone']:SetText(table.concat(zone_table))
    self.frame.string['sub']:SetText(table.concat(sub_table))
    self.frame.string['coords']:SetText(table.concat(coords_table, ' '))
end




function ctrl.minimap.PLAYER_STARTED_MOVING(evt)
    ctrl.minimap.moving = true
    --ctrl.minimap:startTimer()
end

function ctrl.minimap.PLAYER_STOPPED_MOVING(evt)
    ctrl.minimap.moving = nil
    --ctrl.minimap:stopTimer()
end

]]
--[[


UIParent
    MinimapCluster -- UIParent TOPRIGHT 0 0
        MinimapContainer - MinimapCluster Top Top 10 -30
            Minimap - MinimapContainer CENTER 0 0
                MinimapBackdrop - Minimap CENTER 0 0

UIParent
    MinimapCluster -- UIParent TOPRIGHT 0 0
        BorderTop
            BottomEdge
            BottomLeftCorner
            BottomRightCorner
            Center
            LeftEdge
            RightEdge
            TopEdge
            TopLeftCorner
            TopRightCorner
        IndicatorFrame
            CraftingOrderFrame
                MiniMapCraftingOrderIcon
            MailFrame
                MiniMapMailIcon
                MailReminderAnim
                MailReminderFlipbook
                NewMailAnim
                NewMailFlipbook
        InstanceDifficulty
            ChallengeMode
                Background
                Border
                ChallengeModeTexture
            Default
                Background
                Border
                HeroicTexture
                MythicTexture
                NormalTexture
                Text
                WalkInTexture
            Guild
                Background
                Border
                Emblem
                Instance
        MinimapContainer - MinimapCluster Top Top 10 -30
            Minimap - MinimapContainer CENTER 0 0
                MinimapBackdrop - Minimap CENTER 0 0
                    ExpansionLandingPageMinimapButton
                        AlertBG
                        AlertText
                        CircleGlow
                        LoopingGlow
                        MinimapAlertAnim
                        MinimapLoopPulseAnim
                        MinimapPulseAnim
                        SideToastGlow
                        SoftButtonGlow
                    MinimapCompassTexture
                ZoomHitArea
                ZoomIn
                ZoomOut
        AddonCompartmentFrame
            Text
        GameTimeFrame
            CalendarEventAlarmTexture
            CalendarInvitesGlow
            CalendarInvitesTexture
            GameTimeTexture
        Selection
            Label
        Tracking
            Background
            Button
        ZoneTextButton
            Text

]]
