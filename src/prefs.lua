--[[ ctrl - prefs.lua - t@wse.nyc - 18 July 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

-- Defaults, overwritten by user prefs

ctrl.prefs = {
    log = {
        enable = 1,
        level = 8,
        max = 1000,
        index = 1,
    }
}

function ctrl.loadprefs()
    ctrl.merge(ctrl.data.prefs, ctrl.prefs)
    ctrl.prefs = ctrl.data.prefs
end
