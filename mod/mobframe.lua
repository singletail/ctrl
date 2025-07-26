--[[ ctrl - mobframe.lua - t@wse.nyc - 6/12/25 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'mobframe',
    color = c.o,
    symbol = '%',
    options = {
        numRows = 20,
        numCols = 5,
        border = 8,
        rowHeight = 12,
        rowWidths = {160, 40, 20, 20, 20},
        statusRowSize = 20,
        events = {
        },
        timers = {
            0.1,
        },
        frame = {
            name = 'ctrlmobframe',
            isResizable = 1,
            target = ctrl.power.f.main,
            isClipsChildren = 1,
        },
        debug = 1,
    }
}

ctrl.mobframe = ctrl.mod:new(mod)

ctrl.mobframe.displayTable = {}

local textures = {
    ['bk'] = { target='main', t='dark1', path = ctrl.p.tx, l=-6, al=0.6 },
    ['tr1'] = { target='main', t='LCDsm27.png', path=ctrl.p.tx, l=-4, w=36, h=18, a=a.tr, pa=a.tr, x=-186, y=-2 },
    ['tr2'] = { target='main', t='LCDsm27.png', path=ctrl.p.tx, l=-4, w=36, h=18, a=a.tr, pa=a.tr, x=-96, y=-2 },
    ['tr3'] = { target='main', t='LCDsm27.png', path=ctrl.p.tx, l=-4, w=36, h=18, a=a.tr, pa=a.tr, x=-6, y=-2 },
}

local fs_default = {
    target='main',
    a = a.tl,
    pa = a.tl,
    jH = a.l,
    ww = false,
}

local fontstrings = {
    ['h1'] = { t='total:', a=a.tr, pa=a.tr, x=-225, y=-6, target='main', fontFile='Prompt-Regular.ttf', fontSize=(11),},
    ['h2'] = { t='combat:', a=a.tr, pa=a.tr, x=-135, y=-6, target='main', fontFile='Prompt-Regular.ttf', fontSize=(11),},
    ['h3'] = { t='aggro:', a=a.tr, pa=a.tr, x=-45, y=-6, target='main', fontFile='Prompt-Regular.ttf', fontSize=(11),},
    ['v1'] = { t='0', a=a.tr, pa=a.tr, x=-188, y=-5, target='main', fontFile='LEDBoard.ttf', fontSize=(13),},
    ['v2'] = { t='0', a=a.tr, pa=a.tr, x=-98, y=-5, target='main', fontFile='LEDBoard.ttf', fontSize=(13),},
    ['v3'] = { t='0', a=a.tr, pa=a.tr, x=-8, y=-5, target='main', fontFile='LEDBoard.ttf', fontSize=(13),},
}

function ctrl.mobframe:createFontStrings()
    ctrl.mobframe.fsdata = ctrl.mobframe.fsdata or {}
    for i=1,self.options.numRows do
        ctrl.mobframe.fsdata[i] = ctrl.mobframe.fsdata[i] or {}
        local curX = self.options.border
        for j=1,self.options.numCols do
            local o = {}
            for k,v in pairs(fs_default) do o[k] = v end
            o.fontFile = ctrl.prefs.mod.mobframe.font.file
            o.fontSize = ctrl.prefs.mod.mobframe.font.size
            o.w = self.options.rowWidths[j]
            o.h = self.options.rowHeight
            o.x = curX
            o.y = (self.options.rowHeight * (i-1) + self.options.statusRowSize + (self.options.border / 2)) * -1
            ctrl.mobframe.fsdata[i][j] = ctrl.fs.new(ctrl.mobframe, o)
            curX = curX + self.options.rowWidths[j]
        end
    end
end

function ctrl.mobframe:resize()
    local fsScale = self.f.main:GetWidth() / self.options.frame.w
    for i=1,self.options.numRows do
        for j=1,self.options.numCols do
            if ctrl.mobframe.fsdata and ctrl.mobframe.fsdata[i] and ctrl.mobframe.fsdata[i][j] then
                ctrl.mobframe.fsdata[i][j]:SetScale(fsScale)
            end
        end
    end
end

function ctrl.mobframe:updateDisplayTable()
    ctrl.mobframe.displayTable = {}
    for _, mob in pairs(ctrl.mob.guid) do
        if not mob then return end
        mob.color = mob.color or c.v
        mob.name = mob.name or "Error"
        mob.spawnId = mob.spawnId or 999
        self.displayTable[#self.displayTable+1] = {
            string.format('%s%s %d', mob.color, mob.name, mob.spawnId),
            string.format('%d%%', mob.healthPct),
            string.format('%d', mob.range),
            mob.inCombat and '*' or '',
            string.format('%d', mob.last - mob.time),
        }
    end
end

function ctrl.mobframe:draw()
    for i=1,self.options.numRows do
        for j=1,self.options.numCols do
            local displayString = ''
            if self.displayTable[i] and self.displayTable[i][j] then
                displayString = self.displayTable[i][j] or 'err'
            end
            ctrl.mobframe.fsdata[i][j]:SetText(displayString)
        end
    end
end

function ctrl.mobframe:counters()
    local total = ctrl.mob.count.total or 0
    local combat = ctrl.mob.count.combat or 0
    local aggro = ctrl.mob.count.tanking or 0
    self.fs.v1:SetText(string.format('%s%d', c.c, total))
    self.fs.v2:SetText(string.format('%s%d', c.y, combat))
    self.fs.v3:SetText(string.format('%s%d', c.p, aggro))
end

function ctrl.mobframe:update()
    self:updateDisplayTable()
    self:draw()
    self:counters()
end

function ctrl.mobframe:tick(interval)
    ctrl.mobframe:update()
end

function ctrl.mobframe:prefs()
    self.options.frame.w = ctrl.prefs.mod[self.name].frame.width
    self.options.frame.h = ctrl.prefs.ui.height
end

function ctrl.mobframe.setup(self)
    self:prefs()
    self.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.tx.generate(self, textures)
    ctrl.fs.generate(self, fontstrings)
    self:createFontStrings()
    self:registerCtrlFrame(5, self.f.main)
end

ctrl.mobframe:init()