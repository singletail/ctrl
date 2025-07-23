--[[ ctrl - colors.lua - t@wse.nyc - 17 July 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

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
    ['NONE']    = [[|cff888888]],
}

ctrl.c.rgba = {
    r = { 1.0, 0.18, 0.22, 1.0 }, -- red
    g = { 0.14, 0.81, 0.1, 1.0 }, -- green
    b = { 0.29, 0.46, 1.0, 1.0 }, -- blue
    y = { 1.0, 0.95, 0.0, 1.0 }, -- yellow
    o = { 1.0, 0.69, 0.0, 1.0 }, -- orange
    c = { 0.35, 0.81, 0.98, 1.0 }, -- cyan
}

ctrl.c.pm     = {
    [1] = [[|cff05dde2]], --cyan
    [2] = [[|cffffb3b3]], --pink
    [3] = [[|cfffd2702]], --red
    [4] = [[|cfffda104]], --orange
}

ctrl.name     = ctrl.c.o .. 'c' .. ctrl.c.y .. 't' .. ctrl.c.g .. 'r' .. ctrl.c.b .. 'l' .. ctrl.c.v

