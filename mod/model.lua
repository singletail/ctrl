--[[ ctrl - model.lua - t@wse.nyc - 8/7/24 ]]

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'model',
    color = c.y,
    symbol = s.butt,
    options = {
        events = {
            'PLAYER_TARGET_CHANGED',
        },
        frame = {
            name = 'ctrlmodel',
            w=140,
            h=172,
            x=214,
            y=-32,
            a=a.tl,
            pa=a.bl,
            isResizable = nil,
            isMovable = nil,
            globalName = 'ctrlmodel',
            target = ctrl.pwr.f.main,
            --isClipsChildren = 1,
        },
    }
}

ctrl.model = ctrl.mod:new(mod)

local textures = {
    ['txinfo'] = { target = 'main', t = 'metal_34_v', path = ctrl.p.tx, l = -6 },
    ['tnasa'] = { target = 'main', t = 'nasa_43_c', path = ctrl.p.test, l = -5, w=132, h=164 },
}

function ctrl.model:update()
    ctrl.model.f.player:SetUnit('target')
end



function ctrl.model:tick(interval)
    --ctrl.model:update()
end



function ctrl.model.PLAYER_TARGET_CHANGED()
    ctrl.model:update()
end


function ctrl.model.setup(self)
    ctrl.model.f.main = ctrl.frame.new(ctrl.model, ctrl.model.options.frame)
    ctrl.tx.generate(ctrl.model, textures)

    local pf = {
        class = 'PlayerModel',
        w=140,
        h=172,
        x=0,
        y=0,
        a=a.tl,
        pa=a.tl,
        isResizable = nil,
        isMovable = nil,
        target = ctrl.model.f.main
    }
    ctrl.model.f.player = ctrl.model.f.player or ctrl.frame.new(ctrl.model, pf)
    self:registerCtrlFrame(3, self.f.main)
end

ctrl.model:init()
