--[[ ctrl - ui/fnt.lua - t@wse.nyc - 23 July 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'fnt',
    color = c.w,
    symbol = "A",
}

ctrl.fnt = ctrl.mod:new(mod)
ctrl.fnt.cache = ctrl.fnt.cache or {}

function ctrl.font(...)
    local name, size, flags = ...
    name = name or ctrl.prefs.font.file
    size = size or ctrl.prefs.font.size
    flags = flags or ctrl.prefs.font.flags
    ctrl.fnt.cache[name] = ctrl.fnt.cache[name] or {}
    if not ctrl.fnt.cache[name][size] then ctrl.fnt.new(name, size, flags) end
    if not ctrl.fnt.cache[name][size] then ctrl.log(ctrl, 5, 'error: '..name); return nil end
    return ctrl.fnt.cache[name][size]
end

function ctrl.fnt.new(name, size, flags)
    local globalName = 'ctrlfnt'..name..tostring(size)
    local file = ctrl.p.fnt .. name .. '.ttf'
    flags = flags or ''
    local fontObject = _G[globalName] or CreateFont(globalName)
    fontObject:SetFont(file, size, flags)
    ctrl.fnt.cache[name] = ctrl.fnt.cache[name] or {}
    ctrl.fnt.cache[name][size] = fontObject
end