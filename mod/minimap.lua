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
    ['loc'] = { target = 'main', w = 300, h = 300, strata = 'BACKGROUND', a=a.tl, pa=a.tl, x=0, y=0 },
}

local textures = {
    --['tx'] = { t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
    --['loctx'] = { target = 'loc', t = 'bluebk_full_256', path = ctrl.p.tx, l = -6 },
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
    ['fsTime'] = { target = 'main', t = 'T', fontFile = 'Prompt-Bold.ttf', fontSize = 24, a = a.tl, pa = a.t, x=-50, y=-12},
    ['fsDate'] = { target = 'main', t = 'D', fontFile = 'Prompt-Medium.ttf', fontSize = 14, a = a.b, pa = a.b, x = 0, y = 6 },
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

function ctrl.minimap:resize(frame, w, h)
    local framestoresize = {
        ['main'] = { { t = Minimap, a = a.tl, pa = a.tl, x = 0, y = 64 }, { t = Minimap, a = a.br, pa = a.tr, x = 0, y = 8 } },
        ['loc'] = { { t = Minimap, a = a.tl, pa = a.bl, x = 0, y = -8 }, { t = Minimap, a = a.br, pa = a.br, x = 0, y = -72 } },
    }
    for t, v in pairs(framestoresize) do
        self.f[t]:ClearAllPoints()
        for _, x in ipairs(v) do
            self.f[t]:SetPoint(x.a, x.t, x.pa, x.x, x.y)
        end
    end
    local tx = {
        --['loctx'] = { { t = self.f.loc, a = a.tl, pa = a.tl, x = 0, y = 0 }, { t = self.f.loc, a = a.br, pa = a.br, x = 0, y = 0 } },
        ['ct'] = { { t = self.f.main, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.tr, x = 1, y = -1 } },
        ['cl'] = { { t = self.f.main, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.bl, x = 0, y = -1 } },
        ['cr'] = { { t = self.f.main, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = self.f.main, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['cb'] = { { t = self.f.main, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = self.f.main, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['t'] = { { t = Minimap, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.tr, x = 1, y = -1 } },
        ['l'] = { { t = Minimap, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.bl, x = 0, y = -1 } },
        ['r'] = { { t = Minimap, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = Minimap, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['b'] = { { t = Minimap, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = Minimap, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['lt'] = { { t = self.f.loc, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.tr, x = 1, y = -1 } },
        ['ll'] = { { t = self.f.loc, a = a.tl, pa = a.tl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.bl, x = 0, y = -1 } },
        ['lr'] = { { t = self.f.loc, a = a.tl, pa = a.tr, x = 0, y = 0 }, { t = self.f.loc, a = a.br, pa = a.br, x = 1, y = -1 } },
        ['lb'] = { { t = self.f.loc, a = a.tl, pa = a.bl, x = -1, y = 0 }, { t = self.f.loc, a = a.br, pa = a.br, x = 1, y = -1 } },
    }
    for t, v in pairs(tx) do
        ctrl.minimap.tx[t]:ClearAllPoints()
        for _, x in ipairs(v) do
            ctrl.minimap.tx[t]:SetPoint(x.a, x.t, x.pa, x.x, x.y)
        end
    end
end

function ctrl.minimap:UpdateClock()
    timeTable[2] = date(" %I"):gsub(' 0', ' ')
    timeTable[3] = date(":%M:%S ")
    ctrl.minimap.fs.fsTime:SetText(table.concat(timeTable))
    dateTable[2] = date('%A, %B %d, %Y'):gsub(' 0', ' ')
    ctrl.minimap.fs.fsDate:SetText(table.concat(dateTable))
end

function ctrl.minimap:UpdateLocation()
    local mapId = C_Map.GetBestMapForUnit('player')

    zone_table[2] = GetZoneText() or "Unknown"
    ctrl.minimap.fs.fsZone:SetText(table.concat(zone_table))

    sub_table[2] = GetMinimapZoneText() or "Unknown"
    ctrl.minimap.fs.fsSub:SetText(table.concat(sub_table))

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
    ctrl.minimap.fs.fsCoords:SetText(table.concat(coords_table, ' '))
end

function ctrl.minimap:tick(interval, count)
    if interval == 1 then
        self:UpdateClock()
    else
        self:UpdateLocation()
    end
end

function ctrl.minimap.setup(self)
    ctrl.minimap.f.main = ctrl.frame.new(ctrl.minimap, ctrl.minimap.options.frame)
    ctrl.frame.generate(ctrl.minimap, subframes)
    ctrl.tx.generate(ctrl.minimap, textures)
    ctrl.fs.generate(ctrl.minimap, fontstrings)
end

ctrl.minimap:init()

-- pre-load:

local function minimapComputeSize()
    local screenW, screenH = GetPhysicalScreenSize()
    return {
        w = math.floor(screenH / 3),
        h = math.floor(screenH / 3),
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


