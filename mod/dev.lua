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
            name='main', w=512, h=512, x=256, y=384, a=a.bl, pa=a.bl, isResizable=1, isMovable=1
        },
    },
    mode = {
        multiline = 1,
    },
}

ctrl.dev = ctrl.mod:new(mod)

local subframes = {
    ['slider'] = {name='slider', target='main', anchors = {{a=a.bl,pa=a.bl,x=0,y=120},{a=a.tr,pa=a.br,x=0,y=128}}},
    ['poutput'] = {name='poutput', target='main', anchors = {{a=a.tl,pa=a.tl,x=4,y=-42},{a=a.br,pa=a.br,x=-6,y=128}}},
    ['pinput'] = {name='pinput', target='main', anchors = {{a=a.tl,pa=a.tl,x=6,y=-40},{a=a.br,pa=a.br,x=-7,y=18}}},
}

local buttons = {
    ['btn_testprint'] = {name='btn_testprint', target='pinput', template='wide', btnColor={ 1, 0.5, 0, 1 }, a=a.br, pa=a.br, y=84},
    ['btn_testfn'] = {name='btn_testfn', target='pinput', template='wide', btnColor={ 1, 0, 0, 1 }, a=a.br, pa=a.br, y=56},
    ['btn_multiline'] = {name='btn_multiline', target='pinput', template='widetoggle', btnColor={ 1, 0.9, 0, 1 }, a=a.br, pa=a.br, y=28},
    ['btn_pcall'] = { name='btn_pcall', target='pinput', template='wide', btnColor={ 0, 1, 0, 1 }, a=a.br, pa=a.br},
}

local textures = {
    ['tx_maindark'] = { t='deck.png', path=ctrl.p.dev, target='main', l=-8, al=0.8 },
    ['tx_univac'] = { t='univac.png', w=512, h=32, path=ctrl.p.dev, target='main', l=-7, al=1, anchors = {{a=a.tl,pa=a.tl,x=8,y=-4},{a=a.br,pa=a.tr,x=-6,y=-39}}},
    ['tx_slider'] = { t='box.png', path=ctrl.p.dev, target='slider', l=-7, al=0.25, x=0, y=2, a=a.c, pa=a.c, w=32, h=2},
    ['tx_poutput'] = { t='redbk_full_128.png', path=ctrl.p.dev, target='poutput', l=-7, al=0.8 },
    ['tx_pinput'] = { t='redbk_full_128.png', path=ctrl.p.dev, target='pinput', l=-7, al=0.8 },
}

local fontstrings = {
    ['fs_pcall'] = { t='PCALL()', a=a.c, pa=a.c, x=-1, y=-2, target='btn_pcall', fontFile='Prompt-Bold.ttf', fontSize=12,},
    ['fs_multiline'] = { t='FN()', a=a.c, pa=a.c, x=-1, y=-2, target='btn_multiline', fontFile='Prompt-Bold.ttf', fontSize=12,},
}

local ipsum = [=[
"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
Section 1.10.32 of "de Finibus Bonorum et Malorum", written by Cicero in 45 BC

"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
1914 translation by H. Rackham

"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
]=]

-- Functions




function ctrl.dev:pre()
    ctrl.dev.output:ClearHighlightText()
    ctrl.dev.output:SetCursorPosition(1024*1024)
end

function ctrl.dev:write(text)
    ctrl.dev.output:Insert(text)
end

function ctrl.dev:post()
    --ctrl.dev.ScrollToBottom()
end

function ctrl.dev:send(text)
    self:pre()
    self:write(text)
    self:post()
end

local function ctrl_print(...)
	local out = ""
	for i=1,select("#", ...) do
		if i > 1 then
			out = out .. ", "
		end
		out = out .. tostring(select(i, ...))
	end
	--ctrl.dev:write(out..'\n')
    --ctrl.dev.output:Insert(out..'\n')
    CTRLOUTPUT:Insert(out..'\n')
end

function ctrl.dev:execute(text)
    text = string.trim(text)
    local fn, err = loadstring(text, 'ctrldev')
    if not fn then
        self:send(c.r .. err .. c.d)
        return nil, err
    end
    self:pre()
    local real_print = print
    print = ctrl_print
    local ok, result = pcall(fn)
    print = real_print
    self:post()
    if not ok then
        self:send(c.r .. result .. c.d)
        return nil, result
    end
    return true
end

function ctrl.dev:do_pcall()
    local text = self.input:GetText()
    if not text then return nil end
    local ok, err = self:execute(text)
    if ok then return nil end
    -- local chunkName,lineNum = err:match("(%b[]):(%d+):")
	-- lineNum = tonumber(lineNum)
    -- (find line, highlight, etc.)
end


-- Buttons

function ctrl.dev:btn_pcall()
    self:do_pcall()
end

function ctrl.dev:btn_multiline()
    self.btn.btn_multiline:toggle()
    self.mode.multiline = self.btn.btn_multiline:getValue()
    self.fs.fs_multiline:SetAlpha((self.mode.multiline+1)/2)
    self:debug('ctrl.dev.mode.multiline=', self.mode.multiline)
end

function ctrl.dev:btn_testfn()
    self.input:SetText('local function test()\n    print("test")\nend')
end

function ctrl.dev:btn_testprint()
    local real_print = print
    print = ctrl_print
    print('test print')
    print = real_print
end

--

function ctrl.dev:click(btn)
    self:debug('click', btn.name)
    ctrl.dev[btn.name](self)
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

function ctrl.dev:addInputScripts()
    ctrl.dev.input:SetScript('OnEditFocusGained', function(evtf) OnEditFocusGained(evtf) end)
    ctrl.dev.input:SetScript('OnEnterPressed', function(evtf) OnEnterPressed(evtf) end)
end



-- Frame Parent Functions

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
    ctrl.dev.fontObject = ctrl.dev.fontObject or ctrl.font('SourceCodePro-Medium', sc*15, '')

    self:buildFrames()
    ctrl.tx.generate(self, textures)
    self:buildEditboxes()

    ctrl.btns.generate(self, buttons)
    ctrl.fs.generate(self, fontstrings)
    --self.btn.btn_multiline:off()
    --self.fs.fs_multiline:SetAlpha(0.5)
    self:debug('ctrl.dev.mode.multiline=', self.mode.multiline)

end

ctrl.dev:init()
