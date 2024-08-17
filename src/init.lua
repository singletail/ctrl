--[[ ctrl - init.lua - t@wse.nyc - 7/24/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

ctrl                    = ctrl or {}
ctrl.mods               = {}

ctrl.name               = 'ctrl'
ctrl.description        = 'Singletail\'s Quality of Life.'
ctrl.version            = 1.0
ctrl.author             = 't@wse.nyc'
ctrl.color              = [[|cfff563af]]
ctrl.symbol             = '㘁'

ctrl.maxBuffer          = 1000
ctrl.maxLog             = 1000
ctrl.start              = GetServerTime()

ctrl.buffer             = {}
ctrl.loads              = {}
ctrl.memlog             = {}
ctrl.memcount           = 0

ctrl.setting            = {
    debug   = 1,
    verbose = 1,
    log     = 1,
}

ctrl.is                 = {
    loaded  = nil,
    enabled = 1,
    ok      = 1,
}

ctrl.p                  = {
    fnt = [[Interface\AddOns\ctrl\assets\fnt\min\]],
    fntf = [[Interface\AddOns\ctrl\assets\fnt\full\]],
    fntorig = [[Interface\AddOns\ctrl\assets\fnt\orig\]],
    tx = [[Interface\AddOns\ctrl\assets\tx\]],
    btns = [[Interface\AddOns\ctrl\assets\btns\]],
    ux = [[Interface\AddOns\ctrl\assets\ux\]],
    sfx = [[Interface\AddOns\ctrl\assets\sfx\]],
    ctrl = [[Interface\AddOns\ctrl\assets\ctrl\]],
    test = [[Interface\AddOns\ctrl\assets\test\]],
}

ctrl.c                  = {
    d           = [[|r]],
    w           = [[|cffffffff]],
    r           = [[|cffff2e38]],
    o           = [[|cffffb836]],
    y           = [[|cfffff000]],
    g           = [[|cff24cf19]],
    b           = [[|cff4975ff]],
    v           = [[|cffd649ff]],
    c           = [[|cff5bcefa]],
    p           = [[|cfff563af]],
    f           = [[|cfff000ff]],
    a           = [[|cff888888]],
    aa          = [[|cffaaaaaa]],
    k           = [[|cff000000]],
    dim         = [[|cff333333]],
    gray        = [[|cffaaaaaa]],
    ['TANK']    = [[|cff5bcefa]],
    ['HEALER']  = [[|cff24cf19]],
    ['DAMAGER'] = [[|cffffffff]],
}



ctrl.c.pm     = {
    [1] = [[|cff05dde2]], --cyan
    [2] = [[|cffffb3b3]], --pink
    [3] = [[|cfffd2702]], --red
    [4] = [[|cfffda104]], --orange
}

ctrl.s        = {
    ['ctrl']       = '、',
    ['console']    = 'べ',
    ['power']      = '　',
    ['evt']        = 'う',
    ['nul']        = '␀',
    ['ghost']      = '〠',
    ['bug']        = '〡',
    ['bomb']       = '㍩',
    ['crit']       = '㎙',
    ['save']       = 'バ',
    ['info']       = 'め',
    ['i']          = 'む',
    ['emerg']      = '㎛',
    ['alert']      = 'と',
    ['warn']       = 'ゃ',
    ['notice']     = 'ベ',
    ['keyboard']   = 'せ',
    ['?']          = 'よ',
    ['no']         = 'ォ',
    ['singletail'] = '㐪',
    ['secure']     = '㉔',
    ['insecure']   = '㉕',
    ['taint']      = '㉕',
    ['db']         = '㊘',
    ['check']      = 'を',
    ['x']          = '゠',
    ['8ball']      = '󰭡',
    ['run']        = '󰑮',
    ['clippy']     = '〓',
    ['log']        = '󱂅',
    ['api']        = '㈹',
    ['lua']        = '㈰',
    ['code']       = '',
    ['lockdown']   = '󰳌',
    ['safe']       = '󰳈',
    ['ok']         = 'い',
    ['action']     = '󰿎',
    ['tx']         = '',
    ['frame']      = '㇁',
    ['dead']       = '䂹',
    ['ux']         = 'ぅ',
    ['btns']       = '㇠',
    ['template']   = '󰋯',
    ['sys']        = '󰍛',
    ['sfx']        = '㇦',
    ['taunt']      = 'あ',
    ['cleu']       = 'す',
    ['bow']        = '㍣',
    ['cvar']       = '〲',
    ['cvar_alert'] = '〶',
    ['zoomIn'] = 'ド',
    ['zoomOut'] = 'ニ',
    ['min'] =  '󰘕', -- '䔦',
    ['max'] = '󰘖', --  '䔥',
}

local c       = ctrl.c
local s       = ctrl.s

ctrl.name     = c.o .. 'c' .. c.y .. 't' .. c.g .. 'r' .. c.b .. 'l' .. c.v

ctrl.s.ghosts = c.d
for i = 1, 4 do
    ctrl.s.ghosts = c.pm[i] .. s.ghost .. ctrl.s.ghosts
end

UIParentLoadAddOn("Blizzard_DebugTools")
local _, _, _, toc = GetBuildInfo()
ctrl.toc           = toc

local next         = next

function ctrl.mem()
    return math.floor(collectgarbage("count"))
end

function ctrl.logmem(evt)
    local mem = ctrl.mem()
    local k = math.floor(mem / 1000)
    --ctrl.memlog[#ctrl.memlog + 1] = { evt, new, mem }
    return string.format('memory usage: %7d K', k)
end

ctrl.a = {
    tl = 'TOPLEFT',
    t  = 'TOP',
    tr = 'TOPRIGHT',
    l  = 'LEFT',
    c  = 'CENTER',
    r  = 'RIGHT',
    bl = 'BOTTOMLEFT',
    b  = 'BOTTOM',
    br = 'BOTTOMRIGHT',
    m  = 'MIDDLE',
    w  = {
        c = 'CLAMP',
        b = 'CLAMPTOBLACK',
        a = 'CLAMPTOBLACKADDITIVE',
        w = 'CLAMPTOWHITE',
        r = 'REPEAT',
        m = 'MIRROR'
    },
    f  = {
        l = 'LINEAR',
        t = 'TRILINEAR', -- *
        n = 'NEAREST',
    },
    s  = {
        b = 'BACKGROUND',
        l = 'LOW',
        m = 'MEDIUM',
        h = 'HIGH',
        d = 'DIALOG',
        f = 'FULLSCREEN',
        fd = 'FULLSCREEN_DIALOG',
        t = 'TOOLTIP',
    },
    d  = {
        b = 'BACKGROUND',
        r = 'BORDER',
        a = 'ARTWORK',
        o = 'OVERLAY',
        h = 'HIGHLIGHT'
    }
}
