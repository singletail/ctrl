--[[ ctrl - ui.lua - t@wse.nyc - 8/5/24 ]]
--

local _, ctrl = ...
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'ui',
    color = c.o,
    symbol = s.ux,
    options = {
        events = {
            'PLAYER_ENTERING_WORLD',
            'DISPLAY_SIZE_CHANGED',
        }
    }
}

ctrl.ui = ctrl.mod:new(mod)

ctrl.ui.scale = 1.5
ctrl.ui.uiParentScale = 1

--

local last = 0

local client = {
    adapters = {
        name = nil,         --string
        isLowPower = false, --bool
        isExternal = false, --bool
    }
}

local function set()
    UIParent:SetScale(ctrl.ui.uiParentScale)
    ctrl.ui:debug('UIParent:SetScale(' .. tostring(ctrl.ui.uiParentScale) .. ')')
end

local function compute()
    local _, screenH = GetPhysicalScreenSize()
    ctrl.ui.uiParentScale = (768 / (screenH / ctrl.ui.scale))
end

local function cvars()
    C_CVar.SetCVar("uiScale", 1)
    C_CVar.SetCVar("useUiScale", 0)
end

local function update()
    cvars()
    compute()
    set()
end

--

function ctrl.ui.DISPLAY_SIZE_CHANGED(evt)
    update()
end

function ctrl.ui.PLAYER_ENTERING_WORLD(evt)
    update()
end

ctrl.ui:init()

--[[
local function getInfo()
    local adapters = C_VideoOptions.GetGxAdapterInfo()
    local antiAliasingSupported = AntiAliasingSupported()        --bool
    local currentScaledResolution = GetCurrentScaledResolution() --width?
    local minRenderScale = GetMinRenderScale()
    local maxRenderScale = GetMaxRenderScale()
    local monitorAspectRatio = GetMonitorAspectRatio()
    local monitorCount = GetMonitorCount()                                              --2?
    local monitorName = GetMonitorName()                                                --nil?
    local screenW, screenH = GetPhysicalScreenSize()                                    --**
    local dpiScale = GetScreenDPIScale()
    local screenHeight = GetScreenHeight()                                              -- UI Scaled 779
    local screenWidth = GetScreenWidth()                                                -- UI Scaled 1245
    local c1, c2, c3, c4, c5, c6, c7, c8 = GetVideoCaps()                               -- true, true, true, true, true, 16, true
    local isOutlineModeSupported = IsOutlineModeSupported()                             -- true
    local msaa1, msaa2, msaa3, msaa4, msaa5, msaa6 = MultiSampleAntiAliasingSupported() -- 1.0, 2, 2, 2.0, 4, 4
end
]]
