--[[ ctrl - prefs.lua - t@wse.nyc - 18 July 2025 ]] --

---@class ctrl
local ctrl = select(2, ...)

-- Defaults, overwritten by user prefs

ctrl.prefs = {
    reset = true,
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
                size = 12,
                file = 'AnkaCoder-Bold.ttf',
                offset = {
                    x = 1,
                    y = -0.25,
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
                file = 'Prompt-Medium.ttf',
                offset = {
                    x = -0.5,
                    y = -1,
                },
            },
        },
        tgt = {
            frame = {
                width = 144,
            },
            font = {
                size = 12,
                file = 'Prompt-Medium.ttf',
                top = -2,
                spacing = 2,
            },
            icon = {
                size = 36,
            },
        },
        mobframe = {
            frame = {
                width = 276,
            },
            font = {
                size = 12,
                file = 'Prompt-Regular.ttf',
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
