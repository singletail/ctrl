--[[               ctrl                ]] --
--[[             t@wse.nyc             ]] --
--[[       Singletail-Proudmoore       ]] --
--[[              7/24/24              ]] --

---@class ctrl
local ctrl = select(2, ...)

ctrl.master = {
    name = 'ctrl',
    color = ctrl.c.r,
    symbol = '、',
}

function ctrl.master.ready()
    ctrl.is.loaded = 1
    ctrl.logs.dumpBuffer()
    ctrl.log(ctrl.master, 5, 'Ready', ctrl.logmem('ctrl'))
end

function ctrl.master.load()
    ctrl.log(ctrl.master, 5, 'ctrl.load()')
    ctrl.data:login() -- initialize SavedVariables
    ctrl.loadprefs() -- load user preferences
    for n = 1, #ctrl.loads do ctrl.loads[n]() end
    ctrl.loads = nil
    ctrl.master.ready()
end
