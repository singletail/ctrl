--[[       ctrl - mod.lua - t@wse.nyc - 7/24/24        ]]

---@class ctrl
local ctrl = select(2, ...)

local function _resize(self, f, w, h)
    ctrl.log(self, 8, 'frame ' ..
        tostring(f.name) .. ' resize caught by metatable in mod.lua. Add resize(f,w,h) to module to customize.')
end

local function _click(self, btn, btn_info)
    ctrl.log(self, 8, 'btn: ' ..
        tostring(btn.name) .. ' click caught by metatable in mod.lua. Add click(btn, btn_info) to module to customize.')
end

local function _registerTimers(self)
    for e = 1, #self.options.timers do
        ctrl.timer.register(self, self.options.timers[e])
    end
end

local function _unregisterTimers(self)
    for e = 1, #self.options.timers do
        ctrl.timer.unregister(self, self.options.timers[e])
    end
end

local function _tick(self, interval, count) --overwrite this in your module
    self:warn(string.format('%sUncaught timer event, interval %s%s%s. Add tick() to module %s%s%s.%s', ctrl.c.r, ctrl.c.o, tostring(interval), ctrl.c.r, ctrl.c.y, self.name, ctrl.c.r, ctrl.c.d))
end

--

local function _registerEvents(self)
    for e = 1, #self.options.events do
        ctrl.evt.register(self, self.options.events[e])
    end
end

local function _unregisterEvents(self)
    for e = 1, #self.options.events do
        ctrl.evt.unregister(self, self.options.events[e])
    end
end

local function _eventHandler(self, e, et)
    if ctrl[self.name][e] then
        self[e](et)
    else
        self.evt(self, e, et)
    end
end

local function _evt(self, e, et) --overwrite this in your module
    self:warn(string.format('%sUncaught event: %s%s%s. Add evt() to module %s%s%s.%s', ctrl.c.r, ctrl.c.o, tostring(e), ctrl.c.r, ctrl.c.y, self.name, ctrl.c.r, ctrl.c.d))
end

--

local function _registerCleuEvents(self)
    for c = 1, #self.options.cleu do
        ctrl.cleu.register(self, self.options.cleu[c])
    end
end

local function _unregisterCleuEvents(self)
    for c = 1, #self.options.cleu do
        ctrl.cleu.unregister(self, self.options.cleu[c])
    end
end

local function _cleuEventHandler(self, cleut)
    if ctrl[self.name][cleut[2]] then
        self[cleut[2]](cleut)
    else
        self.cleuEvt(self, cleut)
    end
end

local function _cleuEvt(self, cleut) --overwrite this in your module
    self:warn(string.format('%sUncaught event: %s%s%s. Add cleuEvt() to module %s%s%s.%s', ctrl.c.r, ctrl.c.o, tostring(cleut[2]), ctrl.c.r, ctrl.c.y, self.name, ctrl.c.r, ctrl.c.d))
end

--

local function _on(self)
    ctrl.log(self, 8, 'Enabling module ' .. self.name)
    if self.options then
        if self.options.events then self:registerEvents() end
        if self.options.cleu then self:registerCleuEvents() end
        if self.options.timers then self:registerTimers() end
    end
    self.is.on = 1
end

local function _off(self)
    ctrl.log(self, 8, 'Disabling ' .. self.name)
    if self.options.events then self:unregisterEvents() end
    if self.options.cleu then self:unregisterCleuEvents() end
    if self.options.timers then self:unregisterTimers() end
    self.is.on = nil
end

local function _onLoad(self)
    if self.is.loaded then return end
    if self.setup then self:setup() end
    if self.on and self.is.enabled and not self.is.on then self:on() end
    self.is.loaded = 1
end

local function _onLogin(self) --overwrite this in your module, if needed
    -- PLAYER_LOGIN: one-time setup, not called on /reload
end

local function _onReload(self) --overwrite this in your module, if needed
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

local mod = {
    name = '?',
    color = ctrl.c.r,
    symbol = ctrl.s['?'],

    init = _init,
    onLoad = _onLoad,
    onLogin = _onLogin,
    onReload = _onReload,

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

ctrl.mod = {}

function ctrl.mod:new(t)

    local o = {}
    for k,v in pairs(mod) do o[k] = v end
    for k2,v2 in pairs(t) do o[k2] = v2 end

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

    if o.options.events then
        o.registerEvents = _registerEvents
        o.unregisterEvents = _unregisterEvents
        o.eventHandler = _eventHandler
        o.evt = _evt
    end

    if o.options.cleu then
        o.registerCleuEvents = _registerCleuEvents
        o.unregisterCleuEvents = _unregisterCleuEvents
        o.cleuEventHandler = _cleuEventHandler
        o.cleuEvt = _cleuEvt
    end

    if o.options.timers then
        o.registerTimers = _registerTimers
        o.unregisterTimers = _unregisterTimers
        o.tick = _tick
    end

    o.f = {}
    o.tx = {}
    o.fs = {}
    o.btn = {}

    --setmetatable(o, self)
    --self.__index = self

    ctrl.mods[#ctrl.mods + 1] = o
    return o
end
