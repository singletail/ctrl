function(self, unitId, unitFrame, envTable, modTable)
    
    self.v = {
        debug = 1,
        guid = nil,
        spawnId = 0,
        uid = 0,
    }
    
    self.str = {
        debug = '',
        icon = '',
        note = {
            [1] = '',
            [2] = '',
            [3] = '',
        },
        target = '',
        info = '',
    }
    
    envTable.c = {
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
    }
    
    envTable.threatStr = {
        [0] = string.format('%s%s', envTable.c.w, 'Low'),
        [1] = string.format('%s%s', envTable.c.o, 'Increasing'),
        [2] = string.format('%s%s', envTable.c.y, 'Warning'),
        [3] = string.format('%s%s', envTable.c.c, 'Tanking'),
    }

    envTable.s = {
        ['boss']      = 'ぢ',
        ['worldboss'] = '【',
        ['rareelite'] = '䆓',
        ['elite']     = '䅈',
        ['rare']      = '㎙',
        ['normal']    = ' ',
        ['trivial']   = '󱔎',
        ['minus']     = '䅶',
        ['no']        = 'ォ',
        ['?']         = 'よ',
        ['kick']      = '㏅',
        ['dick']      = '㏤',
        ['butt']      = '㏙',
        ['TANK']      = '㍵',
        ['HEALER']    = '㎈',
        ['DAMAGER']   = '㌤',
        ['NONE']      = 'ォ',
        ['CC']        = '㇂',
    }
    
    envTable.guilds = {
        ["The Immortal Taint"]  = { sChar = '䀈', sCol = envTable.c.c },
        ["Tainted Angels"]      = { sChar = '㌦', sCol = envTable.c.p },
        ["Taintcraft"]          = { sChar = '䂭', sCol = envTable.c.o },
        ["Power Word Taint"]    = { sChar = '㍋', sCol = envTable.c.o },
        ["War Taint"]           = { sChar = '㎆', sCol = envTable.c.v },
        ["The Spreading Taint"] = { sChar = '㏛', sCol = envTable.c.o },
        ["Taint"]               = { sChar = '㏠', sCol = envTable.c.v },
        ["Bear Taint"]          = { sChar = '󱙵', sCol = envTable.c.v },
        ["Tainter Tots"]        = { sChar = '󱜚', sCol = envTable.c.v },
        ["Tainted Love"]        = { sChar = '㎡', sCol = envTable.c.v },
        ["Taint of Madness"]    = { sChar = '䅡', sCol = envTable.c.v },
        ["Taint No Thang"]      = { sChar = '〡', sCol = envTable.c.v },
        ["Spreading Taint"]     = { sChar = '㐃', sCol = envTable.c.v },
    }
    
    local font = {
        icon = [[Interface\Addons\SharedMedia_Singletail\font\Prompt-Bold.ttf]],
        note = [[Interface\Addons\SharedMedia_Singletail\font\Prompt-SemiBold.ttf]],
        debug = [[Interface\Addons\SharedMedia_Singletail\font\Prompt-SemiBold.ttf]],
        target = [[Interface\Addons\SharedMedia_Singletail\font\Prompt-SemiBold.ttf]],
        info = [[Interface\Addons\SharedMedia_Singletail\font\Prompt-SemiBold.ttf]],
    }
    
    local fontSize = { icon = 28, note = 10, debug = 8, target = 8, info = 8 }
    
    unitFrame.label = unitFrame.label or {}
    
    unitFrame.label.icon = unitFrame.label.icon or Plater:CreateLabel(unitFrame.healthBar, "", fontSize.icon, "white", nil)
    unitFrame.label.icon:SetPoint('TOPLEFT', unitFrame.healthBar, 'TOPLEFT', -30, 12)
    unitFrame.label.icon:SetFont(font.icon, fontSize.icon, '')
    
    unitFrame.label.info = unitFrame.label.info or Plater:CreateLabel(unitFrame.healthBar, "", fontSize.info, "white", nil)
    unitFrame.label.info:SetPoint('TOPLEFT', unitFrame.healthBar, 'TOPLEFT', 1, -3)
    unitFrame.label.info:SetFont(font.info, fontSize.info, '')
    
    unitFrame.label.target = unitFrame.label.target or Plater:CreateLabel(unitFrame.healthBar, "", fontSize.target, "white", nil)
    unitFrame.label.target:SetPoint('TOPRIGHT', unitFrame.healthBar, 'TOPRIGHT', -1, -3)
    unitFrame.label.target:SetFont(font.target, fontSize.target, '')
    
    -- mobId
    unitFrame.label.debug = unitFrame.label.debug or Plater:CreateLabel(unitFrame.healthBar, "", fontSize.debug, "white", nil)
    unitFrame.label.debug:SetPoint('TOPLEFT', unitFrame.healthBar, 'TOPLEFT', 0, 19)
    unitFrame.label.debug:SetFont(font.debug, fontSize.debug, '')
    
    unitFrame.label.note = unitFrame.label.note or {}
    for i = 1, 3 do
        unitFrame.label.note[i] = unitFrame.label.note[i] or Plater:CreateLabel(unitFrame.healthBar, "", fontSize.note, "white", nil)
        unitFrame.label.note[i]:SetPoint('TOPLEFT', unitFrame.healthBar, 'TOPLEFT', 1, -((i*9)+4))
        unitFrame.label.note[i]:SetFont(font.note, fontSize.note, '')
    end
    
end



