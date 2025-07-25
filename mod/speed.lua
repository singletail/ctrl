--[[ ctrl - speed.lua - t@wse.nyc - 11 July 25 ]]

---@class ctrl

local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'speed',
    color = c.g,
    symbol = s.target,
    options = {
        timers = { 1 },
        events = {
            'SPEED_UPDATE',
            'PLAYER_STARTED_MOVING',
            'PLAYER_STOPPED_MOVING',
            'PLAYER_STARTED_LOOKING',
            'PLAYER_STOPPED_LOOKING',
            'PLAYER_STARTED_TURNING',
            'PLAYER_STOPPED_TURNING',
            'VEHICLE_UPDATE',
        },
        frame = {
            name = 'ctrlspeed', target = ctrl.power.f.main,
            isResizable = nil, isMovable = nil, isClipsChildren = 1,
        },
    }
}

ctrl.speed = ctrl.mod:new(mod)


local subframes = {
    ['fcomp'] = { target='main', w=66, h = 28, a=a.b, pa=a.b, x=0, y=3, isClipsChildren=1 },
}

local textures = {
    ['bk'] = { t='dark1', target='main', l=-8, al=0.6 },
    ['txicon'] = { t='LCDsm27.png', target='main', l=-7, a=a.t, pa=a.t, w=32, h=26, x=0, y=-2, al=0.8 },
    ['txdisp'] = { t='LCDsm27.png', target='main', l=-7, a=a.t, pa=a.t, w=56, h=28, x=0, y=-29, al=0.8 },
    ['txstat1'] = { t='LCDsm27.png', target='main', l=-7, a=a.b, pa=a.b, w=46, h=18, x=0, y=52, al=0.8 },
    ['txstat2'] = { t='LCDsm27.png', target='main', l=-7, a=a.b, pa=a.b, w=46, h=18, x=0, y=33, al=0.8 },
    ['compbk'] = { t='LCDsm27.png', target='main', l=-7, a=a.b, pa=a.b, w=68, h=30, x=0, y=2, al=0.8 },
    ['comp'] = { target='fcomp', t='numbers.png', w=512, h=32, x=-16, y=-2, l=-6, a=a.bl, pa=a.bl, al=0.7 },
}

local fontstrings = {
    ['fsicon'] = { t="䃿", a=a.t, pa=a.t, target='main'},
    ['fsfake'] = { jH='RIGHT', t=c.r..'888', a=a.t, pa=a.t, target='main'},
    ['fsspeed'] = { jH='RIGHT', t=c.r..'888', a=a.t, pa=a.t, target='main'},
    ['fsmax'] = { t=c.c..'000', a=a.b, pa=a.b, x=-7, y=53, w=52, h=18, target='main', jH='RIGHT'},
    ['fsmaxplus'] = { t=c.c..'^', a=a.b, pa=a.b, x=-6, y=52, w=24, h=18, target='main', jH='LEFT', fontFile='ProFontWindows-Regular', fontSize=18},
    ['fsbonus'] = { t=c.g.."000", a=a.b, pa=a.b, x=-7, y=34, w=52, h=18, target='main', jH='RIGHT'},
    ['fsbonusplus'] = { t=c.g..'+', a=a.b, pa=a.b, x=-6, y=33, w=24, h=18, target='main', jH='LEFT', fontFile='ProFontWindows-Regular', fontSize=18},
}

ctrl.speed.data = {
    raw = 0,
    speed = 0,
    max = 0,
    isMounted = false,
    isDragonriding = false,
    isSwimming = false,
    isSubmerged = false,
    isFalling = false,
    bonus = 0,
    color = c.r,
    symbol = '䃿'
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
    ac = '〰',
    engine = '〲',
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
    still='䅯',
    look='',
    rest='󰋣',
    indoors='󰩈',
    instance='ㄦ',
    maze='ㄤ',
    outdoors='ㄠ',
}

--[[
〰 〱 〴 〵 〶 〻 ぀ ぁ ㄨ ㄩ 䗾 䘋 䖤       󰑣 󰔫 󰔬 󰡳 󰡴 󰡵 󰮯
ㄔ 䇫 䆦 䆓 䅯 䅭 䅧 䅦 䅬 䉶 䐾


]]

-- GetPlayerFacing() --radians

function ctrl.speed:getIcon()
    if self.data.speed == 0 then
        if IsResting() then
            return ss.rest
        elseif IsSwimming('player') then
            return ss.fish
        elseif IsFlying('player') then
            return ss.fly
        elseif IsMounted() then
            return ss.engine
        else
            return ss.still
        end
    end
end

function ctrl.speed:compute()
    local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed('player')
    self.data.raw = currentSpeed

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
                self.data.symbol = c.y..ss.instance
            elseif IsIndoors() then
                self.data.symbol = c.a..ss.indoors
            else
                self.data.symbol = c.a..ss.outdoors
            end
            self.data.color = c.r
        end
    end
end

function ctrl.speed:draw()
    self.fs.fsicon:SetText(self.data.symbol)
    self.fs.fsspeed:SetText(string.format('%s%d', self.data.color, self.data.speed))
    self.fs.fsmax:SetText(string.format('%s%.1f', c.c, self.data.max))
    self.fs.fsbonus:SetText(string.format('%s%.1f', c.g, self.data.bonus))
end

function ctrl.speed:update()
    self:compute()
    self:status()
    self:draw()
end

function ctrl.speed:tick(interval)
    ctrl.speed:update()
end

function ctrl.speed:prefs()
    self.options.frame.w = ctrl.prefs.mod[self.name].frame.width
    self.options.frame.h = ctrl.prefs.ui.height
    ctrl.merge(fontstrings['fsicon'], ctrl.prefs.mod[self.name].icon)
    ctrl.merge(fontstrings['fsfake'], ctrl.prefs.mod[self.name].display)
    ctrl.merge(fontstrings['fsspeed'], ctrl.prefs.mod[self.name].display)
    ctrl.merge(fontstrings['fsmax'], ctrl.prefs.mod[self.name].stats)
    ctrl.merge(fontstrings['fsbonus'], ctrl.prefs.mod[self.name].stats)
end

function ctrl.speed.setup(self)
    self:prefs()
    self.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.frame.generate(self, subframes)
    ctrl.tx.generate(self, textures)
    ctrl.fs.generate(self, fontstrings)
    self.fs.fsfake:SetAlpha(0.2)
    self:registerCtrlFrame(4, self.f.main)
end

ctrl.speed:init()
