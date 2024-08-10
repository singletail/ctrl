--[[ ctrl - data.lua - t@wse.nyc - 7/24/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local mod = {
    name = 'data',
    color = ctrl.c.g,
    symbol = ctrl.s.ctrl,
    options = {
        events = { 'ADDON_LOADED', 'PLAYER_STARTED_MOVING' },
    }
}

ctrl.data = ctrl.mod:new(mod)

-- TODO: This is a mess. Rewrite it.

-- Globals:
-- ctrlprefs
-- ctrldata
-- ctrllog

--[[
function ctrl.data:initPrefs()
    ctrlprefs = ctrlprefs or {
        name        = ctrl.name,
        description = ctrl.description,
        version     = ctrl.version,
        author      = ctrl.author,
        color       = ctrl.color,
        symbol      = ctrl.symbol,

        created     = ctrl.start,
        modified    = GetServerTime(),

        debug       = ctrl.setting.debug,
        verbose     = ctrl.setting.verbose,
        log         = ctrl.setting.log,
    }
    --self:debug('initPrefs()')
end

function ctrl.data:writePrefs()
    if not ctrlprefs then
        self:initPrefs()
    else
        ctrlprefs.modified = GetServerTime()
        ctrlprefs.debug = ctrl.setting.debug
        ctrlprefs.verbose = ctrl.setting.verbose
        ctrlprefs.log = ctrl.setting.log
        --self:debug('writePrefs()')
    end
end

function ctrl.data:loadPrefs()
    ctrlprefs = ctrlprefs or {}
    if ctrlprefs.debug then ctrl.setting.debug = ctrlprefs.debug end
    if ctrlprefs.verbose then ctrl.setting.verbose = ctrlprefs.verbose end
    if ctrlprefs.log then ctrl.setting.log = ctrlprefs.log end
    --self:debug('loadPrefs()')
end

function ctrl.data:reset()
    --self:debug('==RESET DATA==')
    ctrl.db = {}
    ctrldata = {}
    self:updatePrefs()

    --self:debug('--prefs from memory--')
    ctrl.pp(ctrl.setting)
    ctrl.pp(ctrl.is)
    --self:debug('--prefs from SavedVariables--')
    ctrl.pp(ctrlprefs)

    --self:debug('--db from memory--')
    ctrl.pp(ctrl.db)
    --self:debug('--db from SavedVariables--')
    ctrl.pp(ctrldata)
end

function ctrl.data:initData()
    ctrl.db = {}
    ctrldata = ctrl.cp(ctrl.db)
    --self:debug('initData()')
end

function ctrl.data:writeData()
    ctrldata = ctrl.cp(ctrl.db)
    --self:debug('updateData()')
end

function ctrl.data:loadData()
    if not ctrldata then return end
    ctrl.db = ctrl.cp(ctrldata)
    --self:debug('loadData()')
end

function ctrl.data:initialize()
    self:initPrefs()
    self:initData()
end

]]



function ctrl.data:evt(e, ...)
    local et = ctrl.pack(...)
    self:debug('data received event', e)
end

function ctrl.data:setup()
    self:debug('** ctrl.data.setup called')
    --ctrl.data.reset(ctrl.data) --temp
    --ctrl.data.loadPrefs(ctrl.data)
    --ctrl.data.loadData(ctrl.data)
    --ctrl.editor.refresh(ctrl.editor)
    --self.events.register(self, self.options.events)
    --ctrl.dump(ctrlprefs)
end

ctrl.data.init(ctrl.data)
