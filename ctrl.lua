--[[               ctrl                ]] --
--[[          Mod Controller.          ]] --
--[[             t@wse.nyc             ]] --
--[[              7/24/24              ]] --

local _, ctrl = ...

ctrl.master = {
    name = 'ctrl',
    color = ctrl.c.r,
    symbol = '、',
}

function ctrl.master.ready()
    ctrl.is.loaded = 1
    ctrl.logs.dumpBuffer()
    ctrl.log(ctrl.master, 8, ctrl.logmem('ctrl'))
    ctrl.log(ctrl.master, 6, ctrl.name .. ' is ready.')
end

function ctrl.master.load()
    if ctrl.is.loaded then return end
    for n = 1, #ctrl.loads do
        ctrl.loads[n]()
    end
    ctrl.master.ready()
end
