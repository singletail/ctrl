--[[ ctrl - info.lua - t@wse.nyc - 8/7/24 ]]

---@class ctrl
local addon, ctrl = ...
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'info',
    color = c.o,
    symbol = s.info,
    taint = nil,
    error = nil,
    options = {
        numRows = 6,
        timers = {
            1, 15
        },
        events = {
            'PLAYER_ENTERING_WORLD',
            'ADDON_ACTION_BLOCKED',
            'ADDON_ACTION_FORBIDDEN',
            'GENERIC_ERROR',
        },
        frame = {
            name = 'info',
            isResizable = nil,
            isMovable = nil,
            target = ctrl.power.f.main,
        },
    }
}

ctrl.info = ctrl.mod:new(mod)

local textures = {['bk'] = { target='main', t='dark1', l=-6, al=0.6 },}
local label_text = {'taint', 'fps', 'ping', 'mem', 'sqw', 'loot'}

function ctrl.info:boxes()
    local box_default = { t='LCDsm27.png', target='main', l=-5, a=a.tr, pa=a.tr}
    for i=1, self.options.numRows do
        local box = ctrl.cp(box_default)
        box.name = 'box'..i
        box.x = ctrl.prefs.mod.info.box.x
        box.w = ctrl.prefs.mod.info.box.width
        box.h = ctrl.prefs.mod.info.box.height
        box.y = ctrl.prefs.mod.info.box.y - ((i-1) * (ctrl.prefs.mod.info.box.height + ctrl.prefs.mod.info.box.spacing))
        self.tx['box'..i] = ctrl.tx.new(self, box)
    end
end

function ctrl.info:labels()
    ctrl.info.label = ctrl.info.label or {}
    local label_default = { t='label', target='main', a=a.tr, pa=a.t, jH=a.r}
    for i=1, self.options.numRows do
        local fs = ctrl.cp(label_default)
        fs.name = 'label'..i
        fs.fontFile = ctrl.prefs.mod.info.font.file
        fs.fontSize = ctrl.prefs.mod.info.font.size
        fs.x = ctrl.prefs.mod.info.font.x
        fs.y = ctrl.prefs.mod.info.font.y - ((i-1) * (ctrl.prefs.mod.info.font.spacing))
        fs.t = label_text[i] or ('label'..i)
        ctrl.info.label[i] = ctrl.fs.new(self, fs)
    end
end

function ctrl.info:fs()
    ctrl.info.text = ctrl.info.text or {}
    local fs_default = { t=c.r..'', target='main', a=a.tr, pa=a.tr, jH=a.r}
    for i=1, self.options.numRows do
        local fs = ctrl.cp(fs_default)
        fs.name = 'text'..i
        fs.fontFile = ctrl.prefs.mod.info.box.font.file
        fs.fontSize = ctrl.prefs.mod.info.box.font.size
        fs.x = ctrl.prefs.mod.info.box.x + ctrl.prefs.mod.info.box.font.offset.x
        fs.y = ctrl.prefs.mod.info.box.y - ((i-1) * (ctrl.prefs.mod.info.box.height + ctrl.prefs.mod.info.box.spacing)) + ctrl.prefs.mod.info.box.font.offset.y
        ctrl.info.text[i] = ctrl.fs.new(self, fs)
    end
end

function ctrl.info:lamps()
    ctrl.info.lamp = ctrl.info.lamp or {}
    local lamp_default = { btnColor= {0,1.0,0,0.25}, target='main'}
    for i=1, self.options.numRows do
        local lamp = ctrl.cp(lamp_default)
        lamp.name = 'lamp'..i
        lamp.template = ctrl.prefs.mod.info.lamp.template
        lamp.w = ctrl.prefs.mod.info.lamp.width
        lamp.h = ctrl.prefs.mod.info.lamp.height
        lamp.anchors = {{ a=a.tr, pa=a.tr, x=ctrl.prefs.mod.info.lamp.x, y=ctrl.prefs.mod.info.lamp.y - ((i-1) * ctrl.prefs.mod.info.lamp.spacing)}}
        ctrl.info.lamp[i] = ctrl.btns.new(self, lamp)
        ctrl.info.lamp[i]:off()
    end
end

function ctrl.info:status()
    local line = 1
    local lamp = ctrl.info.lamp[line]
    local text = ctrl.info.text[line]
    local col = c.g
    local rgba = c.rgba.g
    local lamp_value = 0
    local status = 'ok'
    if ctrl.info.taint then
        col = c.r
        rgba = c.rgba.r
        status = 'taint'
    elseif ctrl.info.error then
        col = c.y
        rgba = c.rgba.y
        status = 'err'
    end
    text:SetText(string.format('%s%s', col, status))
    lamp:setColor(rgba[1], rgba[2], rgba[3], rgba[4])
    lamp:setValue(lamp_value)
end

function ctrl.info:fps()
    local line = 2
    local lamp = ctrl.info.lamp[line]
    local text = ctrl.info.text[line]
    local fps = math.floor(GetFramerate()) or 0
    local col = c.b
    local rgba = c.rgba.b
    local lamp_value = 0
    if fps > 90 then
        col = c.c
        rgba = c.rgba.g
    elseif fps > 60 then
        col = c.g
        rgba = c.rgba.g
    elseif fps > 30 then
        col = c.y
        rgba = c.rgba.y
    else
        col = c.r
        rgba = c.rgba.r
        lamp_value = 1
    end
    text:SetText(string.format('%s%d', col, fps))
    lamp:setColor(rgba[1], rgba[2], rgba[3], rgba[4])
    lamp:setValue(lamp_value)
end

function ctrl.info:net()
    local line = 3
    local lamp = ctrl.info.lamp[line]
    local text = ctrl.info.text[line]
    local _, _, latencyHome, latencyWorld = GetNetStats()
    local col = c.o
    local rgba = c.rgba.o
    local lamp_value = 0
    if latencyWorld > 70 then
        col=c.r
        rgba = c.rgba.r
    elseif latencyWorld > 30 then
        col = c.y
        rgba = c.rgba.y
    else
        col = c.r
        rgba = c.rgba.r
        lamp_value = 1
    end
    text:SetText(string.format('%s%d', col, latencyWorld))
    lamp:setColor(rgba[1], rgba[2], rgba[3], rgba[4])
    lamp:setValue(lamp_value)
end

function ctrl.info:mem()
    local line = 4
    local memStr = string.format('%s%s', c.r, 'err')
    local lamp = ctrl.info.lamp[line]
    local text = ctrl.info.text[line]
    local col = c.o
    local rgba = c.rgba.o
    local lamp_value = 0
    UpdateAddOnMemoryUsage()
    local mem = GetAddOnMemoryUsage('ctrl')
    if mem > 10000 then
        col=c.r
        rgba = c.rgba.r
        memStr = string.format('%s%.1f', col, (mem/1000))
        lamp_value = 1
    elseif mem > 1000 then
        col=c.o
        rgba = c.rgba.o
        memStr = string.format('%s%.2f', col, (mem/1000))
        lamp_value = 1
    elseif mem > 500 then
        col=c.y
        rgba = c.rgba.y
        memStr = string.format('%s%d', col, mem)
    else
        col=c.g
        rgba = c.rgba.g
        memStr = string.format('%s%d', col, mem)
    end
    text:SetText(memStr)
    lamp:setColor(rgba[1], rgba[2], rgba[3], rgba[4])
    lamp:setValue(lamp_value)
end

function ctrl.info:sqw()
    local line = 5
    local sqwStr = string.format('%s%s', c.r, 'err')
    local lamp = ctrl.info.lamp[line]
    local text = ctrl.info.text[line]
    local col = c.o
    local rgba = c.rgba.o
    local lamp_value = 0
    local sqw = tonumber(GetCVar('SpellQueueWindow')) or 0
    if sqw > 350 then
        col=c.r
        rgba = c.rgba.r
        lamp_value = 1
    elseif sqw > 300 then
        col=c.y
        rgba = c.rgba.o
        lamp_value = 1
    elseif sqw > 200 then
        col=c.g
        rgba = c.rgba.g
    elseif sqw > 150 then
        col=c.b
        rgba = c.rgba.b
    else
        col=c.v
        rgba = c.rgba.v
        lamp_value = 1
    end
    sqwStr = string.format('%s%d', col, sqw)
    text:SetText(sqwStr)
    lamp:setColor(rgba[1], rgba[2], rgba[3], rgba[4])
    lamp:setValue(lamp_value)
end

function ctrl.info:loot()
    local line = 6
    local lStr = string.format('%s%s', c.r, 'err')
    local lamp = ctrl.info.lamp[line]
    local text = ctrl.info.text[line]
    local col = c.o
    local rgba = c.rgba.o
    local lamp_value = 0
    local l = tonumber(GetCVar('autoLootRate')) or 0
    if l > 70 then
        col=c.r
        rgba = c.rgba.r
        lamp_value = 1
    elseif l > 20 then
        col=c.y
        rgba = c.rgba.y
        lamp_value = 1
    else
        col=c.g
        rgba = c.rgba.g
    end
    lStr = string.format('%s%d', col, l)
    text:SetText(lStr)
    lamp:setColor(rgba[1], rgba[2], rgba[3], rgba[4])
    lamp:setValue(lamp_value)
end

--[[






function ctrl.info:on()
    self:registerTimers()
    self:registerEvents()
    if self.f.main then self.f.main:Show() end
    self.is.on = 1
end

function ctrl.info:off()
    self.is.on = nil
    self:unregisterTimers()
    self:unregisterEvents()
    if self.f.main then self.f.main:Hide() end
end

]]

function ctrl.info.ADDON_ACTION_BLOCKED(isTainted, fn)
    if isTainted then
        ctrl.info.taint = 1
        ctrl.info:warn('Tainted: ', fn)
    end
end

function ctrl.info.ADDON_ACTION_FORBIDDEN(isTainted, fn)
    if isTainted then
        ctrl.info.taint = 1
        ctrl.info:warn('Tainted: ', fn)
    end
end

function ctrl.info.GENERIC_ERROR(err)
    ctrl.info.error = 1
    ctrl.info:warn('GENERIC_ERROR: ', err)
end

function ctrl.info.PLAYER_ENTERING_WORLD()
    ctrl.info.error = nil
    ctrl.info.taint = nil
end

function ctrl.info:update(int)
    self:status()
    self:fps()
    self:net()
    if int > 10 then self:mem() end
    self:sqw()
    self:loot()
end

function ctrl.info:tick(int)
    self:update(int)
end

function ctrl.info:prefs()
    self.options.frame.w = ctrl.prefs.mod[self.name].frame.width
    self.options.frame.h = ctrl.prefs.ui.height
end

function ctrl.info:setup()
    self:prefs()
    self.f.main = ctrl.frame:new(self.options.frame)
    ctrl.tx.generate(ctrl.info, textures)
    self:boxes()
    self:fs()
    self:labels()
    self:lamps()
    self:registerCtrlFrame(2, self.f.main)
end


ctrl.info:init()
