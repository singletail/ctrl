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
    if (UIParent:GetScale() - ctrl.ui.uiParentScale) < 0.001 then return end
    --if ctrl.ui.uiParentScale < 0 then
        --ctrl.log(ctrl.ui, 5, 'UIParent scale is too small, setting to 0.3')
        --ctrl.ui.uiParentScale = 0.3
    --end
    --ctrl.ui:debug('Changing UIParent scale from '..tostring(UIParent:GetScale()) .. ' to ' .. tostring(ctrl.ui.uiParentScale))
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

function ctrl.ui.DISPLAY_SIZE_CHANGED()
    update()
end

function ctrl.ui.PLAYER_ENTERING_WORLD()
    cvars()
    update()
end

ctrl.ui:init()

