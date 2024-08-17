--[[ ctrl - templates\buttons.lua - t@wse.nyc - 7/21/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

ctrl.templates = ctrl.templates or {}
ctrl.templates.btn = {
    --[[
    ['btn_smol'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 1,
        w = 64,
        h = 64,
        texture = {
            static = {
                { file = 'smol_bk', alpha = 1, color = nil, layer = 2, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'smol_off', alpha = 1, color = 1, layer = 3, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'smol_on', alpha = 1, color = 1, layer = 4, path = ctrl.p.btns },
                    { file = 'smol_glow', alpha = 0.25, color = nil, layer = 5, path = ctrl.p.btns },
                },
            }
        },
    },
    ['btn_sq'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 1,
        w = 64,
        h = 64,
        texture = {
            static = {
                { file = 'sq_bk', alpha = 1, color = nil, layer = -6, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'sq_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'sq_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    { file = 'sq_glow', alpha = 0.25, color = nil, layer = -3, path = ctrl.p.btns },
                },
            }
        },
    },
    ]]
    ['beeg'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 1,
        w = 128,
        h = 48,
        texture = {
            static = {
                { file = 'beeg_bk', alpha = 1, color = nil, layer = -6, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'beeg_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                    { file = 'beeg_on', alpha = 0.5, color = 1, layer = -4, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'beeg_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                },
            }
        },
    },
    --[[
    ['prot'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 1,
        w = 64,
        h = 64,
        texture = {
            static = {
                { file = 'prot_bk', alpha = 1, color = nil, layer = -6, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'sq_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'sq_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    { file = 'sq_glow', alpha = 0.5, color = nil, layer = -3, path = ctrl.p.btns },
                },
            }
        },
    },
    ]]
    ['sq'] = {
        subclass = 'NC',
        values = { 0, 1 },
        default = 1,
        w = 64,
        h = 64,
        texture = {
            static = {
                { file = 'sq_bk', alpha = 1, color = nil, layer = -7, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'sq_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'sq_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    { file = 'sq_glow', alpha = 0.25, color = nil, layer = -3, path = ctrl.p.btns },
                },
            }
        },
    },
    ['retrolamp'] = {
        subclass = 'NO',
        values = { 0, 1 },
        default = 0,
        w = 36,
        h = 36,
        texture = {
            static = {
                { file = 'retrolamp_bk', alpha = 1, color = nil, layer = -7, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'retrolamp_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'retrolamp_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                    { file = 'retrolamp_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    { file = 'retrolamp_on', alpha = 0.5, color = nil, layer = -3, path = ctrl.p.btns },
                    { file = 'retrolamp_glow', alpha = 1, color = nil, layer = -2, path = ctrl.p.btns },
                },
            }
        },
    },
    ['dolby'] = {
        subclass = 'NO',
        values = { 0, 1 },
        default = 0,
        w = 36,
        h = 36,
        texture = {
            static = {
                { file = 'dolby_bk', alpha = 1, color = nil, layer = -7, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'dolby_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'dolby_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                    { file = 'dolby_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    { file = 'dolby_glow', alpha = 1, color = nil, layer = -3, path = ctrl.p.btns },
                    { file = 'dolby_glow', alpha = 1, color = nil, layer = -2, path = ctrl.p.btns },
                },
            }
        },
    },
    --[[
    ['btn_power'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 1,
        w = 64,
        h = 64,
        texture = {
            static = {
                { file = 'power_bk', alpha = 1, color = nil, layer = -6, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'power_off', alpha = 1, color = nil, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'power_under', alpha = 0.75, color = 1,   layer = -4, path = ctrl.p.btns },
                    { file = 'power_on',    alpha = 1,    color = nil, layer = -3, path = ctrl.p.btns },
                    { file = 'power_glow',  alpha = 0.2,  color = 1,   layer = -2, path = ctrl.p.btns },
                },
            }
        },
    },
    ['btn_scan'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 0,
        w = 64,
        h = 32,
        texture = {
            static = {
                { file = '41_bk', alpha = 1, color = nil, layer = -6, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = '41_green_off', alpha = 1, color = nil, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = '41_green_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                },
            }
        },
    },
    ['btn_delete'] = {
        subclass = 'NC',
        values = { 0, 1 },
        default = 0,
        w = 24,
        h = 24,
        texture = {
            value = {
                [0] = {
                    { file = 'wf_off', alpha = 1, color = nil, layer = -3, path = ctrl.p.btns, },
                },
                [1] = {
                    { file = 'wf_on', alpha = 1, color = nil, layer = -1, path = ctrl.p.btns, },
                },
            }
        },
    },
    ['btn_entry'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 0,
        w = 128,
        h = 32,
        texture = {
            value = {
                [0] = {
                    { file = 'textbox', alpha = 1, color = nil, layer = -3, path = ctrl.p.btns, },
                },
                [1] = {
                    { file = 'textbox', alpha = 1, color = nil, layer = -1, path = ctrl.p.btns, },
                },
            }
        },
    },
    ['btn_enabled'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 1,
        w = 32,
        h = 32,
        texture = {
            value = {
                [0] = {
                    { file = 'sr_off', alpha = 1, color = nil, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'sr_green', alpha = 1, color = nil, layer = -4, path = ctrl.p.btns },
                },
            }
        },
    },
    ]]
}
