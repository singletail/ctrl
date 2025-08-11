--[[ ctrl - dev.lua - t@wse.nyc - 7 Aug 25 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'dev',
    color = c.w,
    symbol = s.keyboard,
    options = {
        theme = 'univac',
        events = {
            'UI_SCALE_CHANGED',
        },
    },
    mode = {
        layout = 'console',
        multiline = 1,
        pp = 1,
        min = 0,
    },
}

ctrl.dev = ctrl.mod:new(mod)

function ctrl.dev.UI_SCALE_CHANGED()
    ctrl.dev.scale = UIParent:GetEffectiveScale()
    ctrl.dev.fontHeight = ctrl.dev.font:GetFontHeight()
end

ctrl.dev.theme = {
    ['univac'] = {
        font = {
            name = 'SourceCodePro-Medium',
            size = 13,
        },
        frame = { -- numbered, because order is important
            [1] = { name='main', w=640, h=384, x=256, y=-384, a=a.tl, pa=a.tl, isResizable=1, isMovable=1 },
            [2] = { name='head', target='main', h=36, anchors = {{a=a.tl,pa=a.tl,x=0,y=0},{a=a.br,pa=a.tr,x=0,y=-36}}},
            [3] = { name='layout_console', target='main', anchors = {{a=a.tl,pa=a.tl,x=0,y=0},{a=a.br,pa=a.br,x=0,y=0}} },
            [4] = { name='slider_v', target='layout_console', w=4, anchors = {{a=a.t,target='head',pa=a.b,x=220,y=0},{a=a.b,target='layout_console',pa=a.b,x=220,y=4}} },
            [5] = { name='slider_h', target='layout_console', h=4, anchors = {{a=a.l,target='layout_console',pa=a.l,x=4,y=-48},{a=a.r,target='slider_v',pa=a.l,x=-4,y=-48}} },
            [6] = { name='output', target='layout_console', anchors = {{a=a.t,target='head',pa=a.b,x=0,y=0},{a=a.l,pa=a.l,x=4,y=0},{a=a.r,target='slider_v',pa=a.l,x=0,y=0},{a=a.b,target='slider_h',pa=a.t,x=0,y=0}}},
            [7] = { name='input', target='layout_console', anchors = {{a=a.t,target='slider_h',pa=a.b,x=0,y=0},{a=a.l,pa=a.l,x=4,y=0},{a=a.r,target='slider_v',pa=a.l,x=0,y=0},{a=a.b,pa=a.b,x=0,y=4}}},
            [8] = { name='console_buttons', target='layout_console', isClipsChildren=1, anchors = {{a=a.t,target='head',pa=a.b,x=0,y=0},{a=a.l,target='slider_v',pa=a.r,x=0,y=0},{a=a.r,pa=a.r,x=-4,y=0},{a=a.b,pa=a.b,x=0,y=4}}},
        },
        texture = {
            ['background'] = { t='dmetal_sq.png', path=ctrl.p.dev, target='main', l=-8, al=1 },
            --['univac'] = { t='univac.png', path=ctrl.p.dev, target='layout_console', l=-7, al=1, anchors = {{a=a.tl,pa=a.tl,x=2,y=-2},{a=a.br,pa=a.tr,x=-4,y=-36}}},
            ['slider_v'] = { t='box.png', path=ctrl.p.dev, target='slider_v', l=-7, al=0.2, x=1, y=9, a=a.c, pa=a.c, h=32, w=2},
            ['slider_h'] = { t='box.png', path=ctrl.p.dev, target='slider_h', l=-7, al=0.2, x=0, y=1, a=a.c, pa=a.c, w=32, h=2},
            ['output'] = { t='bluebk_full_256.png', path=ctrl.p.dev, target='output', l=-7, al=1 },
            ['input'] = { t='redbk_full_128.png', path=ctrl.p.dev, target='input', l=-7, al=1 },
        },
        btn = {
            -- head
            ['console'] = { name='console', target='head', template='wide', w=72, h=36, a=a.tr, pa=a.tr, x=-184, y=1, btnColor={0,1,0,0.5}},
            ['log'] = { name='log', target='head', template='wide', w=72, h=36, a=a.tr, pa=a.tr, x=-112, y=1, btnColor={1,0.9,0,0.5}},
            ['debug'] = { name='debug', target='head', template='wide', w=72, h=36, a=a.tr, pa=a.tr, x=-40, y=1, btnColor={1,0,0,0.5}},
            ['min'] = { name='min', target='head', template='smol', btnColor={ 1, 1, 1, 0 }, a=a.tr, pa=a.tr, w=36, h=36, x=-4, y=1},

            ['run'] = { name='run', target='console_buttons', template='simple', w=84, h=36, a=a.br, pa=a.br, x=-8, y=4, btnColor={ 1, 0, 0, 1 }},
            ['pcall'] = { name='pcall', target='console_buttons', template='simple', w=84, h=36, a=a.br, pa=a.br, x=-8, y=34, btnColor={ 0, 1, 0, 1 }},
            ['multiline'] = { name='multiline', target='console_buttons', template='oval', w=84, h=24, a=a.br, pa=a.br, x=-10, y=70, btnColor={0,0,1,1}},
            ['pp'] = { name='pp', target='console_buttons', template='oval', w=84, h=24, a=a.br, pa=a.br, x=-10, y=94, btnColor={0.9,0,1,1}},
        },
        fs = {
            ['console'] = { t=c.w..'console', a=a.c, pa=a.c, x=-1, y=-1, target='console' },
            ['log'] = { t=c.w..'log', a=a.c, pa=a.c, x=-1, y=-1, target='log' },
            ['debug'] = { t=c.w..'debug', a=a.c, pa=a.c, x=-1, y=-1, target='debug' },
            ['min'] = { t=c.w..s.min, a=a.c, pa=a.c, x=-1, y=-1, target='min', font={size=28},},

            ['run'] = { t=c.aa..'fn()', a=a.c, pa=a.c, x=-1, y=0, target='run' },
            ['pcall'] = { t=c.aa..'pcall()', a=a.c, pa=a.c, x=-1, y=0, target='pcall' },
            ['multiline'] = { t=c.aa..'multiline', a=a.c, pa=a.c, x=5, y=0, target='multiline' },
            ['pp'] = { t=c.aa..'pprint', a=a.c, pa=a.c, x=5, y=0, target='pp' },
        }
    }
}

function ctrl.dev:set_mode(layout)
    if layout == self.mode.layout then return end
    self.mode.layout = layout
    self:debug('ctrl.dev.mode.layout=', self.mode.layout)

    if layout == 'console' then
        self.f.layout_console:Show()
    else
        self.f.layout_console:Hide()
    end
end

function ctrl.dev:welcome()
    local msg=c.r..s.ctrl..' '..c.d..c.o..'c'..c.y..'t'..c.d..c.g..'r'..c.d..c.b..'l '..c.d..c.v..'v'..ctrl.version..c.d
    msg=msg..' by '..c.p..s.singletail..' '..'Singletail-Proudmoore'..c.d
    self:add(msg)
    local buildVersion, buildNumber, buildDate, interfaceVersion, localizedVersion, buildInfo = GetBuildInfo()
    local msg2 = c.r..s.api..c.d..' '..c.o..buildVersion..c.d..' '..c.y..buildNumber..c.d..' '..c.g..buildDate..c.d..' '..c.b..interfaceVersion..c.d
    self:add(msg2)
end

function ctrl.dev:pre()
    ctrl.dev.output:ClearHighlightText()
    ctrl.dev.output:SetCursorPosition(1024*1024)
end

function ctrl.dev:write(text)
    if not text then return end
    ctrl.dev.output:Insert(text)
end

function ctrl.dev:post()
    ctrl.dev.scrollToBottom()
end

function ctrl.dev:add(text)
    if not text then return end
    self:pre()
    self:write(text)
    self:write('\n')
    self:post()
end

function ctrl.dev:raw(text)
    if not text then return end
    self:pre()
    self:write(text)
    self:post()
end

function ctrl.dev:err(err)
    if not err then return end
    self:pre()
    self:write(c.r..err..c.d..'\n')
    self:post()
end


-- Print

-- This is a bit silly, because it has to support 3 kinds of tables.
local function ctrl_recursive(input, limit, strindent)
    limit = limit or 1024
    if (limit < 1) then return limit - 1 end
    if strindent then strindent = '    ' .. strindent else strindent = '' end
    if type(input)~='table' then return string.format('%s%s\n', strindent, ctrl.wrap(input)), limit - 1 end
    if input.n then --packed table
        local output = string.format('%s[table n=%s]\n', strindent, tostring(input.n))
        for i=1,input.n do
            output = output..ctrl_recursive(input[i], limit, strindent)
        end
        return output, limit - 1
    elseif tonumber(#input) then --unpacked table
        local output = string.format('%s[table len=%s]\n', strindent, tostring(#input))
        for i=1,#input do
            output = output..ctrl_recursive(input[i], limit, strindent)
        end
        return output, limit - 1
    else -- pairs
        local output = ''
        for k,v in pairs(input) do
            output = output..string.format('%s[%s]\n', strindent, tostring(k))
            output = output..ctrl_recursive(v, limit, strindent)
        end
        return output, limit - 1
    end
end

local function ctrl_pp(...)
    local str = ctrl_recursive(...)
    ctrl.dev:add(str)
end

local function ctrl_print(...)
    local t = {n=select("#",...),...}
    local str = table.concat(t, ', ')
    ctrl.dev:add(str)
end

-- execution

function ctrl.dev:execute_pcall(text)
    local fn, err = loadstring(text, 'ctrldev')
    if not fn then self:err(err); return nil, err end
    self:pre()
    local real_print = print
    if self.mode.pp then print = ctrl_pp else print = ctrl_print end
    local ok, p_err = pcall(fn)
    print = real_print
    self:post()
    if not ok then self:err(p_err); return nil, p_err end
    return true
end

function ctrl.dev:do_pcall()
    local text = self.input:GetText()
    text = string.trim(text)
    self:debug('do_pcall', text)

    if not text then return nil end
    local ok, err = self:execute_pcall(text)
    if ok then return true end
    if not err then return nil end
    local fname, line = err:match("(%b[]):(%d+):")
	line = tonumber(line)
    self:err(string.format('--> %s:%s: %s <--', fname, line, err))
end

function ctrl.dev:execute_run(text)
    local fn, err = loadstring(text, 'ctrldev')
    if not fn then self:err(err); return nil, err end
    self:pre()
    local real_print = print
    if self.mode.pp then print = ctrl_pp else print = ctrl_print end
    local rt = {fn()}
    if next(rt) then ctrl_pp(rt) end
    print = real_print
    self:post()
    --if not ok then self:err(p_err); return nil, p_err end
    return true
end

function ctrl.dev:do_run()
    local text = self.input:GetText()
    text = string.trim(text)
    if not text then return nil end
    local ok, err = self:execute_run(text)
    if ok then return true end
    if not err then return nil end
    local fname, line = err:match("(%b[]):(%d+):")
	line = tonumber(line)
    self:err(string.format('--> %s:%s: %s <--', fname, line, err))
end


-- Buttons

ctrl.dev.button = ctrl.dev.button or {}

function ctrl.dev.button:run()
    self:do_run()
end

function ctrl.dev.button:pcall()
    self:do_pcall()
end

function ctrl.dev.button:multiline()
    self.btn.multiline:toggle()
    self.mode.multiline = self.btn.multiline:getValue()
    self:debug('ctrl.dev.mode.multiline=', self.mode.multiline)
end

function ctrl.dev.button:pp()
    self.btn.pp:toggle()
    self.mode.pp = self.btn.pp:getValue()
    self:debug('ctrl.dev.mode.pp=', self.mode.pp)
end

function ctrl.dev.button:min()
    -- TODO
end

function ctrl.dev.button:max()
    -- TODO
end

function ctrl.dev.button:log(val)
    self:debug('log', val)
    if self.btn.log:getValue() == 1 then return end
    self.btn.log:on()
    self.btn.console:off()
    self.btn.debug:off()
    self:set_mode('log')
end

function ctrl.dev.button:console(val)
    self:debug('console', val)
    if self.btn.console:getValue() == 1 then return end
    self.btn.console:on()
    self.btn.log:off()
    self.btn.debug:off()
    self:set_mode('console')
end

function ctrl.dev.button:debug(val)
    self:debug('debug', val)
        if self.btn.debug:getValue() == 1 then return end
    self.btn.debug:on()
    self.btn.console:off()
    self.btn.log:off()
    self:set_mode('debug')
end

function ctrl.dev:click(btn)
    ctrl.dev:debug('click', btn.name, btn.value)
    if ctrl.dev.button[btn.name] then ctrl.dev.button[btn.name](self, btn.value) end
end


-- Input Scripts

local function OnEnterPressed(f)
    if IsControlKeyDown() or ctrl.dev.mode.multiline == 1 then ctrl.dev:do_pcall() return end
    ctrl.dev.input:Insert('\n')
end

local function OnEditFocusGained(f)
    ctrl.dev:debug('OnEditFocusGained', f.name)
end

local function OnKeyDown(f, key)
    ctrl.dev:debug('OnKeyDown', tostring(key))
end

function ctrl.dev:addInputScripts()
    ctrl.dev.input:SetScript('OnEnterPressed', function(evtf) OnEnterPressed(evtf) end)
    ctrl.dev.input:SetScript('OnEditFocusGained', function(evtf) OnEditFocusGained(evtf) end)
    ctrl.dev.input:SetScript('OnKeyDown', OnKeyDown)
end

local function slider_onMouseUp(f) -- TODO: save position to prefs
    f:SetScript('OnUpdate', nil)
end

local function slider_onUpdate(f)
    local x, y = GetCursorPosition()
    if f.dir == 'h' then -- moves up and down
        local new_y = (y / ctrl.dev.scale) - f.offset_y
        if new_y > f.max_y then new_y = f.max_y end
        if new_y < -f.max_y then new_y = -f.max_y end
        f:SetPoint(a.l, ctrl.dev.f.layout_console, a.l, 4, new_y)
        f:SetPoint(a.r, ctrl.dev.f.slider_v, a.l, 0, new_y)
    else -- vertical, moves left and right
        local new_x = (x / ctrl.dev.scale) - f.offset_x
        if new_x > f.max_x then new_x = f.max_x end
        if new_x < -f.max_x then new_x = -f.max_x end
        f:SetPoint(a.t, ctrl.dev.f.head, a.b, new_x, 0)
        f:SetPoint(a.b, ctrl.dev.f.layout_console, a.b, new_x, -4)
    end
end

local function slider_onMouseDown(f)
    local pl, pb, pw, ph = f:GetParent():GetRect()
    f.offset_x = pl + (pw/2)
    f.offset_y = pb + (ph/2)
    f.max_x = (pw/2) - 64
    f.max_y = (ph/2) - 64
    f:SetScript('OnUpdate', function(sf) slider_onUpdate(sf) end)
end

function ctrl.dev:configure_slider(f)
    f:EnableMouse(true)
    f:SetScript('OnMouseDown', function(sf) slider_onMouseDown(sf) end)
    f:SetScript('OnMouseUp', function(sf) slider_onMouseUp(sf) end)
end

-- Frames

function ctrl.dev.editBoxHeight(f)
    local text, lines = f:GetText(), 0
    for i=1,strlen(text) do
        if text:sub(i,i) == '\n' then lines = lines + 1 end
    end
    return lines * ctrl.dev.fontHeight
end

function ctrl.dev:scrollToBottom()
    if not ctrl.dev.output or not ctrl.dev.f.output then return end
    local editBoxHeight = ctrl.dev.editBoxHeight(ctrl.dev.output)
    local frameHeight = ctrl.dev.f.output:GetHeight()
    local y = 0
    if editBoxHeight > frameHeight then y = editBoxHeight - frameHeight end
    ctrl.dev.output:SetPoint(a.tl, ctrl.dev.f.output, a.tl, 0, y)
    ctrl.dev.output:SetPoint(a.tr, ctrl.dev.f.output, a.tr, 0, y)
end

local function pf_onMouseWheel(pf, delta)
    ctrl.dev:debug('pf_onMouseWheel', tostring(pf.name), tostring(delta))
    local child = pf.child
    local parentHeight = pf:GetHeight()
    local childHeight = ctrl.dev.editBoxHeight(child)
    local maxY = childHeight - parentHeight
    local _, _, _, _, childY = child:GetPoint(1)
    local newY = childY - (delta * 10)
    if newY < 0 then newY = 0 end
    if newY > maxY then newY = maxY end
    child:SetPoint(a.tl, pf, a.tl, 0, newY)
    child:SetPoint(a.tr, pf, a.tr, 0, newY)
end

function ctrl.dev:configure_editbox(f)
    f.pos = 0
    f.parent = f:GetParent()
    f.parent.child = f
    f.parent:SetClipsChildren(true)
    f:SetAutoFocus(false)
    f:SetFontObject(ctrl.dev.font)
    f:SetTextColor(1, 1, 1, 1)
    f:SetHighlightColor(1, 0.8, 0, 0.5)
    f:SetMultiLine(true)
    f:SetMaxBytes(1024 * 1024)
    f:SetJustifyH('LEFT')
    f:SetTextInsets(8, 8, 8, 8)
    f:EnableMouseWheel(false)
    f.parent:EnableMouseWheel(true)
    f.parent:SetScript('OnMouseWheel', function(pf, delta) pf_onMouseWheel(pf, delta) end)
    f:Enable()
end

function ctrl.dev:build_editboxes()
    self.output = self.output or CreateFrame('EditBox', nil, ctrl.dev.f.output)
    self.output:SetPoint(a.tl, ctrl.dev.f.output, a.tl, 0, 0)
    self.output:SetPoint(a.tr, ctrl.dev.f.output, a.tr, 0, 0)
    self:configure_editbox(self.output)
    self.input = self.input or CreateFrame('EditBox', nil, ctrl.dev.f.input)
    self.input:SetPoint(a.tl, ctrl.dev.f.input, a.tl, 0, 0)
    self.input:SetPoint(a.tr, ctrl.dev.f.input, a.tr, 0, 0)
    self:configure_editbox(self.input)
    self:addInputScripts()
end

function ctrl.dev:build_frames()
    local theme = self.theme[self.options.theme]
    self.scale = UIParent:GetEffectiveScale()
    self.font = ctrl.font(theme.font.name, self.scale * theme.font.size, '')
    self.fontHeight = self.font:GetFontHeight()
    for _, v in ipairs(theme.frame) do self.f[v.name] = ctrl.frame.new(ctrl.dev, v) end
    self.f.slider_h.dir = 'h'
    self.f.slider_v.dir = 'v'
    self:configure_slider(self.f.slider_h)
    self:configure_slider(self.f.slider_v)
    ctrl.tx.generate(self, theme.texture)
    ctrl.btns.generate(self, theme.btn)
    ctrl.fs.generate(self, theme.fs)
end

function ctrl.dev.setup(self)
    self:build_frames()
    self:build_editboxes()
    self.input:SetText('local function testfn()\n  local t={}\n    for i=1,8 do\n      t[i]="test"\n    end\n  print(t)\nend\n\ntestfn()')
    self.btn.multiline:setValue(self.mode.multiline)
    self.btn.pp:setValue(self.mode.pp)
    self.btn.debug:off()
    self.btn.log:off()
    self.btn.console:on()
    self:welcome()
end

ctrl.dev:init()