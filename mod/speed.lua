--[[ ctrl - speed.lua - t@wse.nyc - 11 July 25 ]]

---@class ctrl

local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'speed',
    color = c.g,
    symbol = s.target,
    options = {
        timers = {
            1/15
        },
        events = {
            --'SPEED_UPDATE',
            --'VEHICLE_ANGLE_UPDATE',
        },
        frame = {
            name = 'ctrlspeed',
            w=200,
            h=60,
            x=0,
            y=-40,
            a=a.t,
            pa=a.t,
            isResizable = nil,
            isMovable = 1,
            --globalName = 'ctrlspeed',
            --target = ctrl.power.f.main,
            isClipsChildren = nil,
        },
    }
}

ctrl.speed = ctrl.mod:new(mod)



local subframes = {
    --['bk'] = { anchors = { { a = a.tl, pa = a.tl, x = 12, y = -36 }, { a = a.br, pa = a.br, x = -12, y = 8, isClipsChildren = 1, } } },
    ['fcompass'] = { target = 'main', w = 1024, h = 64, a=a.c, pa=a.c, x=0, y=0 },
}

local textures = {
    ['txbk'] = { target='main', t='mon2_188', path = ctrl.p.tx, l=-6 },
    ['txcompass'] = { target='comp', t='numbers.png', path = ctrl.p.tx, l=-5 },
}

local fontstrings = {
    ['fssym'] = { t="䃿", a=a.tl, pa=a.tl, x=50, y=-10, target='main', fontFile='ProFontWindows-Regular.ttf', fontSize=24,},
    ['fsfake'] = { jH='RIGHT', t=c.r..'888', a=a.tr, pa=a.tr, x=-65, y=-10, target='main', fontFile='DSEG7.ttf', fontPath=ctrl.p.fntold, fontSize=24,},
    ['fsspeed'] = { jH='RIGHT', t='888', a=a.tr, pa=a.tr, x=-65, y=-10, target='main', fontFile='DSEG7.ttf', fontPath=ctrl.p.fntold, fontSize=24,},
    ['fsmax'] = { t='000', a=a.t, pa=a.t, x=-40, y=-40, target='main', fontFile='ProFontWindows-Regular.ttf', fontSize=14,},
    ['fsbonus'] = { t="+000", a=a.t, pa=a.t, x=40, y=-40, target='main', fontFile='ProFontWindows-Regular.ttf', fontSize=14,},
}

ctrl.speed.data = {
    speed = 0,
    max = 0,
    isMounted = false,
    isDragonriding = false,
    isSwimming = false,
    isSubmerged = false,
    isFalling = false,
    bonus = 0,
    color = c.r,
}

--[[
぀ぁ㎃あ󰖃󰵿㎖㎖䅦䂹䅧󰩈
䝚󰂣󰖤󱌇󱗂󱗃󱗀󰞬䐹󰞈󰵤
䜍󰀝󰀞䆗䆷䆸䒖󰗔󰗕䀚䐾䗁󰀜
䆓䈔䕚䕳󰀱䀆󰈓󱙳󱢴󱢺󱢻󰼁䐻󰠳󰢯
䇫䀛䂼䗤䔿䓛󱙝〠󰩇〱󰶦󰀛〵〷䆔ㄪ
ㄓㄑㄢ䡂䣤󰔫󰵎䃒【ぢ䀈䀇䀔䇋䒝
ㄥㄦㄧㄤㄣㄠ㎘󰲖󰲗󰲘䚽󰲾󰲿󰵑䕔䣯
䃿䇛󰇥㏠ど
]]

local ss = {
    walk = '぀',
    run = 'ぁ',
    sprint='㎃',
    mount='󱗀',
    fall='䂹',
    fly = '䀚',
    dragon='䀛',
    fish='󱢺',
    submarine='䕳',
    dead='ぢ',
    ghost='〠',
    limit='ㄪ',
    slow='󰵿',
    still='',
    look='',
    rest='󰋣',
    indoors='󰩈',
    instance='ㄦ',
    maze='ㄤ',
    outdoors='ㄠ',
}

function ctrl.speed:compute()
    local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed('player')
    self.data.isMounted = IsMounted()
    self.data.isFlying = IsFlying('player')
    self.data.isSwimming = IsSwimming('player')
    self.data.isSubmerged = IsSubmerged('player')
    self.data.isFalling = IsFalling('player')
    self.data.bonus = GetSpeed()

    if self.data.isMounted then
        self.data.max = (flightSpeed / BASE_MOVEMENT_SPEED) * 100 or 0
    elseif self.data.isSwimming then
        self.data.max = (swimSpeed / BASE_MOVEMENT_SPEED) * 100 or 0
    else
        self.data.max = (runSpeed / BASE_MOVEMENT_SPEED) * 100 or 0
    end

    local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()

    self.data.isDragonriding = canGlide

    if isGliding then
        self.data.speed = (forwardSpeed / BASE_MOVEMENT_SPEED) * 100 or 0
    else
        self.data.speed = (currentSpeed / BASE_MOVEMENT_SPEED) * 100 or 0
    end
end

function ctrl.speed:status()
    self.data.symbol = '䃿'

    if self.data.isMounted then
        self.data.symbol = c.y..ss.mount
    end

    if self.data.isFlying then
        self.data.symbol = c.y..ss.fly
    end

    if self.data.isDragonriding then
        self.data.symbol = c.g..ss.dragon
    end

    if self.data.isSwimming then
        self.data.symbol = c.c..ss.fish
    end

    if self.data.isSubmerged then
        self.data.symbol = c.b..ss.submarine
    end

    if self.data.isFalling then
        self.data.symbol = c.r..ss.fall
    end

    if UnitIsDead('player') then
        self.data.symbol = c.a..ss.dead
    end

    if UnitIsGhost('player') then
        self.data.symbol = c.a..ss.ghost
    end

    if self.data.symbol == '䃿' then
        if self.data.speed > 0 then
            if self.data.speed > self.data.max then
                self.data.symbol = c.p..ss.sprint
                self.data.color = c.r
            elseif self.data.speed < 100 then
                self.data.symbol = c.o..ss.slow
                self.data.color = c.o
            elseif self.data.speed > 140 then
                self.data.symbol = c.g..ss.run
                self.data.color = c.g
            else
                self.data.symbol = c.v..ss.walk
                self.data.color = c.b
            end
        else
            if IsResting() then
                self.data.symbol = c.a..''
            elseif IsInInstance() then
                self.data.symbol = c.y..ss.instance..'inst'
            elseif IsIndoors() then
                self.data.symbol = c.a..ss.indoors..'ind'
            else
                self.data.symbol = c.a..ss.outdoors..'out'
            end
            self.data.color = c.r
        end
    end
end

function ctrl.speed:draw()
    self.fs.fssym:SetText(self.data.symbol)
    self.fs.fsspeed:SetText(string.format('%s%d', self.data.color, self.data.speed))
    self.fs.fsmax:SetText(string.format('%sㄪ %.2f', c.w, self.data.max))
    self.fs.fsbonus:SetText(string.format('%s+%.2f%%', c.w, self.data.bonus))
end

function ctrl.speed:update()
    self:compute()
    self:status()
    self:draw()
end

function ctrl.speed:tick(interval)
    ctrl.speed:update()
end

function ctrl.speed.setup(self)
    self.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.frame.generate(self, subframes)
    ctrl.tx.generate(self, textures)
    ctrl.fs.generate(self, fontstrings)
    self.fs.fsfake:SetAlpha(0.2)
end

ctrl.speed:init()
