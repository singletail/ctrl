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
    ['HEALER']  = [[|cffff2e38]],
    ['DAMAGER'] = [[|cfffff000]],
    ['NONE']    = [[|cff888888]],
}

ctrl.c.rgba = {
    r = { 0.5, 0, 0, 1.0 }, -- red
    o = { 0.7, 0.4, 0.0, 1.0 }, -- orange
    y = { 0.7, 0.7, 0.0, 1.0 }, -- yellow
    g = { 0, 0.7, 0, 1.0 }, -- green
    b = { 0, 0.1, 0.8, 1.0 }, -- blue
    v = { 0.6, 0, 0.8, 1.0 }, -- violet
    c = { 0, 0.6, 0.6, 1.0 }, -- cyan
    p = { 0.7, 0, 0.8, 1.0 }, -- pink
    w = { 1, 1, 1, 1.0 }, -- white
    black = { 0, 0, 0, 1 }, -- black
}

ctrl.c.class = { -- these are dimmed, used for nameplates.
    DEATHKNIGHT = { 0.38, 0.06, 0.11, 1, },
    DEMONHUNTER = { 0.32, 0.9, 0.4, 1, },
    DRUID = { 0.5, 0.25, 0.02, 1, },
    HUNTER = { 0.33, 0.41, 0.22, 1, },
    MAGE = { 0.2, 0.4, 0.46, 1, },
    MONK = { 0.0, 0.5, 0.28, 1, },
    PALADIN = { 0.46, 0.27, 0.36, 1, },
    PRIEST = { 0.5, 0.5, 0.5, 1, },
    ROGUE = { 0.5, 0.48, 0.2, 1, },
    SHAMAN = { 0.0, 0.22, 0.43, 1, },
    WARLOCK = { 0.27, 0.25, 0.4, 1, },
    WARRIOR = { 0.39, 0.3, 0.21, 1, },
}

ctrl.c.reaction = { -- also dimmed
    [0] = { 0, 0, 0, 1, }, --black
    [1] = { 0.375, 0.0, 0.0, 1, }, --hated
    [2] = { 0.5, 0.0, 0.0, 1, },
    [3] = { 0.5, 0.25, 0.0, 1, },
    [4] = { 0.5, 0.5, 0.0, 1, },
    [5] = { 0.0, 0.5, 0.0, 1, },
    [6] = { 0.0, 0.5, 0.17, 1, },
    [7] = { 0.0, 0.5, 0.33, 1, },
    [8] = { 0.0, 0.5, 0.5, 1, }, --exalted
}

ctrl.c.enemy = {
    ['boss'] = { 1, 0, 0.9, 1.0 }, -- pink
    ['worldboss'] = { 1, 0, 0.9, 1.0 },
    ['rareelite'] = { 0.75, 0.2, 0.0, 1, },
    ['elite'] = { 0.5, 0.0, 0.0, 1, },
    ['rare'] = { 0.35, 0.0, 0.0, 1, },
    ['normal'] = { 0.3, 0.0, 0.0, 1, },
    ['trivial'] = { 0.25, 0.0, 0.0, 1, },
    ['minus'] = { 0.2, 0.0, 0.0, 1, },
}

ctrl.c.pm     = {
    [1] = [[|cff05dde2]], --cyan
    [2] = [[|cffffb3b3]], --pink
    [3] = [[|cfffd2702]], --red
    [4] = [[|cfffda104]], --orange
}

ctrl.name     = ctrl.c.o .. 'c' .. ctrl.c.y .. 't' .. ctrl.c.g .. 'r' .. ctrl.c.b .. 'l' .. ctrl.c.v

