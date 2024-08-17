--[[ ctrl - info.lua - t@wse.nyc - 8/7/24 ]]
--

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'info',
    color = c.w,
    symbol = s.info,
    taint = nil,
    error = nil,
    options = {
        timers = {
            1
        },
        events = {
            'PLAYER_ENTERING_WORLD',
            'ADDON_ACTION_BLOCKED',
            'ADDON_ACTION_FORBIDDEN',
            'GENERIC_ERROR',
        },
        frame = {
            name = 'info',
            w=130,
            h=172,
            x=84,
            y=-32,
            a=a.tl,
            pa=a.bl,
            isResizable = nil,
            isMovable = nil,
            globalName = 'ctrlinfo',
            target = ctrl.pwr.f.main,
        },
    }
}

ctrl.info = ctrl.mod:new(mod)

local ok = [[|cff60f0f9]]

local textures = {
    ['txinfo'] = { target = 'main', t = 'metal_34_v', path = ctrl.p.tx, l = -6 },
    ['tblue1'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=64, h=24, a=a.tl, pa=a.t, x=-20, y=-8 },
    ['tblue2'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=64, h=24, a=a.tl, pa=a.t, x=-20, y=-36 },
    ['tblue3'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=64, h=24, a=a.tl, pa=a.t, x=-20, y=-62 },
    ['tblue4'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=64, h=24, a=a.tl, pa=a.t, x=-20, y=-88 },
    ['tblue5'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=64, h=24, a=a.tl, pa=a.t, x=-20, y=-114 },
    ['tblue6'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=64, h=24, a=a.tl, pa=a.t, x=-20, y=-140 },
}

local fontstrings = {
    ['fsinfo1_t'] = { target='main', t = c.w..'status', fontFile = 'Prompt-Medium.ttf', fontSize = 12, x = -23, y = -15, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo1_v'] = { target='main', t = ok..'ok', fontFile = 'LEDBoard-Bold.ttf', fontPath=ctrl.p.fntorig, fontSize = 15, x = -26, y = -15, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo2_t'] = { target='main', t = c.w..'fps', fontFile = 'Prompt-Medium.ttf', fontSize = 12, x = -23, y = -41, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo2_v'] = { target='main', t = c.c..'100', fontFile = 'LEDBoard-Bold.ttf', fontPath=ctrl.p.fntorig, fontSize = 15, x = -26, y = -42, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo3_t'] = { target='main', t = c.w..'mem', fontFile = 'Prompt-Medium.ttf', fontSize = 12, x = -23, y = -67, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo3_v'] = { target='main', t = c.c..'32', fontFile = 'LEDBoard-Bold.ttf', fontPath=ctrl.p.fntorig, fontSize = 15, x = -26, y = -68, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo4_t'] = { target='main', t = c.w..'ping', fontFile = 'Prompt-Medium.ttf', fontSize = 12, x = -23, y = -93, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo4_v'] = { target='main', t = c.c..'67', fontFile = 'LEDBoard-Bold.ttf', fontPath=ctrl.p.fntorig, fontSize = 15, x = -26, y = -94, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo5_t'] = { target='main', t = c.w..'sqw', fontFile = 'Prompt-Medium.ttf', fontSize = 12, x = -23, y = -119, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo5_v'] = { target='main', t = c.c..'100', fontFile = 'LEDBoard-Bold.ttf', fontPath=ctrl.p.fntorig, fontSize = 15, x = -26, y = -120, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo6_t'] = { target='main', t = c.w..'loot', fontFile = 'Prompt-Medium.ttf', fontSize = 12, x = -23, y = -145, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo6_v'] = { target='main', t = c.c..'6', fontFile = 'LEDBoard-Bold.ttf', fontPath=ctrl.p.fntorig, fontSize = 15, x = -26, y = -146, a=a.tr, pa=a.tr, jH=a.l },
}

local buttons = {
    ['l1'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h = 42, w = 42, anchors = { { a = a.tr, pa = a.tr, x = 9, y = 0 } }},
    ['l2'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h = 42, w = 42, anchors = { { a = a.tr, pa = a.tr, x = 9, y = -26 } }},
    ['l3'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h = 42, w = 42, anchors = { { a = a.tr, pa = a.tr, x = 9, y = -52 } }},
    ['l4'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h = 42, w = 42, anchors = { { a = a.tr, pa = a.tr, x = 9, y = -78 } }},
    ['l5'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h = 42, w = 42, anchors = { { a = a.tr, pa = a.tr, x = 9, y = -104 } }},
    ['l6'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h = 42, w = 42, anchors = { { a = a.tr, pa = a.tr, x = 9, y = -130 } }},
}


function ctrl.info:fps()
    local fps = math.floor(GetFramerate()) or 0
    local col = ok
    if fps > 90 then
        col = ok
        ctrl.info.btn.l2:setColor( 0, 1.0, 0, 0.5 )
        ctrl.info.btn.l2:off()
    elseif fps > 60 then
        col = c.y
        ctrl.info.btn.l2:setColor( 1.0, 1.0, 0, 0.5 )
        ctrl.info.btn.l2:on()
    else
        col = c.r
        ctrl.info.btn.l2:setColor( 1.0, 0, 0, 0.5 )
        ctrl.info.btn.l2:on()
    end
    ctrl.info.fs.fsinfo2_v:SetText(col..tostring(fps))
end

function ctrl.info:net()
    local _, _, latencyHome, latencyWorld = GetNetStats()
    local col2 = ok
    if latencyWorld < 70 then
        col2= ok
        ctrl.info.btn.l4:setColor( 0, 1.0, 0, 0.5 )
        ctrl.info.btn.l4:off()
    elseif latencyWorld < 90 then
        col2 = c.y
        ctrl.info.btn.l4:setColor( 1.0, 1.0, 0, 0.5 )
        ctrl.info.btn.l4:on()
    else
        col2 = c.r
        ctrl.info.btn.l4:setColor( 1.0, 0, 0, 0.5 )
        ctrl.info.btn.l4:on()
    end
    ctrl.info.fs.fsinfo4_v:SetText(col2..tostring(latencyWorld))
end

function ctrl.info:mem()
    local kb = (math.floor(collectgarbage('count') / 1000)) --/ 10
    local col = ok
    if kb < 300 then
        col = ok
        ctrl.info.btn.l3:setColor( 0, 1.0, 0, 0.5 )
        ctrl.info.btn.l3:off()
    elseif kb > 500 then
        col = c.r
        ctrl.info.btn.l3:setColor( 1.0, 0, 0, 0.5 )
        ctrl.info.btn.l3:on()
    else
        col = c.y
        ctrl.info.btn.l3:setColor( 1.0, 1.0, 0, 0.5 )
        ctrl.info.btn.l3:on()
    end
    ctrl.info.fs.fsinfo3_v:SetText(col..tostring(kb))
end

function ctrl.info:sqw()
    local sqw = tonumber(GetCVar('SpellQueueWindow')) or 0
    local col = ok
    if sqw > 350 then
        col = c.r
        ctrl.info.btn.l5:setColor( 1.0, 0, 0, 0.5 )
        ctrl.info.btn.l5:on()
    elseif sqw > 200 then
        col = c.y
        ctrl.info.btn.l5:setColor( 1.0, 1.0, 0, 0.5 )
        ctrl.info.btn.l5:on()
    else
        col = ok
        ctrl.info.btn.l5:setColor( 0, 1.0, 0, 0.5 )
        ctrl.info.btn.l5:off()
    end
    ctrl.info.fs.fsinfo5_v:SetText(col..tostring(sqw))
end

function ctrl.info:loot()
    local l = tonumber(GetCVar('autoLootRate')) or 0
    local col = ok
    if l > 70 then
        col = c.r
        ctrl.info.btn.l6:setColor( 1.0, 0, 0, 0.5 )
        ctrl.info.btn.l6:on()
    elseif l > 20 then
        col = c.y
        ctrl.info.btn.l6:setColor( 1.0, 1.0, 0, 0.5 )
        ctrl.info.btn.l6:on()
    else
        col = ok
        ctrl.info.btn.l6:setColor( 0, 1.0, 0, 0.5 )
        ctrl.info.btn.l6:off()
    end
    ctrl.info.fs.fsinfo6_v:SetText(col..tostring(l))
end


function ctrl.info:status()
    local status = ok..'ok'
    if ctrl.info.taint then
        ctrl.info.btn.l1:setColor( 1.0, 0, 0, 0.5 )
        ctrl.info.btn.l1:on()
        status = c.r..'taint'
    elseif ctrl.info.error then
        ctrl.info.btn.l1:setColor( 1.0, 1.0, 0, 0.5 )
        ctrl.info.btn.l1:on()
        status = c.y..'err'
    else
        ctrl.info.btn.l1:setColor( 0, 1.0, 0, 0.5 )
        ctrl.info.btn.l1:off()
    end
    ctrl.info.fs.fsinfo1_v:SetText(status)
end

function ctrl.info:update()
    self:status()
    self:fps()
    self:net()
    self:mem()
    self:sqw()
    self:loot()
end

function ctrl.info:tick(interval)
    self:update()
end

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


function ctrl.info.setup(self)
    self.f.main = ctrl.frame:new(self.options.frame)
    ctrl.tx.generate(ctrl.info, textures)
    ctrl.btns.generate(ctrl.info, buttons)
    ctrl.fs.generate(ctrl.info, fontstrings)
    ctrl.info.btn.l1:off()
    ctrl.info.btn.l2:off()
    ctrl.info.btn.l3:off()
    ctrl.info.btn.l4:off()
    ctrl.info.btn.l5:off()
    ctrl.info.btn.l6:off()
end

ctrl.info:init()
