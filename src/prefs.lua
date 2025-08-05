--[[ ctrl - prefs.lua - t@wse.nyc - 18 July 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

-- Defaults, overwritten by user prefs

ctrl.defaults = {
    font = {
        file = 'Prompt-Medium',
        size = 11,
        flags = '',
    },
    log = {
        enable = nil,
        level = 8,
        max = 1000,
        index = 1,
        --wipe = 1,
    },
    player = {
        --wipe = nil,
    },
    unit = {
        --wipe = 1,
    },
    loot = {
        --wipe = 1,
    },
    ui = {
        height = 128,
        scale = 1,
    },
    mod = {
        power = {
            frame = {
                width = 20,
            },
            buttons = {
                width = 18,
                height = 18,
                spacing = -4,
                top = -36,
            },
            font = {
                size = 9,
                file = 'Prompt-Medium',
                offset = {
                    x = 0,
                    y = 0,
                },
            },
        },
        cmd = {
            frame = {
                width = 72,
            },
            buttons = {
                width = 64,
                height = 24,
                spacing = -4,
                top = 1,
            },
            font = {
                size = 11,
                file = 'Prompt-Medium',
                offset = {
                    x = -0.5,
                    y = -1,
                },
            },
        },
        info = {
            frame = {
                width = 90,
            },
            box = {
                x = -10,
                y = -4,
                width = 40,
                height = 18,
                spacing = 2,
                font = {
                    size = 11,
                    file = 'DSEG7',
                    offset = {
                        x = -4,
                        y = -2,
                    },
                },
            },
            font = {
                size = 11,
                file = 'Prompt-Medium',
                x = -8,
                y = -10,
                spacing = 20,
            },
            lamp = {
                template='retrolamp',
                width = 24,
                height = 24,
                x = 6,
                y = -1,
                spacing = 20,
            },
        },
        tgt = {
            frame = {
                width = 188,
            },
            font = {
                size = 11,
                file = 'Prompt-Medium',
                top = -8,
                spacing = 0,
            },
            icon = {
                size = 22,
                x = 6,
                y = -20,
            },
        },
        speed = {
            compass = 1,
            frame = {
                width = 72,
            },
            icon = {
                fontSize = 21,
                fontFile = 'Prompt-Medium',
                x = -2,
                y = -6,
            },
            display = {
                fontSize = 18,
                fontFile = 'DSEG7',
                w = 64,
                h = 32,
                x = -9,
                y = -26,
            },
            stats = {
                fontSize = 11,
                fontFile = 'DSEG7',
            },
        },
        mobframe = {
            frame = {
                width = 276,
            },
            font = {
                size = 11,
                file = 'Prompt-Medium',
            },
        },
    },
}

-- TODO
ctrl.prefs = ctrl.defaults

function ctrl.loadprefs()
    ctrl.log(ctrl.master, 5, 'ctrl.loadprefs()')
    ctrl.data.prefs = ctrl.cp(ctrl.defaults)

    ctrl.prefs = ctrl.data.prefs
    ctrl.log(ctrl.master, 5, 'ctrl.prefs ready')
end
