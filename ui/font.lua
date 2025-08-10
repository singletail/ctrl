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

--local LSM = LibStub("LibSharedMedia-3.0")

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

function ctrl.fnt.new(name, size, flags) -- ignoring flags for now
    local name_nosuffix = ''
    local name_file = ''

    if name:sub(-4) == '.ttf' or name:sub(-4) == '.otf' then
        name_nosuffix = name:sub(1, -5)
        name_file = ctrl.p.fnt .. name
    else
        name_nosuffix = name
        name_file = ctrl.p.fnt .. name .. '.ttf'
    end
    local name_cache = 'ctrl_' .. name_nosuffix .. '_' .. tostring(size)

    ctrl.log(ctrl, 1, '-- font name: '..name..' size: '..size)
    ctrl.log(ctrl, 1, '-- font file: '..name_file..' name_nosuffix: '..name_nosuffix..' name_cache: '..name_cache)

    local fontObject = _G[name_cache] or CreateFont(name_cache)
    fontObject:SetFont(name_file, size, flags)

    ctrl.fnt.cache[name_nosuffix] = ctrl.fnt.cache[name_nosuffix] or {}
    ctrl.fnt.cache[name_nosuffix][size] = fontObject

   --if LSM then
    --    LSM:Register("font", name_nosuffix, name_file)
    --    ctrl.log(ctrl, 1, 'LSM:Registered font: '..name_nosuffix)
    --end
end