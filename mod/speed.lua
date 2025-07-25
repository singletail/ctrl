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
        },
        frame = {
            name = 'ctrlspeed', target = ctrl.power.f.main,
            isResizable = nil, isMovable = nil, isClipsChildren = 1,
        },
    }
}

ctrl.speed = ctrl.mod:new(mod)

local subframes = {
    --['fclip'] = { target='main', w=64, h=26, a=a.b, pa=a.b, x=0, y=4, isClipsChildren=1 },
    --['fcomp'] = { target='fclip', w=484, h=30, a=a.br, pa=a.br, x=0, y=0, isClipsChildren=1 },
}

local textures = {
    ['bk'] = { t='dark1', target='main', l=-8, al=0.6 },
    ['txicon'] = { t='LCDsm27.png', target='main', l=-7, a=a.t, pa=a.t, w=32, h=26, x=0, y=-2, al=0.8 },
    ['txdisp'] = { t='LCDsm27.png', target='main', l=-7, a=a.t, pa=a.t, w=56, h=28, x=0, y=-29, al=0.8 },
    ['txstat1'] = { t='LCDsm27.png', target='main', l=-7, a=a.b, pa=a.b, w=46, h=18, x=0, y=52, al=0.8 },
    ['txstat2'] = { t='LCDsm27.png', target='main', l=-7, a=a.b, pa=a.b, w=46, h=18, x=0, y=33, al=0.8 },
    --['compbk'] = { t='LCDsm27.png', target='main', l=-7, a=a.b, pa=a.b, w=68, h=30, x=0, y=2, al=0.8 },
    --['comp'] = { target='fcomp', t='numbers.png', l=0 },
}

local fontstrings = {
    ['fsicon'] = { t="䃿", a=a.t, pa=a.t, target='main'},
    ['fsfake'] = { jH='RIGHT', t=c.r..'888', a=a.t, pa=a.t, target='main'},
    ['fsspeed'] = { jH='RIGHT', t=c.r..'888', a=a.t, pa=a.t, target='main'},
    ['fsmax'] = { t=c.c..'000', a=a.b, pa=a.b, x=-7, y=53, w=52, h=18, target='main', jH='RIGHT'},
    ['fsmaxplus'] = { t=c.c..'^', a=a.b, pa=a.b, x=-6, y=52, w=24, h=18, target='main', jH='LEFT', fontFile='ProFontWindows-Regular', fontSize=18},
    ['fsbonus'] = { t=c.p.."000", a=a.b, pa=a.b, x=-7, y=34, w=52, h=18, target='main', jH='RIGHT'},
    ['fsbonusplus'] = { t=c.p..'+', a=a.b, pa=a.b, x=-6, y=33, w=24, h=18, target='main', jH='LEFT', fontFile='ProFontWindows-Regular', fontSize=18},
}

ctrl.speed.data = {
    speed = 0,
    max = 0,
    currentSpeed = 0,
    runSpeed = 0,
    flightSpeed = 0,
    swimSpeed = 0,
    bonusSpeed = 0,
    canGlide = nil,
    isGliding = nil,
    forwardSpeed = 0,
    isMoving = nil,
    isLooking = nil,
    isTurning = nil,
    isMounted = nil,
    isFlying = nil,
    isSwimming = nil,
    isSubmerged = nil,
    isFalling = nil,
    facing = 0,
    color = c.w,
    icon = '䃿'
}

function ctrl.speed.SPEED_UPDATE()
    ctrl.speed.data.bonus = GetSpeed()
end

function ctrl.speed.PLAYER_STARTED_MOVING()
    ctrl.speed.data.isMoving = 1
end

function ctrl.speed.PLAYER_STOPPED_MOVING()
    ctrl.speed.data.isMoving = nil
end

function ctrl.speed.PLAYER_STARTED_LOOKING()
    ctrl.speed.data.isLooking = 1
end

function ctrl.speed.PLAYER_STOPPED_LOOKING()
    ctrl.speed.data.isLooking = nil
end

function ctrl.speed.PLAYER_STARTED_TURNING()
    ctrl.speed.data.isTurning = 1
end

function ctrl.speed.PLAYER_STOPPED_TURNING()
    ctrl.speed.data.isTurning = nil
end

function ctrl.speed:draw()
    self.fs.fsspeed:SetText(string.format('%s%d', self.data.color, (self.data.speed / 7 * 100)))
    self.fs.fsicon:SetText(string.format('%s%s', self.data.color, self.data.icon))
    self.fs.fsfake:SetText(string.format('%s%d', self.data.color, '888'))
    self.fs.fsmax:SetText(string.format('%s%d', c.c, (self.data.max / 7 * 100)))
    self.fs.fsbonus:SetText(string.format('%s%.1f', c.p, self.data.bonus))
end

function ctrl.speed:facing()
    if IsInInstance() then
        if self.f.compassBar:IsShown() then
            self.f.compassBar:Hide()
        end
    else
        local facing = GetPlayerFacing()
        facing = facing or 0
        self.data.facing = math.deg(facing)
        --self:debug(facing, self.data.facing)
        self.f.compassBar:ClearAllPoints()
        local newx = self.data.facing - 16
        if newx < 30 then newx = newx + 360 end
        self.f.compassBar:SetPoint(a.br, self.f.compassContainer, a.br, newx, 0)
        if not self.f.compassBar:IsShown() then
            self.f.compassBar:Show()
        end
    end
end

function ctrl.speed:icon()
    if self.data.canGlide then --dragonriding
        if self.data.isGliding then
            self.data.color = c.g
            self.data.icon = s.isGliding
        else
            self.data.color = c.r
            self.data.icon = s.canGlide
        end
    elseif self.data.isMounted then
        if self.data.isFlying then
            if self.data.speed >= self.data.max then
                self.data.color = c.g
                self.data.icon = s.isFlyingFast
            elseif self.data.speed > 0 then
                self.data.color = c.y
                self.data.icon = s.isFlyingSlow
            else
                self.data.color = c.r
                self.data.icon = s.isOnFlyingMount
            end
        else
            if self.data.speed >= self.data.max then
                self.data.color = c.g
                self.data.icon = s.isDrivingFast
            elseif self.data.speed > 0 then
                self.data.color = c.y
                self.data.icon = s.isDrivingSlow
            else
                self.data.color = c.r
                self.data.icon = s.isOnGroundMount
            end
        end
    elseif self.data.isSwimming then
        if self.data.speed >= self.data.max then
            self.data.color = c.g
            self.data.icon = s.isSwimmingFast
        elseif self.data.speed > 0 then
            self.data.color = c.y
            self.data.icon = s.isSwimmingSlow
        else
            self.data.color = c.r
            self.data.icon = s.isSwimming
        end
    elseif self.data.isFalling then
        self.data.color = c.r
        self.data.icon = s.isFalling
    else
        if self.data.speed >= self.data.max then
            self.data.color = c.c
            self.data.icon = s.isZooming
        elseif self.data.speed > 10 then
            self.data.color = c.g
            self.data.icon = s.isRunning
        elseif self.data.speed > 0 then
            self.data.color = c.y
            self.data.icon = s.isWalking
        elseif self.data.isTurning then
            self.data.color = c.w
            self.data.icon = s.isTurning
        elseif self.data.isLooking then
            self.data.color = c.w
            self.data.icon = s.isLooking
        else
            self.data.color = c.r
            self.data.icon = s.isStill
        end
    end
end

function ctrl.speed:compute()
    if self.data.canGlide then
        self.data.speed = self.data.forwardSpeed
        self.data.max = self.data.flightSpeed
    else
        self.data.speed = self.data.currentSpeed
        if self.data.isMounted then
            self.data.max = self.data.flightSpeed
        elseif self.data.isSwimming then
            self.data.max = self.data.swimSpeed
        else
            self.data.max = self.data.runSpeed
        end
    end
end

function ctrl.speed:getData()
    local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed('player')
    self.data.currentSpeed = currentSpeed
    self.data.runSpeed = runSpeed
    self.data.flightSpeed = flightSpeed
    self.data.swimSpeed = swimSpeed

    local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
    self.data.isGliding = isGliding
    self.data.canGlide = canGlide
    self.data.forwardSpeed = forwardSpeed

    self.data.bonus = GetSpeed()
    self.data.isMounted = IsMounted()
    self.data.isFlying = IsFlying('player')
    self.data.isSwimming = IsSwimming('player')
    self.data.isFalling = IsFalling('player')
end

function ctrl.speed:update()
    self:getData()
    self:compute()
    self:icon()
    self:draw()
    --if ctrl.prefs.mod[self.name].compass then self:facing() end
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

function ctrl.speed:addCompass()
    local cc_opt = {name='ctrlspdcmp', target=ctrl.speed.f.main, isResizable=nil, isMovable=nil, isClipsChildren=1, w=64, h=26, a=a.b, pa=a.b, x=0, y=4}
    local cb_opt = {name='ctrlspdcmpf', target=ctrl.speed.f.compassContainer, isResizable=nil, isMovable=nil, isClipsChildren=1, w=484, h=30, a=a.br, pa=a.br}
    local ctx_opt = {t='numbers.png', target=ctrl.speed.f.compassBar, l=-5}
    self.f.compassContainer = ctrl.frame.new(self, cc_opt)
    self.f.compassBar = ctrl.frame:new(cb_opt)
    self.tx.compass = ctrl.tx:new(ctx_opt)
end

function ctrl.speed.setup(self)
    self:prefs()
    self.f.main = ctrl.frame.new(self, self.options.frame)
    --ctrl.frame.generate(self, subframes)
    ctrl.tx.generate(self, textures)
    ctrl.fs.generate(self, fontstrings)
    --self.f.fcomp:SetClampedToScreen(false)
    self.fs.fsfake:SetAlpha(0.2)

    if ctrl.prefs.mod[self.name].compass then self:addCompass() end

    self:registerCtrlFrame(4, self.f.main)
    ctrl:inspect(ctrl.speed)
end

ctrl.speed:init()
