--[[ ctrl - info.lua - t@wse.nyc - 8/7/24 ]]
--

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'info',
    color = c.o,
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
            w=96,
            h=154,
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


local tboxw = 48
local tboxh = 20
local tboxx = -14

local textures = {
    ['txinfo'] = { target = 'main', t = 'dark1', path = ctrl.p.tx, l=-6, al=0.6 },
    ['tblue1'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=tboxw, h=tboxh, a=a.tl, pa=a.t, x=tboxx, y=-6 },
    ['tblue2'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=tboxw, h=tboxh, a=a.tl, pa=a.t, x=tboxx, y=-30 },
    ['tblue3'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=tboxw, h=tboxh, a=a.tl, pa=a.t, x=tboxx, y=-54 },
    ['tblue4'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=tboxw, h=tboxh, a=a.tl, pa=a.t, x=tboxx, y=-78 },
    ['tblue5'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=tboxw, h=tboxh, a=a.tl, pa=a.t, x=tboxx, y=-102 },
    ['tblue6'] = { target = 'main', t = 'blu_256', path = ctrl.p.tx, l = -4, w=tboxw, h=tboxh, a=a.tl, pa=a.t, x=tboxx, y=-126 },
}

local ifst = 9 
local ifsv = 13 
local fntt = 'AnkaCoder-Regular.ttf'
local fntv = 'LEDBoard.ttf'
local fntx = -18

local fontstrings = {
    -- labels
    ['fsinfo1_t'] = { target='main', t = c.w..'stat', fontFile=fntt, fontSize=ifst, x=fntx, y = -14, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo2_t'] = { target='main', t = c.w..'fps',  fontFile=fntt, fontSize=ifst, x=fntx, y = -38, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo3_t'] = { target='main', t = c.w..'mem',  fontFile=fntt, fontSize=ifst, x=fntx, y = -62, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo4_t'] = { target='main', t = c.w..'ping', fontFile=fntt, fontSize=ifst, x=fntx, y = -86, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo5_t'] = { target='main', t = c.w..'sqw',  fontFile=fntt, fontSize=ifst, x=fntx, y = -110, a=a.tr, pa=a.t, jH=a.r },
    ['fsinfo6_t'] = { target='main', t = c.w..'loot', fontFile=fntt, fontSize=ifst, x=fntx, y = -134, a=a.tr, pa=a.t, jH=a.r },

    -- values
    ['fsinfo1_v'] = { target='main', t = ok..'ok', fontFile = fntv, fontSize=ifsv, fontPath=ctrl.p.fntorig, x = -20, y = -11, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo2_v'] = { target='main', t = c.c..'100', fontFile = fntv, fontSize=ifsv, fontPath=ctrl.p.fntorig, x = -20, y = -35, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo3_v'] = { target='main', t = c.c..'32', fontFile = fntv, fontSize=ifsv, fontPath=ctrl.p.fntorig, x = -20, y = -59, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo4_v'] = { target='main', t = c.c..'67', fontFile = fntv, fontSize=ifsv, fontPath=ctrl.p.fntorig, x = -20, y = -83, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo5_v'] = { target='main', t = c.c..'100', fontFile = fntv, fontSize=ifsv, fontPath=ctrl.p.fntorig, x = -20, y = -107, a=a.tr, pa=a.tr, jH=a.l },
    ['fsinfo6_v'] = { target='main', t = c.c..'6', fontFile = fntv, fontSize=ifsv, fontPath=ctrl.p.fntorig, x = -20, y = -131, a=a.tr, pa=a.tr, jH=a.l },
}

local btnsz = 28
local btnx = 8

local buttons = {
    ['l1'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h=btnsz, w=btnsz, anchors = { { a = a.tr, pa = a.tr, x = btnx, y = -2 } }},
    ['l2'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h=btnsz, w=btnsz, anchors = { { a = a.tr, pa = a.tr, x = btnx, y = -26 } }},
    ['l3'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h=btnsz, w=btnsz, anchors = { { a = a.tr, pa = a.tr, x = btnx, y = -50 } }},
    ['l4'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h=btnsz, w=btnsz, anchors = { { a = a.tr, pa = a.tr, x = btnx, y = -74 } }},
    ['l5'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h=btnsz, w=btnsz, anchors = { { a = a.tr, pa = a.tr, x = btnx, y = -98 } }},
    ['l6'] = { target = 'main', template = 'retrolamp', btnColor = { 0, 1.0, 0, 0.25 }, h=btnsz, w=btnsz, anchors = { { a = a.tr, pa = a.tr, x = btnx, y = -122 } }},
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
    self:registerCtrlFrame(2, self.f.main)
end

ctrl.info:init()
