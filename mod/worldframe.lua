--[[ ctrl - worldframe.lua - t@wse.nyc - 8/6/24 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'worldframe',
    color = c.v,
    symbol = s.tx,
    options = {
        events = {
            'PLAYER_ENTERING_WORLD',
        }
    }
}

ctrl.worldframe = ctrl.mod:new(mod)

local wf = C_UI.GetWorldFrame()

local set = {
    t = -100,
    l = 0,
    r = 0,
    b = 100,
}

local last = 0

local function doSet()
    if GetServerTime() - last < 60 then
        ctrl.worldframe:info('WorldFrame Throttled.')
        return
    end
    ctrl.worldframe:info('Resetting WorldFrame anchors.')
    wf:ClearAllPoints()
    wf:SetPoint("TOPLEFT", set.l, set.t)
    wf:SetPoint("BOTTOMRIGHT", set.r, set.b)
    last = GetServerTime()
end

local function check()
    local ok = 1
    for i = 1, wf:GetNumPoints() do
        local pt, aa, pa, x, y = wf:GetPoint(i)
        --ctrl.worldframe.debug(ctrl.worldframe, pt, aa, pa, x, y)
        if pt == 'TOPLEFT' then
            if math.abs(y - set.t) > 1 then ok = nil end
            if math.abs(x - set.l) > 1 then ok = nil end
        elseif pt == 'BOTTOMRIGHT' then
            if math.abs(y - set.b) > 1 then ok = nil end
            if math.abs(x - set.r) > 1 then ok = nil end
        end
    end
    if not ok then doSet() end
end

function ctrl.worldframe.DISPLAY_SIZE_CHANGED(evt)
    check()
end

function ctrl.worldframe.UI_SCALE_CHANGED(evt)
    check()
end

function ctrl.worldframe.PLAYER_ENTERING_WORLD()
    doSet()
    ctrl.evt.register(ctrl.worldframe, 'UI_SCALE_CHANGED')
    ctrl.evt.register(ctrl.worldframe, 'DISPLAY_SIZE_CHANGED')
end

ctrl.worldframe:init()
