--[[ ctrl - init.lua - t@wse.nyc - 7/24/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

ctrl                    = ctrl or {}
ctrl.mods               = {}

ctrl.name               = 'ctrl'
ctrl.description        = 'Singletail\'s Quality of Life.'
ctrl.version            = 1.1
ctrl.author             = 't@wse.nyc'
ctrl.color              = [[|cfff563af]]
ctrl.symbol             = '㘁'
ctrl.start              = GetServerTime()

ctrl.buffer             = {}
ctrl.loads              = {}
ctrl.memlog             = {}
ctrl.memcount           = 0

ctrl.is = {
    loaded  = nil,
    enabled = 1,
    ok      = 1,
}

ctrl.p = {
    fnt = [[Interface\AddOns\ctrl\assets\fnt\]],
    tx = [[Interface\AddOns\ctrl\assets\tx\]],
    btns = [[Interface\AddOns\ctrl\assets\btns\]],
    ux = [[Interface\AddOns\ctrl\assets\ux\]],
    sfx = [[Interface\AddOns\ctrl\assets\sfx\]],
    ctrl = [[Interface\AddOns\ctrl\assets\ctrl\]],
    np = [[Interface\AddOns\ctrl\assets\nameplate\]],
    dev = [[Interface\AddOns\ctrl\assets\console\]],
    bx = [[Interface\AddOns\ctrl\assets\bx-png\]],
}

UIParentLoadAddOn("Blizzard_DebugTools")

local _, _, _, toc = GetBuildInfo()
ctrl.toc = toc

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
