--[[ ctrl - dev.lua - t@wse.nyc - 7 Aug 25 ]]

---@class ctrl
local ctrl = select(2, ...)
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'dev',
    color = c.w,
    symbol = s.keyboard,
    options = {
        events = {
            --'UI_SCALE_CHANGED',
        },
        frame = {
            name='main', w=640, h=384, x=256, y=-384, a=a.tl, pa=a.tl, isResizable=1, isMovable=1
        },
    },
    mode = {
        multiline = 1,
        pp = 1,
        min = 0,
    },
}

ctrl.dev = ctrl.mod:new(mod)

local subframes = {
    ['slider'] = {name='slider', target='main', anchors = {{a=a.bl,pa=a.bl,x=0,y=120},{a=a.tr,pa=a.br,x=0,y=128}}},
    ['poutput'] = {name='poutput', target='main', anchors = {{a=a.tl,pa=a.tl,x=4,y=-42},{a=a.br,pa=a.br,x=-6,y=128}}},
    ['pinput'] = {name='pinput', target='main', anchors = {{a=a.tl,pa=a.tl,x=6,y=-40},{a=a.br,pa=a.br,x=-100,y=18}}},
}

local buttons = {
    ['btn_min'] = { name='btn_min', target='main', template='sqoff', btnColor={ 1, 0.9, 0, 1 }, a=a.c, pa=a.tr, x=-24, y=-24},
    ['btn_pcall'] = { name='btn_pcall', target='main', template='simple', w=84, h=32, a=a.br, pa=a.br, x=-8, y=8, btnColor={ 0.2, 0.2, 0.2, 1 }},
    ['btn_multiline'] = {name='btn_multiline', target='main', template='oval', w=84, h=24, a=a.br, pa=a.br, x=-10, y=42, btnColor={0,0,1,1}},
    ['btn_pp'] = {name='btn_pp', target='main', template='oval', w=84, h=24, a=a.br, pa=a.br, x=-10, y=66, btnColor={0.9,0,1,1}},
    --['btn_testfn'] = {name='btn_testfn', target='pinput', template='wide', btnColor={ 1, 0, 0, 1 }, a=a.br, pa=a.br, y=56},
}

local textures = {
    ['tx_maindark'] = { t='dmetal_sq.png', path=ctrl.p.dev, target='main', l=-8, al=1 },
    ['tx_univac'] = { t='univac.png', w=512, h=32, path=ctrl.p.dev, target='main', l=-7, al=1, anchors = {{a=a.tl,pa=a.tl,x=8,y=-4},{a=a.br,pa=a.tr,x=-6,y=-39}}},
    ['tx_slider'] = { t='box.png', path=ctrl.p.dev, target='slider', l=-7, al=0.25, x=0, y=2, a=a.c, pa=a.c, w=32, h=2},
    ['tx_poutput'] = { t='bluebk_full_256.png', path=ctrl.p.dev, target='poutput', l=-7, al=1 },
    ['tx_pinput'] = { t='redbk_full_128.png', path=ctrl.p.dev, target='pinput', l=-7, al=1 },
}

local fontstrings = {
    ['fs_min'] = { t=c.dim..s.min, a=a.c, pa=a.c, x=-1, y=-2, target='btn_min', fontFile='Prompt-Bold.ttf', fontSize=24,},
    ['fs_pcall'] = { t=c.aa..'pcall()', a=a.c, pa=a.c, x=-1, y=0, target='btn_pcall', fontFile='Prompt-Medium.ttf', fontSize=12,},
    ['fs_multiline'] = { t=c.aa..'multiline', a=a.c, pa=a.c, x=5, y=0, target='btn_multiline', fontFile='Prompt-Medium.ttf', fontSize=10,},
    ['fs_pp'] = { t=c.aa..'pprint', a=a.c, pa=a.c, x=5, y=0, target='btn_pp', fontFile='Prompt-Medium.ttf', fontSize=10,},
    --['fs_testfn'] = { t='testfn', a=a.c, pa=a.c, x=-1, y=-2, target='btn_testfn', fontFile='Prompt-Bold.ttf', fontSize=11,},
}


-- Welcome

function ctrl.dev:welcome()
    local msg=c.r..s.ctrl..' '..c.d..c.o..'c'..c.y..'t'..c.d..c.g..'r'..c.d..c.b..'l '..c.d..c.v..'v'..ctrl.version..c.d
    msg=msg..' by '..c.p..s.singletail..' '..'Singletail-Proudmoore'..c.d
    self:add(msg)
    local buildVersion, buildNumber, buildDate, interfaceVersion, localizedVersion, buildInfo = GetBuildInfo()
    local msg2 = c.r..s.api..c.d..' '..c.o..buildVersion..c.d..' '..c.y..buildNumber..c.d..' '..c.g..buildDate..c.d..' '..c.b..interfaceVersion..c.d
    self:add(msg2)
end





-- Output

function ctrl.dev:pre()
    ctrl.dev.output:ClearHighlightText()
    ctrl.dev.output:SetCursorPosition(1024*1024)
end

function ctrl.dev:write(text)
    ctrl.dev.output:Insert(text)
end

function ctrl.dev:post()
    ctrl.dev.scrollToBottom()
end

function ctrl.dev:add(text)
    self:pre()
    self:write(text)
    self:write('\n')
    self:post()
end

function ctrl.dev:raw(text)
    self:pre()
    self:write(text)
    self:post()
end

function ctrl.dev:err(err)
    self:pre()
    self:write(c.r..err..c.d..'\n')
    self:post()
end

--[[
local function ctrl_print(...)
	local out = ""
	for i=1,select("#", ...) do
		if i > 1 then
			out = out .. ", "
		end
		out = out .. tostring(select(i, ...))
	end
	ctrl.dev:add(out)
end

local function pack(...)
    return {n=select("#",...),...}
end
]]


-- Print

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

function ctrl.dev:execute(text)
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
    if not text then return nil end
    local ok, err = self:execute(text)
    if ok then return true end
    if not err then return nil end
    local fname, line = err:match("(%b[]):(%d+):")
	line = tonumber(line)
    self:err(string.format('--> %s:%s: %s <--', fname, line, err))
end


-- Buttons

function ctrl.dev:btn_pcall()
    self:do_pcall()
end

function ctrl.dev:btn_multiline()
    self.btn.btn_multiline:toggle()
    self.mode.multiline = self.btn.btn_multiline:getValue()
    self:debug('ctrl.dev.mode.multiline=', self.mode.multiline)
end

function ctrl.dev:btn_pp()
    self.btn.btn_pp:toggle()
    self.mode.pp = self.btn.btn_pp:getValue()
    self:debug('ctrl.dev.mode.pp=', self.mode.pp)
end

function ctrl.dev:btn_testfn()
    self.input:SetText('local function testfn()\n  local t={}\n    for i=1,8 do\n      t[i]="test"\n    end\n  print(t)\nend\n\ntestfn()')
end

function ctrl.dev:click(btn)
    ctrl.dev:debug('click', btn.name)
    if ctrl.dev[btn.name] then ctrl.dev[btn.name](self) end
end



-- Input Scripts

local function OnEnterPressed(f)
    if ctrl.dev.mode.multiline == 1 then
        ctrl.dev.input:Insert('\n')
    else
        ctrl.dev:do_pcall()
    end
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



-- min/max

function ctrl.dev:btn_min()
    self.btn.btn_min:toggle()
    self.mode.min = self.btn.btn_min:getValue()
    if self.mode.min == 1 then
        local w, h = self.f.main:GetSize()
        self.w = w
        self.h = h
        self.f.main:SetSize(64,64)
        self.btn.btn_min:SetPoint(a.c, self.f.main, a.tl, 36, -24)
    else
        self.w = self.w or 512
        self.h = self.h or 512
        self.f.main:SetSize(self.w, self.h)
        self.btn.btn_min:SetPoint(a.c, self.f.main, a.tr, -24, -24)
    end
end

function ctrl.dev:btn_max()
    self.options.frame.y = self.options.frame.y + 100
    self.f.main:SetPoint(a.bl, self.f.main, a.bl, 0, self.options.frame.y)
end


-- Frame Parent Scroll Functions

local function pf_onMouseWheel(pf, delta)
    local child = pf.child
    local parentHeight = pf:GetHeight()
    local childHeight = child:GetHeight()
    local maxY = childHeight - parentHeight
    local newY = child.pos + (delta * 10)
    if newY < 0 then newY = 0 end
    if newY > maxY then newY = maxY end
    child.pos = newY
    child:SetPoint(a.tl, pf, a.tl, 0, child.pos)
end

-- Editbox Config

function ctrl.dev:configureInput(f)
    f.pos = 0
    f.parent = f:GetParent()
    f.parent.child = f
    f:SetWidth(f.parent:GetWidth())
    f:SetPoint(a.tl, f.parent, a.tl, 0, 0)
    f:SetPoint(a.tr, f.parent, a.tr, 0, 0)
    f.parent:SetClipsChildren(true)
    f:SetAutoFocus(false)
    f:SetFontObject(ctrl.dev.fontObject)
    f:SetTextColor(1, 1, 1, 1)
    f:SetHighlightColor(1, 0.8, 0, 0.5)
    f:SetMultiLine(true)
    f:SetMaxBytes(1024*1024)
    f:SetJustifyH('LEFT')
    f:SetTextInsets(8, 8, 8, 8)
    f:EnableMouseWheel(false)
    f.parent:EnableMouseWheel(true)
    f.parent:SetScript('OnMouseWheel', function(pf, delta) pf_onMouseWheel(pf, delta) end)
    f:Enable()
end

function ctrl.dev:configureOutput(f)
    f.pos = 0
    f.parent = f:GetParent()
    f.parent.child = f
    f:SetPoint(a.tl, f.parent, a.tl, 0, 0)
    f:SetPoint(a.tr, f.parent, a.tr, 0, 0)
    f.parent:SetClipsChildren(true)
    f:SetAutoFocus(false)
    f:SetFontObject(ctrl.dev.fontObject)
    f:SetTextColor(1, 1, 1, 1)
    f:SetHighlightColor(1, 0.8, 0, 0.5)
    f:SetMultiLine(true)
    f:SetMaxBytes(1024*1024)
    f:SetJustifyH('LEFT')
    f:SetTextInsets(8, 8, 8, 8)
    f:EnableMouseWheel(false)
    f.parent:EnableMouseWheel(true)
    f.parent:SetScript('OnMouseWheel', function(pf, delta) pf_onMouseWheel(pf, delta) end)
    f:Enable()
end

function ctrl.dev:buildEditboxes()
    self.output = self.output or CreateFrame('EditBox', nil, ctrl.dev.f.poutput)
    self.output.name = 'output'
    self.output:SetWidth(ctrl.dev.f.poutput:GetWidth())
    self.output:SetPoint(a.bl, ctrl.dev.f.poutput, a.bl, 0, 0)
    self:configureOutput(self.output)

    self.input = self.input or CreateFrame('EditBox', nil, ctrl.dev.f.pinput)
    self.input.name = 'input'
    self:configureInput(self.input)

    self:addInputScripts()

    CTRLOUTPUT = ctrl.dev.output
end

-- Frames

function ctrl.dev.scrollToBottom()
    ctrl.dev.output:SetWidth(ctrl.dev.f.poutput:GetWidth())
    ctrl.dev.output:SetPoint(a.bl, ctrl.dev.f.poutput, a.bl, 0, 0)
end

local function constrain_slider(f)
    local border = 64
    local uiScale, _, y = UIParent:GetEffectiveScale(), GetCursorPosition()
    local scaledY = y / uiScale
    local newY = scaledY - f.parentBottom
    if newY < border then newY = border end
    if newY > f.parentHeight - border then newY = f.parentHeight - border end
    local newBottom = newY + f.cursorOffset
    local newTop = newBottom + f.startHeight
    f:SetPoint(a.bl, ctrl.dev.f.main, a.bl, 0, newBottom)
    f:SetPoint(a.tr, ctrl.dev.f.main, a.br, 0, newTop)
end

function ctrl.dev:buildFrames()
    ctrl.dev.f.main = ctrl.frame.new(ctrl.dev, self.options.frame)
    self.f.slider = ctrl.frame.new(ctrl.dev, subframes.slider)
    self.f.poutput = ctrl.frame.new(ctrl.dev, subframes.poutput)
    self.f.pinput = ctrl.frame.new(ctrl.dev, subframes.pinput)
    self.f.poutput:SetPoint(a.br, self.f.slider, a.tr, -7, 1)
    self.f.pinput:SetPoint(a.tl, self.f.slider, a.bl, 3, 3)

    self.f.slider:EnableMouse(true)
    self.f.slider:SetMovable(true)
    self.f.slider:SetScript('OnMouseDown', function(f)
        local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
        f.cursorStartY = y / uiScale
        local _, sBottom, _, sHeight = f:GetRect()
        f.startBottom = sBottom
        f.startHeight = sHeight
        f.cursorOffset = sBottom - f.cursorStartY
        local p = f:GetParent()
        local _, pBottom, _, pHeight = p:GetRect()
        f.parentBottom = pBottom
        f.parentHeight = pHeight
        f:SetScript('OnUpdate', function(sf) constrain_slider(sf) end)
    end)
    self.f.slider:SetScript('OnMouseUp', function(f)
        f:SetScript('OnUpdate', nil)
    end)
end

function ctrl.dev.setup(self)
    local sc = UIParent:GetEffectiveScale()
    ctrl.dev.fontObject = ctrl.dev.fontObject or ctrl.font('SourceCodePro-Medium', sc*13, '')

    self:buildFrames()
    ctrl.tx.generate(self, textures)
    self:buildEditboxes()

    ctrl.btns.generate(self, buttons)
    ctrl.fs.generate(self, fontstrings)

    self.btn.btn_multiline:setValue(self.mode.multiline)
    self.btn.btn_pp:setValue(self.mode.pp)

    self:welcome()
    self:btn_testfn()

end

ctrl.dev:init()
