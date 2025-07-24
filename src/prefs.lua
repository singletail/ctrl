--[[ ctrl - prefs.lua - t@wse.nyc - 18 July 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

-- Defaults, overwritten by user prefs

ctrl.prefs = {
    reset = true,
    font = {
        file = 'Prompt-Medium',
        size = 11,
        flags = '',
    },
    log = {
        enable = 1,
        level = 8,
        max = 1000,
        index = 1,
    },
    ui = {
        height = 128,
        scale = 1,
    },
    mod = {
        power = {
            frame = {
                width = 24,
            },
            buttons = {
                width = 22,
                height = 22,
                spacing = -4,
                top = -36,
            },
            font = {
                size = 11,
                file = 'Prompt-Medium',
                offset = {
                    x = 0,
                    y = -1,
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
        tgt = {
            frame = {
                width = 168,
            },
            font = {
                size = 11,
                file = 'Prompt-Medium',
                top = -2,
                spacing = 2,
            },
            icon = {
                size = 28,
            },
        },
        info = {
            frame = {
                width = 96,
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

function ctrl.loadprefs()
    if ctrl.prefs.reset then
        ctrl.data.prefs = ctrl.cp(ctrl.prefs)
    else
        ctrl.merge(ctrl.data.prefs, ctrl.prefs)
    end
    ctrl.prefs = ctrl.data.prefs
end
