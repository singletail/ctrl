--[[ ctrl - util.lua - t@wse.nyc - 7/24/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

--local DevTools_Dump, DisplayTableInspectorWindow, setmetatable = DevTools_Dump, DisplayTableInspectorWindow, setmetatable
--local print, tostring = print, tostring

function ctrl.pack(...)
    return { n = select("#", ...), ... }
end

function ctrl.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function ctrl.groupConfig()
    local unitId = 'player'
    local groupSize = 1
    if IsInRaid() then
        unitId = 'raid'
        groupSize = 40
    elseif IsInGroup() then
        unitId = 'party'
        groupSize = 5
    end
    return unitId, groupSize
end

function ctrl.hexMarkupToRGBA(hexMarkup)
    local hexString = strsub(hexMarkup, 5, 10)
    hexString = hexString .. strsub(hexMarkup, 3, 4)
    local clr = CreateColorFromRGBAHexString(hexString)
    local r, g, b, a = clr:GetRGBA()
    return {r, g, b, a}
end

function ctrl.healthPct(unit)
    return math.floor((UnitHealth(unit) / UnitHealthMax(unit)) * 100)
end

function ctrl.healthPctStr(perc)
    local color = ctrl.c.g
    if perc < 50 then color = ctrl.c.y end
    if perc < 25 then color = ctrl.c.r end
    if perc < 1 then color = ctrl.c.dim end
    return color..perc..'%'
end

--[[ Metatables ]]

local metakey = {}

--local function metafunction(t) return t[metakey] end
local metaKeyTable = {
    __index = function(t)
        return t[metakey]
    end
}

local function setDefault(t, default)
    t[metakey] = default
    setmetatable(t, metaKeyTable)
end

function ctrl.newTable(...)
    local default = ...
    local t = {}
    if default then setDefault(t, default) end
    return t
end

--[[ Debug ]]

function ctrl.inspect(self, ...)
    local t = ...
    if not t then t = self end
    DisplayTableInspectorWindow(t)
end

function ctrl.dump(self, ...)
    local m = ...
    if not m then m = self end
    DevTools_Dump(m)
end

--[[ Lua ]]

function ctrl.count(t) -- only for ipairs
    local c = 0
    for _ in ipairs(t) do
        c = c + 1
    end
    return c
end

function ctrl.cp(t)
    local c
    if type(t) == 'table' then
        c = {}
        for k, v in pairs(t) do
            if type(v) == 'table' then
                c[k] = ctrl.cp(v)
            else
                c[k] = v
            end
        end
    else
        c = t
    end
    return c
end

function ctrl.merge(t, vals)
    for k, v in pairs(vals) do
        if type(v) == 'table' then
            t[k] = t[k] or {}
            for dk, dv in pairs(v) do
                t[k][dk] = dv
            end
        else
            t[k] = v
        end
    end
end

function ctrl.safecopy(obj, depth)
    local o
    depth = depth or 0
    if type(obj) == 'table' then
        o = {}
        for k, v in pairs(obj) do
            local rawV = rawget(obj, k)
            local t = type(rawV)
            if t == 'table' then
                if getmetatable(rawV) == nil then
                    if depth > 0 then
                        o[k] = ctrl.safecopy(rawV, depth - 1)
                    else
                        o[k] = {}
                    end
                    --else
                    --print('safecopy skipped table with metatable ' .. tostring(rawV))
                end
            elseif t == 'string' then
                o[k] = tostring(rawV)
            elseif t == 'number' then
                o[k] = tonumber(rawV)
            elseif t == 'boolean' then
                if rawV == true then
                    o[k] = true
                elseif rawV == false then
                    o[k] = false
                end
            elseif t == nil then
                o[k] = nil
                --else
                --print('safecopy skipped item of type ' .. t)
            end
        end
    else
        o = obj
    end
    return o
end

function ctrl.safeset(dest, src, depth, ignoremetatables)
    if type(dest) ~= 'table' or type(src) ~= 'table' then
        ctrl:log('Safeset error: not table')
        return
    end
    depth = depth or 0
    for k, v in pairs(src) do
        local rawV = rawget(src, k)
        local t = type(rawV)
        if t == 'table' then
            if getmetatable(t) and ignoremetatables then
                --ctrl.debug(ctrl, 'Skipping table ' .. tostring(k) .. ' because it has a metatable.')
            else
                if depth > 0 then
                    if dest[k] then
                        if type(dest[k]) == 'table' then
                            ctrl.safeset(dest[k], rawV, depth - 1)
                        else
                            wipe(dest[k])
                            dest[k] = {}
                        end
                    else
                        dest[k] = {}
                        ctrl.safeset(dest[k], rawV, depth - 1)
                    end
                else
                    dest[k] = {}
                end
            end
        elseif t == 'string' or t == 'number' or t == 'boolean' then
            dest[k] = rawV
        else
            --ctrl.debug(ctrl, 'safecopy skipped item ' .. tostring(k) .. ' with type ' .. t)
        end
    end
end

function ctrl.pp(input, limit, istr)
    limit = limit or 100
    istr = istr or '->   '
    if (limit < 1) then
        --ctrl.output "ERROR: Item limit reached."
        return limit - 1
    end
    local ts = type(input)
    if (ts ~= 'table') then
        ctrl.log(ctrl, 8, string.format('%s[%s]', istr, ctrl.wrap(input)))
        return limit - 1
    end
    ctrl.log(ctrl, 8, string.format('%s[%s]', istr, ctrl.wrap(ts)))
    for k, v in pairs(input) do
        limit = ctrl.pp(v, limit, string.format('%s%s    [%s]', istr, ctrl.c.c, tostring(k)))
        if (limit < 0) then break end
    end
    return limit
end

local typeCol = {
    ['table'] = ctrl.c.p,
    ['nil'] = ctrl.c.p,
    ['string'] = ctrl.c.g,
    ['number'] = ctrl.c.b,
    ['boolean'] = ctrl.c.y,
    ['function'] = ctrl.c.o,
    ['userdata'] = ctrl.c.d,
    ['thread'] = ctrl.c.w,
}

function ctrl.wrap(any)
    local ret = typeCol[any] or typeCol[type(any)] or ctrl.c.r
    return string.format('%s%s%s', ret, tostring(any), ctrl.c.d)
end
