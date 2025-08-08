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
    ['gv'] = {
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
                    { file = 'gv_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'gv_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    { file = 'gv_glow', alpha = 0.25, color = nil, layer = -3, path = ctrl.p.btns },
                },
            }
        },
    },
    ['power'] = {
        subclass = 'NC',
        values = { 0, 1 },
        default = 1,
        w = 64,
        h = 64,
        texture = {
            static = {
                { file = 'power_bk', alpha = 1, color = nil, layer = -7, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'power_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'power_under', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                    { file = 'power_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    { file = 'power_glow', alpha = 0.25, color = nil, layer = -3, path = ctrl.p.btns },
                },
            }
        },
    },
    ['ins'] = {
        subclass = 'NC',
        values = { 0, 1 },
        default = 1,
        w = 64,
        h = 64,
        texture = {
            static = {
                { file = 'ins_bk', alpha = 0.5, color = nil, layer = -7, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'ins_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'ins_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    { file = 'ins_glow', alpha = 0.25, color = nil, layer = -3, path = ctrl.p.btns },
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
                    { file = 'retrolamp_on', alpha = 0.5, color = nil, layer = -4, path = ctrl.p.btns },
                    { file = 'retrolamp_on', alpha = 0.5, color = 1, layer = -3, path = ctrl.p.btns },
                    { file = 'retrolamp_glow', alpha = 0.5, color = nil, layer = -2, path = ctrl.p.btns },
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
    ['wide'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 0,
        w = 72,
        h = 36,
        texture = {
            static = {
                { file = 'big_bk.png', alpha = 1, color = nil, layer = -6, path = ctrl.p.bx }
            },
            value = {
                [0] = {
                    { file = 'big_off.png', alpha = 1, color = 1, layer = -5, path = ctrl.p.bx },
                    { file = 'big_on.png', alpha = 0.5, color = 1, layer = -4, path = ctrl.p.bx },
                },
                [1] = {
                    { file = 'big_on.png', alpha = 1, color = 1, layer = -4, path = ctrl.p.bx },
                },
            }
        },
    },
    ['widetoggle'] = {
        subclass = 'NO',
        values = { 0, 1 },
        default = 0,
        w = 72,
        h = 36,
        texture = {
            static = {
                { file = 'big_bk.png', alpha = 1, color = nil, layer = -6, path = ctrl.p.bx }
            },
            value = {
                [0] = {
                    { file = 'big_off.png', alpha = 1, color = nil, layer = -5, path = ctrl.p.bx },
                },
                [1] = {
                    { file = 'big_on.png', alpha = 1, color = 1, layer = -4, path = ctrl.p.bx },
                },
            }
        },
    },
}
