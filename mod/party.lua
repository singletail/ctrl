--[[ ctrl - party.lua - t@wse.nyc - 17 July 2025 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'party',
    color = c.b,
    symbol = 'P',
    options = {
        fontSize = 12,
        fontFile = 'Prompt-Regular.ttf',
        numRows = 40,
        numCols = 6,
        border = 8,
        rowHeight = 12,
        rowWidths = {50, 80, 60, 30, 60, 60},
        statusRowSize = 20,
        events = {
        },
        timers = {
            0.1,
        },
        frame = {
            name = 'ctrlparty',
            w=500,
            h=154,
            x=0,
            y=-154,
            isResizable = 1,
            isMovable = 1,
            --target = ctrl.power.f.main,
            isClipsChildren = 1,
            scale = 1,
        },
        debug = 1,
    }
}

ctrl.party = ctrl.mod:new(mod)

ctrl.party.displayTable = {}

local textures = {
    ['bk'] = { target='main', t='dark1', path = ctrl.p.tx, l=-6, al=1 },
    ['fsbk']= { target='main', t='LCDbig.png', path=ctrl.p.tx, l=-5, al=1, x=0, y=0, w=mod.options.frame.w - 8, h=mod.options.frame.h - mod.options.statusRowSize, a=a.b, pa=a.b },
    ['tr1'] = { target='main', t='LCDsm27.png', path=ctrl.p.tx, l=-4, w=36, h=18, a=a.tr, pa=a.tr, x=-186, y=-2 },
    ['tr2'] = { target='main', t='LCDsm27.png', path=ctrl.p.tx, l=-4, w=36, h=18, a=a.tr, pa=a.tr, x=-96, y=-2 },
    --['tr3'] = { target='main', t='LCDsm27.png', path=ctrl.p.tx, l=-4, w=36, h=18, a=a.tr, pa=a.tr, x=-6, y=-2 },
}

local fs_default = {
    target='main',
    fontFile = ctrl.party.options.fontFile,
    fontSize = ctrl.party.options.fontSize,
    a = a.tl,
    pa = a.tl,
    jH = a.l,
    ww = false,
}

local fontstrings = {
    ['h1'] = { t='total:', a=a.tr, pa=a.tr, x=-225, y=-6, target='main', fontFile='Prompt-Regular.ttf', fontSize=(11),},
    ['h2'] = { t='max:', a=a.tr, pa=a.tr, x=-135, y=-6, target='main', fontFile='Prompt-Regular.ttf', fontSize=(11),},
    --['h3'] = { t='aggro:', a=a.tr, pa=a.tr, x=-45, y=-6, target='main', fontFile='Prompt-Regular.ttf', fontSize=(11),},
    ['v1'] = { t='0', a=a.tr, pa=a.tr, x=-188, y=-5, target='main', fontFile='LEDBoard.ttf', fontSize=(13),},
    ['v2'] = { t='0', a=a.tr, pa=a.tr, x=-98, y=-5, target='main', fontFile='LEDBoard.ttf', fontSize=(13),},
    --['v3'] = { t='0', a=a.tr, pa=a.tr, x=-8, y=-5, target='main', fontFile='LEDBoard.ttf', fontSize=(13),},
}

function ctrl.party:createFontStrings()
    ctrl.party.fsdata = ctrl.party.fsdata or {}
    for i=1,self.options.numRows do
        ctrl.party.fsdata[i] = ctrl.party.fsdata[i] or {}
        local curX = self.options.border
        for j=1,self.options.numCols do
            local o = {}
            for k,v in pairs(fs_default) do o[k] = v end
            o.w = self.options.rowWidths[j]
            o.h = self.options.rowHeight
            o.x = curX
            o.y = (self.options.rowHeight * (i-1) + self.options.statusRowSize + (self.options.border / 2)) * -1
            ctrl.party.fsdata[i][j] = ctrl.fs.new(ctrl.party, o)
            curX = curX + self.options.rowWidths[j]
        end
    end
end

function ctrl.party:resize()
    local fsScale = self.f.main:GetWidth() / self.options.frame.w
    for i=1,self.options.numRows do
        for j=1,self.options.numCols do
            if ctrl.party.fsdata and ctrl.party.fsdata[i] and ctrl.party.fsdata[i][j] then
                ctrl.party.fsdata[i][j]:SetScale(fsScale)
            end
        end
    end
end

function ctrl.party:updateDisplayTable()
    ctrl.party.displayTable = {}
    self.unitId, self.groupSize = ctrl.groupConfig()
    for i = 1, self.groupSize do
        local unit = self.unitId .. i
        if unit == 'party5' or unit == 'player1' then unit = 'player' end
        if ctrl.group.unit[unit] then
            local guid = ctrl.group.unit[unit]
            local g = ctrl.group.guid[guid]
            if g then
                g.color = g.color or c.v
                g.name = g.name or "Error"
                g.role = g.role or 'NONE'
                self.displayTable[#self.displayTable+1] = {
                    string.format('%s', unit),
                    string.format('%s%s', g.color, g.name),
                    string.format('%s', g.class),
                    string.format('%s', g.role),
                    string.format('%s', g.specializationID),
                    string.format('%s', g.itemLevel),
                }
            end
        end
    end
end

function ctrl.party:draw()
    for i=1,self.options.numRows do
        for j=1,self.options.numCols do
            local displayString = ''
            if self.displayTable[i] and self.displayTable[i][j] then
                displayString = self.displayTable[i][j] or 'err'
            end
            ctrl.party.fsdata[i][j]:SetText(displayString)
        end
    end
end

function ctrl.party:counters()
    local total = #ctrl.party.displayTable or 0
    local max = self.groupSize or 0
    self.fs.v1:SetText(string.format('%s%d', c.c, total))
    self.fs.v2:SetText(string.format('%s%d', c.y, max))
end

function ctrl.party:update()
    self:updateDisplayTable()
    self:draw()
    self:counters()
end

function ctrl.party:tick(interval)
    ctrl.party:update()
end

function ctrl.party.setup(self)
    self.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.tx.generate(self, textures)
    ctrl.fs.generate(self, fontstrings)
    self:createFontStrings()
    --self:registerCtrlFrame(4, self.f.main)
end

ctrl.party:init()