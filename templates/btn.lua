--[[ ctrl - templates\buttons.lua - t@wse.nyc - 7/21/24 ]] --

local _, ctrl = ...

ctrl.templates = ctrl.templates or {}
ctrl.templates.btn = {

    ['btn_smol'] = {
        subclass = 'SPST',
        values = { 0, 1 },
        default = 1,
        w = 64,
        h = 64,
        texture = {
            static = {
                { file = 'smol_bk', alpha = 1, color = nil, layer = -6, path = ctrl.p.btns }
            },
            value = {
                [0] = {
                    { file = 'smol_off', alpha = 1, color = 1, layer = -5, path = ctrl.p.btns },
                },
                [1] = {
                    { file = 'smol_on', alpha = 1, color = 1, layer = -4, path = ctrl.p.btns },
                    --{ file = 'smol_glow', alpha = 0.25, color = nil, layer = -3, path = ctrl.p.btns },
                },
            }
        },
    },
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
}
