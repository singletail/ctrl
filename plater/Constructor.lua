function (self, unitId, unitFrame, envTable, modTable)
    envTable.f = envTable.f or {}
    envTable.bar = envTable.bar or {}
    envTable.tx = envTable.tx or {}
    envTable.fs = envTable.fs or {}
    
    -- frames
    for fk, fv in pairs(modTable.elements.frame) do
        fv.target = envTable.f[fv.target] or unitFrame
        fv.w = fv.w or modTable.prefs.w
        fv.h = fv.h or modTable.prefs.h
        fv.a = fv.a or 'TOPLEFT'
        fv.pa = fv.pa or 'TOPLEFT'
        envTable.f[fk] = envTable.f[fk] or CreateFrame("frame", nil, fv.target)
        envTable.f[fk]:SetFrameStrata("BACKGROUND")
        envTable.f[fk]:SetFrameLevel(fv.fl)
        envTable.f[fk]:SetSize(fv.w, fv.h)
        envTable.f[fk]:SetPoint(fv.a, fv.target, fv.pa, fv.x, fv.y)
    end

    -- textures
    for tk, tv in pairs(modTable.elements.texture) do
        tv.target = tv.target or 'base'
        tv.w = tv.w or modTable.prefs.w
        tv.h = tv.h or modTable.prefs.h
        tv.x = tv.x or 0
        tv.y = tv.y or 0
        tv.a = tv.a or 'TOPLEFT'
        tv.pa = tv.pa or 'TOPLEFT'
        tv.alpha = tv.alpha or 1
        tv.layer = tv.layer or 0
        envTable.tx[tk] = envTable.tx[tk] or envTable.f[tv.target]:CreateTexture(nil, "BACKGROUND", nil, tv.layer)
        envTable.tx[tk]:SetTexture(modTable.prefs.path..tv.file, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE', 'TRILINEAR')
        envTable.tx[tk]:SetSize(tv.w, tv.h)
        envTable.tx[tk]:SetPoint(tv.a, envTable.f[tv.target], tv.pa, tv.x, tv.y)
        envTable.tx[tk]:SetAlpha(tv.alpha)
    end

    --fontObjects
    local fontPath = 'Interface\\AddOns\\ctrl\\assets\\fnt\\'
    local fontName = 'Prompt-Medium'
    local fontSize = 9
    local iconFontSize = 18
    local globalFont = 'ctrlfnt'..fontName..tostring(fontSize)
    local globalIconFont = 'ctrlfnt'..fontName..tostring(iconFontSize)

    if not _G[globalFont] then
        local fontObject = CreateFont(globalFont)
        fontObject:SetFont(fontPath..fontName..'.ttf', fontSize, '')
        _G[globalFont] = fontObject
    end

    if not _G[globalIconFont] then
        local fontObject = CreateFont(globalIconFont)
        fontObject:SetFont(fontPath..fontName..'.ttf', iconFontSize, '')
        _G[globalIconFont] = fontObject
    end

    envTable.font = _G[globalFont]
    envTable.iconfont = _G[globalIconFont]

    -- fontStrings
    for fk, fv in pairs(modTable.elements.fontString) do
        fv.t = fv.t or tostring(fk)
        fv.target = fv.target or 'top'
        fv.a = fv.a or 'TOPLEFT'
        fv.pa = fv.pa or 'TOPLEFT'
        fv.x = fv.x or 0
        fv.y = fv.y or 0
        fv.alpha = fv.alpha or 1
        fv.jh = fv.jh or 'LEFT'
        fv.jv = fv.jv or 'MIDDLE'

        envTable.fs[fk] = envTable.fs[fk] or envTable.f[fv.target]:CreateFontString()
        
        if tonumber(fv.w) and tonumber(fv.h) then
            envTable.fs[fk]:SetSize(fv.w, fv.h)
            envTable.fs[fk]:SetPoint(fv.a, envTable.f[fv.target], fv.pa, fv.x, fv.y)
            envTable.fs[fk]:SetPoint('BOTTOMRIGHT', envTable.f[fv.target], 'TOPLEFT', fv.x + fv.w, fv.y - fv.h)
        else
            envTable.fs[fk]:SetPoint(fv.a, envTable.f[fv.target], fv.pa, fv.x, fv.y)
        end
        if fk == 'icon' then
            envTable.fs[fk]:SetFontObject(envTable.iconfont)
        else
            envTable.fs[fk]:SetFontObject(envTable.font)
        end
        envTable.fs[fk]:SetJustifyH(fv.jh)
        envTable.fs[fk]:SetJustifyV(fv.jv)
        envTable.fs[fk]:SetText(fv.t)
        envTable.fs[fk]:SetAlpha(fv.alpha)
    end
end

