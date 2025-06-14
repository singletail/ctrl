--[[ ctrl - mobframe.lua - t@wse.nyc - 6/12/25 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'mobframe',
    color = c.o,
    symbol = '%',
    options = {
        numRows = 40,
        numCols = 4,
        border = 10,
        events = {
        },
        timers = {
            5,
        },
        frame = {
            name = 'ctrlmobframe',
            w=600,
            h=500,
            x=200,
            y=-100,
            a=a.tl,
            pa=a.bl,
            isResizable = 1,
            isMovable = 1,
            globalName = 'ctrlmobframe',
            --target = ctrl.pwr.f.main,
            isClipsChildren = 1,
            scale = 1,
        },
        debug = 1,
    }
}

ctrl.mobframe = ctrl.mod:new(mod)

local textures = {
    ['info'] = { target = 'main', t = 'metal_34_v', path = ctrl.p.tx, l = -6 },
    ['bk'] = { target = 'main', t = 'bluebk_full_256', path = ctrl.p.tx, l = -5, w=210, h=164 },
}

local fs_default = {
    t='',
    target='main',
    fontFile = 'Prompt-Regular.ttf',
    fontSize = 10,
    a = a.tl,
    pa = a.tl,
    jH = a.l,
    ww = false,
}

local fontstrings = {
    ['fs1'] = { fontFile = 'Prompt-Regular.ttf', fontSize = 14,},
}

function ctrl.mobframe:createFontStrings()
    local fs = {} -- fontstrings holder
    local numRows = ctrl.mobframe.options.numRows
    local numCols = ctrl.mobframe.options.numCols
    local w = ctrl.mobframe.options.frame.w
    local h = ctrl.mobframe.options.frame.h
    local border = ctrl.mobframe.options.border
    local rowh = (h - (border * 2)) / numRows
    local rowwidths = {80, 140, 40, 4340}

    for i=1,numRows do
        local curX = border + 10
        for j=1,numCols do
            local o = {}
            for k,v in pairs(fs_default) do o[k] = v end
            o.w = rowwidths[j]
            o.h = rowh
            o.x = curX
            o.y = (rowh * (i-1) + border) * -1
            ctrl.mobframe.fs['fs'..i..j] = ctrl.fs.new(ctrl.mobframe, o)
            ctrl.mobframe.fs['fs'..i..j]:SetText(curX)
            curX = curX + rowwidths[j]
        end
    end
end

function ctrl.mobframe:resize()
    local fw = ctrl.mobframe.f.main:GetWidth()
    local fh = ctrl.mobframe.f.main:GetHeight()
    local b = ctrl.mobframe.options.border
    local origw = ctrl.mobframe.options.frame.w
    local origh = ctrl.mobframe.options.frame.h
    local scale = fw / origw

    ctrl.mobframe.tx.bk:ClearAllPoints()
    ctrl.mobframe.tx.bk:SetPoint('TOPLEFT', ctrl.mobframe.f.main, 'TOPLEFT', b, -b)
    ctrl.mobframe.tx.bk:SetPoint('BOTTOMRIGHT', ctrl.mobframe.f.main, 'BOTTOMRIGHT', -b, b)

    local numRows = ctrl.mobframe.options.numRows
    local numCols = ctrl.mobframe.options.numCols
    for i=1,numRows do
        for j=1,numCols do
            if ctrl.mobframe.fs['fs'..i..j] then
                local fs = ctrl.mobframe.fs['fs'..i..j]
                fs:SetScale(scale)
            end
        end
    end
end

ctrl.mobframe.displayTable = {}

function ctrl.mobframe:updateDisplayTable()
    ctrl.mobframe.displayTable = {}
    local displayTableSize = 0
    for guid, mob in pairs(ctrl.mob.guid) do
        table.insert(ctrl.mobframe.displayTable, {guid=guid, unit=mob.unit, name=mob.displayName, healthPct=mob.healthPct})
        displayTableSize = displayTableSize + 1
    end
    if ctrl.mobframe.options.debug then
        ctrl.mobframe:debug(ctrl.c.p..'displayTableSize: ' .. displayTableSize)
    end
end

function ctrl.mobframe:draw()
    if ctrl.mobframe.options.debug then
        ctrl.mobframe:debug(ctrl.c.r..'draw()')
    end
    local numRows = ctrl.mobframe.options.numRows
    local numCols = ctrl.mobframe.options.numCols
    for i=1,numRows do
        local tempstring = ''
        if ctrl.mobframe.displayTable[i] then
            tempstring = ctrl.mobframe.displayTable[i].unit or '[nil]'
            ctrl.mobframe.fs['fs'..i..1]:SetText(tempstring)
            tempstring = ctrl.mobframe.displayTable[i].name or '[nil]'
            ctrl.mobframe.fs['fs'..i..2]:SetText(tempstring)
            tempstring = ctrl.mobframe.displayTable[i].healthPct or '[nil]'
            ctrl.mobframe.fs['fs'..i..3]:SetText(tempstring)
            tempstring = ctrl.mobframe.displayTable[i].guid or '[nil]'
            ctrl.mobframe.fs['fs'..i..4]:SetText(tempstring)
        else
            ctrl.mobframe.fs['fs'..i..1]:SetText('-')
            ctrl.mobframe.fs['fs'..i..2]:SetText('-')
            ctrl.mobframe.fs['fs'..i..3]:SetText('-')
            ctrl.mobframe.fs['fs'..i..4]:SetText('-')
        end
    end
end

function ctrl.mobframe:clear()
    local numRows = ctrl.mobframe.options.numRows
    local numCols = ctrl.mobframe.options.numCols
    for i=1,numRows do
        for j=1,numCols do
            if ctrl.mobframe.fs['fs'..i..j] then ctrl.mobframe.fs['fs'..i..j]:SetText('') end
        end
    end
end

function ctrl.mobframe:update()
    self:updateDisplayTable()
    self:draw()
end

function ctrl.mobframe:tick(interval)
    ctrl.mobframe:update()
end

function ctrl.mobframe.setup(self)
    ctrl.mobframe.f.main = ctrl.frame.new(ctrl.mobframe, ctrl.mobframe.options.frame)
    ctrl.tx.generate(ctrl.mobframe, textures)
    ctrl.mobframe:createFontStrings()
    --self:registerCtrlFrame(5, self.f.main)
end

ctrl.mobframe:init()