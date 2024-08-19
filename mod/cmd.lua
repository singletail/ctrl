--[[ ctrl - cmd.lua - t@wse.nyc - 8/7/24 ]]
--

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'cmd',
    color = c.r,
    symbol = s.ctrl,
    options = {
        events = {
            'UI_SCALE_CHANGED',
        },
        frame = {
            name = 'cmd',
            w=84,
            h=172,
            x=0,
            y=-32,
            a=a.tl,
            pa=a.bl,
            isResizable = nil,
            isMovable = nil,
            globalName = 'ctrlcmd',
            target = ctrl.pwr.f.main,
        },
    }
}

ctrl.cmd = ctrl.mod:new(mod)

local textures = {
    ['txcmd'] = { target = 'main', t = 'metal_half_v', path = ctrl.p.tx, l = -6 },
}

local buttons = {
    [1] = { name = 'b1', t = c.w..'reload', btnColor = { 1.0, 0, 0, 1 }, },
    [2] = { name = 'b2', t = c.w..'fstack', btnColor = { 1.0, 0.5, 0, 0.25 },},
    [3] = { name = 'b3', t = c.w..'etrace', btnColor = { 1.0, 1.0, 0, 0.25 },},
    [4] = { name = 'b4', t = c.w..'tinspect', btnColor = { 0, 1.0, 0, 0.2 },},
    [5] = { name = 'b5', t = c.w..'console', btnColor = { 0.25, 0.5, 1.0, 0.5 },},
    [6] = { name = 'b6', t = c.w..'error', btnColor = { 1.0, 0, 1.0, 0.25 },},
}

function ctrl.cmd:buttons()
    for i=1, #buttons do
        local button = {
            target = ctrl.cmd.f.main,
            template = 'beeg',
            w = 72,
            h = 32,
            x = 0,
            name = buttons[i].name,
        }
        button.btnColor = buttons[i].btnColor
        button.anchors = { { a = a.t, pa = a.t, x = 0, y = ((i-1) * -26) - 4 } }
        ctrl.cmd.btn[buttons[i].name] = ctrl.btns.new(ctrl.cmd, button)
        local fs = { target = ctrl.cmd.btn[buttons[i].name], t = buttons[i].t, fontFile = 'Prompt-Medium.ttf', fontSize = 13, x = 0, y = -1, a = a.c, pa = a.c, jH = a.c }
        ctrl.cmd.fs[buttons[i].name] = ctrl.fs.new(ctrl.cmd, fs)
        ctrl.cmd.btn[buttons[i].name]:setValue(0)
        ctrl.cmd.btn[buttons[i].name]:refresh()
    end
end

function ctrl.cmd:reload(btn)
    btn:on()
    ReloadUI()
end

function ctrl.cmd:framestack(btn)
    btn:toggle()
    UIParentLoadAddOn("Blizzard_DebugTools")
    FrameStackTooltip_Toggle(true, true, true)
end

function ctrl.cmd:etrace(btn)
    UIParentLoadAddOn("Blizzard_EventTrace")
    btn:toggle()
    if btn:getValue() == 1 then
        EventTrace:SetLoggingPaused(false)
    else
        EventTrace:SetLoggingPaused(true)
        EventTrace:Hide()
    end
end

function ctrl.cmd:inspector(btn)
    UIParentLoadAddOn("Blizzard_DebugTools")
    btn:toggle()
    if btn:getValue() == 1 then
        ctrl.cmd.inspectorwindow = DisplayTableInspectorWindow(UIParent)
    else
        if ctrl.cmd.inspectorwindow then 
            ctrl.cmd.inspectorwindow:Hide()
            ctrl.cmd.inspectorwindow = nil
        end
    end
end

function ctrl.cmd:console(btn)
    btn:toggle()
    if btn:getValue() == 1 then
        DeveloperConsole:Show()
    else
        DeveloperConsole:Hide()
    end
end

function ctrl.cmd:error(btn)
    btn:on()
    error("Error.",1)
end

function ctrl.cmd:click(btn)
    if btn.name == 'b1' then
        self:reload(btn)
    elseif btn.name == 'b2' then
        self:framestack(btn)
    elseif btn.name == 'b3' then
        self:etrace(btn)
    elseif btn.name == 'b4' then
        self:inspector(btn)
    elseif btn.name == 'b5' then
        self:console(btn)
    elseif btn.name == 'b6' then
        self:error(btn)
    end
end

function ctrl.cmd:resize()
end

function ctrl.cmd:redraw()
end


function ctrl.cmd.UI_SCALE_CHANGED()
    ctrl.cmd:debug('UI_SCALE_CHANGED - setting window scale to 1')
    ctrl.cmd.f.main:SetScale(1)
    ctrl.cmd.btn.b1:SetScale(1)
    ctrl.cmd.fs.b1:SetScale(1)
end

function ctrl.cmd.setup(self)
    self.f.main = ctrl.frame:new(self.options.frame)
    self.f.main:SetScale(1)
    ctrl.tx.generate(ctrl.cmd, textures)
    self:buttons()
    self:registerCtrlFrame(1, self.f.main)
end

ctrl.cmd:init()
