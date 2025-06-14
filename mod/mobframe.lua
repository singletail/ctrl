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
        numCols = 5,
        border = 10,
        events = {
        },
        timers = {
            0.1,
        },
        frame = {
            name = 'ctrlmobframe',
            w=360,
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
    ['bk'] = { target='main', t='bluebk_full_256', path=ctrl.p.tx, l=-5, al=0.5 },
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
    --['fs1'] = { fontFile = 'Prompt-Regular.ttf', fontSize = 14,},
}

function ctrl.mobframe:createFontStrings()
    local fs = {}
    local numRows = ctrl.mobframe.options.numRows
    local numCols = ctrl.mobframe.options.numCols
    local w = ctrl.mobframe.options.frame.w
    local h = ctrl.mobframe.options.frame.h
    local border = ctrl.mobframe.options.border
    local rowh = 12 -- (h - (border * 2)) / numRows
    local rowwidths = {160, 40, 40, 20, 100}

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
    for guid, mob in pairs(ctrl.mob.guid) do
        if not mob then return end
        ctrl.mobframe.displayTable[#ctrl.mobframe.displayTable+1] = {
            string.format('%s %d', mob.name, mob.spawnId),
            string.format('%d%%', mob.healthPct),
            string.format('%d', mob.range),
            mob.inCombat and '*' or '',
            mob.unitClassification,
        }
    end
end

-- name-spawnId, health, range, incombat, classification

local displayString = ''
function ctrl.mobframe:draw()
    for i=1,ctrl.mobframe.options.numRows do
        if ctrl.mobframe.displayTable[i] then
            for j=1,ctrl.mobframe.options.numCols do
                ctrl.mobframe.fs['fs'..i..j]:SetText(ctrl.mobframe.displayTable[i][j])
            end
        else
            for j=1,ctrl.mobframe.options.numCols do
                ctrl.mobframe.fs['fs'..i..j]:SetText('')
            end
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