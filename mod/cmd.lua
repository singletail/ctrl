--[[ ctrl - cmd.lua - t@wse.nyc - 8/7/24 ]]

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
            name = 'cmd', w=0, h=0, x=0, y=0, a=a.tl, pa=a.tl, isResizable = nil, isMovable = nil, target = ctrl.power.f.main,
        },
    }
}

ctrl.cmd = ctrl.mod:new(mod)

local textures = {
    ['maindark'] = { t='dark1', path=ctrl.p.tx, target='main', l=-6, al=0.8 },
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
            w = self.options.buttons.width,
            h = self.options.buttons.height,
            name = buttons[i].name,
        }
        button.btnColor = buttons[i].btnColor
        button.anchors = {{a=a.t, pa=a.t, x=0, y=((i-1) * - (self.options.buttons.height + self.options.buttons.spacing)) - self.options.buttons.top }}
        ctrl.cmd.btn[buttons[i].name] = ctrl.btns.new(ctrl.cmd, button)

        local fs = {target = ctrl.cmd.btn[buttons[i].name], t=buttons[i].t, fontFile=self.options.font.file, fontSize=self.options.font.size, x=self.options.font.offset.x, y=self.options.font.offset.y, a = a.c, pa = a.c, jH = a.c }
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
    ctrl.cmd.f.main:SetScale(ctrl.prefs.ui.scale)
end

function ctrl.cmd:prefs()
    self.options.frame.w = ctrl.prefs.mod[self.name].frame.width
    self.options.frame.h = ctrl.prefs.ui.height
    self.options.buttons = {
        width = ctrl.prefs.mod[self.name].buttons.width,
        height = ctrl.prefs.mod[self.name].buttons.height,
        spacing = ctrl.prefs.mod[self.name].buttons.spacing,
        top = ctrl.prefs.mod[self.name].buttons.top,
    }
    self.options.font = {
        file = ctrl.prefs.mod[self.name].font.file,
        size = ctrl.prefs.mod[self.name].font.size,
        offset = {
            x = ctrl.prefs.mod[self.name].font.offset.x,
            y = ctrl.prefs.mod[self.name].font.offset.y,
        },
    }
end

function ctrl.cmd.setup(self)
    self:prefs()
    self.f.main = ctrl.frame:new(self.options.frame)
    self.f.main:SetScale(ctrl.prefs.ui.scale)
    ctrl.tx.generate(ctrl.cmd, textures)
    self:buttons()
    self:registerCtrlFrame(1, self.f.main)
end

ctrl.cmd:init()
