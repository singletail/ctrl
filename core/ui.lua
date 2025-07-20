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
            'UPDATE_CHAT_WINDOWS',
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
    if (UIParent:GetScale() - ctrl.ui.uiParentScale) < 0.001 then return end
    UIParent:SetScale(ctrl.ui.uiParentScale)
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
    compute()
    set()
end

--

function ctrl.ui.UPDATE_CHAT_WINDOWS()
    update()
end

function ctrl.ui.PLAYER_ENTERING_WORLD()
    cvars()
    update()
end

ctrl.ui:init()

