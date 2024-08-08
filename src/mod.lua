--[[       ctrl - mod.lua - t@wse.nyc - 7/24/24        ]] --
--[[ Module creation and configuration. Example below. ]]

local _, ctrl = ...
local C = ctrl

local function _resize(self, f, w, h)
    ctrl.log(self, 8, 'frame ' ..
        tostring(f.name) .. ' resize caught by metatable in mod.lua. Add resize(f,w,h) to module to customize.')
end

local function _click(self, btn, btn_info)
    ctrl.log(self, 8, 'btn: ' ..
        tostring(btn.name) .. ' click caught by metatable in mod.lua. Add click(btn, btn_info) to module to customize.')
end

local function _timer_tick(self)
    ctrl.log(self, 8, 'tick() -- add ' .. self.name .. ' tick() to resolve.')
end

local function _timer_start(self)
    local interval = self.options.timer.interval or 1
    ctrl.timer.register(self.name, interval)
end

local function _timer_stop(self)
    local interval = self.options.timer.interval or 1
    ctrl.timer.unregister(self.name, interval)
end

--

local function _registerEvents(self)
    for e = 1, #self.options.events do
        ctrl.evt.register(self.name, self.options.events[e])
    end
end

local function _unregisterEvents(self)
    for e = 1, #self.options.events do
        ctrl.evt.unregister(self.name, self.options.events[e])
    end
end

local function _eventHandler(self, e, et)
    if self[e] then
        self[e](et)
    else
        self:evt(e, et)
    end
end

local function _evt(self, e, et)
    self:warn(string.format('%sUncaught event: %s%s%s. Add evt() to module %s%s%s.%s', ctrl.c.r, ctrl.c.o, tostring(e), ctrl.c.r, ctrl.c.y, self.name, ctrl.c.r, ctrl.c.d))
end

--

local function _cleu_register(self)
    for c = 1, #self.options.cleu do
        ctrl.cleu.register(self, self.options.cleu[c])
    end
end

local function _cleu_unregister(self)
    for c = 1, #self.options.cleu do
        ctrl.cleu.unregister(self, self.options.cleu[c])
    end
end

local function _cleu_event(self, cleuevt, ...)
    if self[cleuevt] then
        self[cleuevt](...)
    elseif self.cleuevt then
        self:cleuevt(cleuevt, ...)
    else
        ctrl.log(self, 4, 'uncaught cleu event: ' .. tostring(cleuevt))
    end
end

local function _on(self)
    ctrl.log(self, 8, 'Enabling module ' .. self.name)
    if self.options then
        if self.options.events then self:events_register() end
        if self.options.cleu then self:cleu_register() end
        if self.options.timer then self:timer_start() end
    end
    self.is.on = 1
end

local function _off(self)
    ctrl.log(self, 8, 'Disabling ' .. self.name)
    if self.options.events then self:events_unregister() end
    if self.options.cleu then self:cleu_unregister() end
    if self.options.timer then self:timer_stop() end
    self.is.on = nil
end

local function _onLoad(self)
    if self.is.loaded then return end
    if self.setup then self:setup() end
    if self.on and self.is.enabled and not self.is.on then self:on() end
    self.is.loaded = 1
end

local function _onLogin(self)
    -- PLAYER_LOGIN: one-time setup, not called on /reload
end

local function _onReload(self)
    -- PLAYER_ENTERING_WORLD - called on every /reload
end

local function _init(self)
    ctrl.loads[#ctrl.loads + 1] = self:onLoad()
end

local function _debug(self, ...) ctrl.log(self, 8, ...) end
local function _info(self, ...) ctrl.log(self, 7, ...) end
local function _notice(self, ...) ctrl.log(self, 6, ...) end
local function _warn(self, ...) ctrl.log(self, 5, ...) end
local function _error(self, ...) ctrl.log(self, 4, ...) end
local function _crit(self, ...) ctrl.log(self, 3, ...) end
local function _alert(self, ...) ctrl.log(self, 2, ...) end
local function _emerg(self, ...) ctrl.log(self, 1, ...) end


ctrl.mod = {
    name = '?',
    color = ctrl.c.r,
    symbol = ctrl.s['?'],

    init = _init,
    onLoad = _onLoad,
    onLogin = _onLogin,
    onReload = _onReload,

    registerEvents = _registerEvents,
    unregisterEvents = _unregisterEvents,
    eventHandler = _eventHandler,
    evt = _evt,

    cleu_register = _cleu_register,
    cleu_unregister = _cleu_unregister,
    cleu_event = _cleu_event,

    on = _on,
    off = _off,

    debug = _debug,
    info = _info,
    notice = _notice,
    warn = _warn,
    error = _error,
    crit = _crit,
    alert = _alert,
    emerg = _emerg,
}

function ctrl.mod:new(o)
    if o.is then
        self:warn('WARNING: mod ' .. o.name .. ' already loaded!')
        return
    end

    o.is = {
        enabled = 1,
        loaded = nil,
        on = nil,
    }

    o.options = o.options or {}

    if o.options.frame then
        o.resize = _resize
        o.click = _click
    end

    if o.options.timer then
        o.timer_start = _timer_start
        o.timer_stop = _timer_stop
        o.tick = _timer_tick
    end

    o.ux = {}
    o.ux.c = {}
    setmetatable(o, self)
    self.__index = self

    ctrl.mods[#ctrl.mods + 1] = o
    return o
end

--[[

local example = {
    name = 'myModule',
    symbol = '?',
    color = ctrl.c.w,
    options = {
        frame = { w = 192, h = 140 },
        events = { 'ADDON_LOADED' },
        cleu = { 'SPELL_CAST_SUCCESS' },
        timer = { interval = 1/10 }
    },
}

local addedAlways = {
    on(),
    off(),
}

local addedAutomaticallyIfNeeded = {
    frame = nil,
    resize(),
    timer = {
        start(),
        stop(),
        tick(),
    },
    events = {
        register(),
        unregister(),
        evt(),
        ADDON_LOADED(),
    },
    cleu = {
        register(),
        unregister(),
        evt(),
        SPELL_CAST_SUCCESS(),
    }
}

]]
