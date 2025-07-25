function (modTable)

    modTable.prefs = {
        w = 160,
        h = 21,
        fs = 7,
        scale = 1.0,
        path = [[Interface\AddOns\ctrl\assets\plater\]],
    }

    local p = modTable.prefs
    p.multi = math.floor((p.w - p.h) / 100)

    modTable.elements = {
        frame = {
            ['base']   = {fl=0, w=p.w, h=p.h, x=0, y=0, a='TOPLEFT', pa='TOPLEFT'},
            ['top']    = {target='base', fl=300, w=p.w, h=p.h, x=0, y=0, a='TOPLEFT', pa='TOPLEFT'},
        },
        texture = {
            ['bk']     = {file='np_bk.png', target='base', alpha=1, layer=-6,},
            ['cap']    = {file='cap64.png', x=0, y=0, w=p.h, h=p.h, alpha=0.6, target='base', layer=-5,},
            ['hbar']   = {file='bar.png', x=p.h, y=0, target='base', w=p.w-p.h, h=p.h, alpha=0.6, layer=-5,},
            ['shadow'] = {file='np_s.png', target='base', alpha=1, layer=-4,},
            ['box']    = {file='np.box.png', t='base', alpha=1, layer=-3},
            ['box2']   = {file='np.box.png', t='base', alpha=1, layer=-2},
        },
        fontString = {
            ['icon'] = { t='ォ', x=3, y=-4, jh='CENTER', jv ='MIDDLE', alpha=1},
            ['name'] = { x=p.h, y=-1, jh='LEFT', jv='TOP', alpha=1, a='TOPLEFT', pa='TOPLEFT'},
            ['note'] = { x=p.h, y=-7, jh='LEFT', jv='TOP', alpha=1},
            ['info'] = { x=p.h, y=-13, jh='LEFT', jv='TOP', alpha=1},
            ['health'] = { t='100%', x=-2, y=-1, jh='RIGHT', jv='TOP', a='TOPRIGHT', pa='TOPRIGHT', alpha=1},
            ['hpm'] = { t='', x=-2, y=-7, jh='RIGHT', jv='TOP', a='TOPRIGHT', pa='TOPRIGHT', alpha=1},
            ['target'] = { t='target', x=-2, y=-13, jh='RIGHT', jv='TOP', a='TOPRIGHT', pa='TOPRIGHT', alpha=1},
            ['debug'] = { x = 10, y = -30, jh = 'LEFT', jv = 'TOP', alpha=1},
            ['debug2'] = { x = 10, y = -40, jh = 'LEFT', jv = 'TOP', alpha=1},
        },
    }

    modTable.prefs.rgba = {
        red = { 0.5, 0.0, 0.0, 1, },
        green = { 0.0, 0.5, 0.0, 1, },
        blue = { 0.0, 0.0, 0.5, 1, },
        yellow = { 0.25, 0.25, 0.0, 1, },
        purple = { 0.5, 0.0, 0.5, 1, },
        cyan = { 0.0, 0.5, 0.5, 1, },
        orange = { 1.0, 0.5, 0.0, 1, },
        white = { 0.5, 0.5, 0.5, 1, },
        gray = { 0.5, 0.5, 0.5, 1, },
        pink = { 1, 0.0, 0.85, 1, },
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

    modTable.prefs.hex = {
        w = [[|cffffffff]],
        a = [[|cff777777]],
        r = [[|cffff2e38]],
        o = [[|cffffb836]],
        y = [[|cfffff000]],
        g = [[|cff24cf19]],
        b = [[|cff4975ff]],
        v = [[|cffd649ff]],
        c = [[|cff5bcefa]],
        p = [[|cfff563af]],
        gray = [[|cff888888]],
        hunter = [[|cffabd473]],
        brown = [[|cff8d5000]],
        warlock = [[|cff999ff3]],
        evoker = [[|cff8788ee]],
    }

    modTable.prefs.reaction = {
        [0] = { 0.5, 0.5, 0.5, 0.5, }, --gray
        [1] = { 0.75, 0.0, 0.0, 0.5, }, --hated
        [2] = { 1.0, 0.0, 0.0, 0.5, },
        [3] = { 1.0, 0.5, 0.0, 0.5, },
        [4] = { 1.0, 1.0, 0.0, 0.5, },
        [5] = { 0.0, 1.0, 0.0, 0.5, },
        [6] = { 0.0, 1.0, 0.33, 0.5, },
        [7] = { 0.0, 1.0, 0.66, 0.5, },
        [8] = { 0.0, 1.0, 1.0, 0.5, }, --exalted
    }

    modTable.prefs.enemy = {
        ['boss'] = { 0.5, 0, 0, 0.5, },
        ['worldboss'] = { 0.5, 0.0, 0.0, 0.5, },
        ['rareelite'] = { 0.45, 0.0, 0.0, 0.5, },
        ['elite'] = { 0.4, 0.0, 0.0, 0.5, },
        ['rare'] = { 0.35, 0.0, 0.0, 0.5, },
        ['normal'] = { 0.3, 0.0, 0.0, 0.5, },
        ['trivial'] = { 0.25, 0.0, 0.0, 0.5, },
        ['minus'] = { 0.2, 0.0, 0.0, 0.5, },
    }

    modTable.prefs.alpha = {
        ['boss']      = 1.0,
        ['worldboss'] = 1.0,
        ['rareelite'] = 0.8,
        ['elite']     = 0.7,
        ['rare']      = 0.6,
        ['normal']    = 0.3,
        ['trivial']   = 0.2,
        ['minus']     = 0.1,
    }

    modTable.prefs.icon = {
        ['?']         = 'よ',
        ['!']         = 'も',
        ['boss']      = 'ぢ',
        ['worldboss'] = '【',
        ['rareelite'] = '䆓',
        ['elite']     = '䅈',
        ['rare']      = '㎙',
        ['normal']    = '㌤',
        ['trivial']   = '󱔎',
        ['minus']     = '䅶',
        ['no']        = 'ォ',
        ['kick']      = '㏅',
        ['dick']      = '㏤',
        ['butt']      = '㏙',
        ['TANK']      = '㍵',
        ['HEALER']    = '㎈',
        ['DAMAGER']   = '㌤',
        ['NONE']      = 'ォ',
        ['CC']        = '㇂',
        ['nil']       = '␀',
        ['anal']      = '㐃',
        ['lips']      = '㎺',
        ['candle']    = '㍐',
        ['aoe']       = '㍘',
        ['boobs']     = '㏓',
        ['bot']       = '】',
        ['event']     = 'う',
        ['friend']    = '㊅',
        ['enemy']     = '㌤',
        ['random']    = '㌗',
        ['horde']     = '㌡',
        ['tankwarn']  = '㎂',
        ['dress']     = '㏄',
        ['PALADIN']   = '㌰',
        ['PRIEST']    = '㌲',
        ['HUNTER']    = '㌴',
        ['MAGE']      = '㌶',
        ['DRIUD']     = '㌸',
        ['DEMONHUNTER'] = '㌺',
        ['WARRIOR']   = '㍀',
        ['ROGUE']     = '㍂',
        ['SHAMAN']    = '㍄',
        ['WARLOCK']   = '㍆',
        ['EVOKER']    = '䂛',
        ['MONK']      = '䃱',
        ['DEATHKNIGHT'] = '㌢',
    }

    modTable.prefs.threat = {
        [0] = '-',
        [1] = '+',
        [2] = 'WARN',
        [3] = 'AGGRO',
    }

    modTable.prefs.guild = {
        ["The Immortal Taint"]  = { '䀈', 'p' },
        ["Tainted Angels"]      = { '㌦', 'c' },
        ["Taintcraft"]          = { '䂭', 'o' },
        ["Power Word Taint"]    = { '㍋', 'o' },
        ["War Taint"]           = { '㎆', 'v' },
        ["The Spreading Taint"] = { '㏛', 'o' },
        ["Taint"]               = { '㏠', 'v' },
        ["Bear Taint"]          = { '󱙵', 'v' },
        ["Tainter Tots"]        = { '󱜚', 'v' },
        ["Tainted Love"]        = { '㎡', 'v' },
        ["Taint of Madness"]    = { '䅡', 'v' },
        ["Taint No Thang"]      = { '〡', 'v' },
        ["Spreading Taint"]     = { '㐃', 'v' },
    }

    modTable.cache = {}
end

