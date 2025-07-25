function(self, unitId, unitFrame, envTable, modTable)
    envTable.data = envTable.data or {}
    modTable.cache = modTable.cache or {}

    if UnitGUID(unitId) and UnitGUID(unitId) ~= envTable.data.guid then
        envTable.data = {
            guid = UnitGUID(unitId),
            reaction = UnitReaction('player', unitId) or 0,
            rgba = modTable.prefs.reaction[envTable.data.reaction] or {1, 1, 1, 1},
        }
        if UnitIsPlayer(unitId) then
            envTable.data.name = UnitPVPName(unitId) or UnitName(unitId) or ''
            envTable.data.guild, envTable.data.guildRank = GetGuildInfo(unitId)
            envTable.data.note = tostring(envTable.data.guild or '')
            envTable.data.info = tostring(envTable.data.guildRank or '')
            envTable.data.class = select(2, UnitClass(unitId)) or 'nil'
            envTable.data.debug = '' --tostring(UnitGUID(unitId))
            envTable.data.debug2 = ''
            if envTable.data.class ~= 'nil' and modTable.prefs.rgba[envTable.data.class] then
                envTable.data.rgba = modTable.prefs.rgba[envTable.data.class]
            else
                envTable.data.rgba = {0, 0, 0, 1}
            end
            envTable.data.icon = modTable.prefs.icon[envTable.data.class] or modTable.prefs.icon['nil']
            if C_FriendList.IsFriend(envTable.data.guid) then
                envTable.data.icon = modTable.prefs.hex.p .. '㎠'
                envTable.data.name = modTable.prefs.hex.p .. envTable.data.name
            elseif modTable.prefs.guild[envTable.data.guild] then
                envTable.data.icon = string.format('%s%s', modTable.prefs.guild[envTable.data.guild][1], modTable.prefs.hex[modTable.prefs.guild[envTable.data.guild][2] ])
                envTable.data.guild = string.format('%s%s', modTable.prefs.hex[modTable.prefs.guild[envTable.data.guild][2] ], envTable.data.guild)
            end
        else
            local unitType, _, _, _, _, uId, spawnId = strsplit('-', envTable.data.guid)
            envTable.data.npcId = tonumber(uId)

            if modTable.cache[envTable.data.npcId] == nil then
                modTable.cache[envTable.data.npcId] = {
                    name = UnitName(unitId),
                    classification = UnitClassification(unitId),
                    family = UnitCreatureFamily(unitId) or '',
                    creatureType = UnitCreatureType(unitId) or '',
                }
                modTable.cache[envTable.data.npcId].icon = modTable.prefs.icon[modTable.cache[envTable.data.npcId].classification] or 'よ'
                if modTable.cache[envTable.data.npcId].creatureType == modTable.cache[envTable.data.npcId].family then
                    modTable.cache[envTable.data.npcId].family = nil end
                modTable.cache[envTable.data.npcId].mobinfo = tostring(modTable.cache[envTable.data.npcId].creatureType) .. ' ' .. tostring(modTable.cache[envTable.data.npcId].family)

                if _G['CtrlDB'] and _G['CtrlDB'][envTable.data.npcId] then
                    local ent = _G['CtrlDB'][envTable.data.npcId]
                    if ent.p then
                        modTable.cache[envTable.data.npcId].icon = tostring(ent.p[1]) or '?'
                        modTable.cache[envTable.data.npcId].rgba = ent.p[2] or {1, 1, 1, 1}
                        modTable.cache[envTable.data.npcId].hex = ent.p[3] or modTable.prefs.hex.a
                        modTable.cache[envTable.data.npcId].note1 = ent.t
                        modTable.cache[envTable.data.npcId].note2 = ent.t2
                        modTable.cache[envTable.data.npcId].note3 = ent.t3
                    end
                end
            end
            
            envTable.data.name = modTable.cache[envTable.data.npcId].name or 'error'
            envTable.data.classification = modTable.cache[envTable.data.npcId].classification or ''
            envTable.data.icon = modTable.cache[envTable.data.npcId].icon or ''
            if modTable.cache[envTable.data.npcId].rgba then envTable.data.rgba = modTable.cache[envTable.data.npcId].rgba end
            if modTable.cache[envTable.data.npcId].hex then envTable.data.hex = modTable.cache[envTable.data.npcId].hex end
            envTable.data.mobinfo = modTable.cache[envTable.data.npcId].mobinfo or ''
            envTable.data.note1 = modTable.cache[envTable.data.npcId].note1
            envTable.data.note2 = modTable.cache[envTable.data.npcId].note2
            envTable.data.note3 = modTable.cache[envTable.data.npcId].note3
            
            if unitType == 'Creature' or unitType == 'Vehicle' then
                envTable.data.unitType = unitType
                envTable.data.spawnId = tonumber(bit.rshift(bit.band(tonumber(string.sub(spawnId, 1, 5), 16), 0xffff8), 3))
                if envTable.data.spawnId then
                    envTable.data.name = envTable.data.name .. ' ' .. tostring(envTable.data.spawnId)
                end
            end
        end
    end
    
    envTable.data.target = ''
    if UnitExists(unitId..'target') and not UnitIsDead(unitId..'target') then
        if UnitIsUnit('player', unitId..'target') then
            envTable.data.target = modTable.prefs.hex.y
        elseif UnitIsPlayer(unitId..'target') then
            envTable.data.target = modTable.prefs.hex.w
        end
        envTable.data.target = envTable.data.target .. '㎘ ' .. (GetUnitName(unitId..'target') .. ' ' or '')
    else
        envTable.data.target = ''
    end

    if not UnitIsPlayer(unitId) then
        local _, threatStatus, threatPct, _, _ = UnitDetailedThreatSituation('player', unitId)
        if threatStatus then
            envTable.data.target = envTable.data.target ..  string.format('%s %d', modTable.prefs.threat[threatStatus], math.floor(threatPct))
        end
        if UnitIsQuestBoss(unitId) then
            envTable.data.icon = '!'
            envTable.data.rgba = modTable.prefs.rgba.pink
            envTable.data.hex = modTable.prefs.hex.p
        end
        if UnitIsInteractable(unitId) then
            envTable.data.icon = modTable.prefs.icon.lips
            envTable.data.rgba = modTable.prefs.rgba.cyan
            envTable.data.hex = modTable.prefs.hex.c
        end
        if UnitIsTapDenied(unitId) then
            envTable.data.icon = modTable.prefs.icon.no
            envTable.data.rgba = modTable.prefs.rgba.gray
            envTable.data.hex = modTable.prefs.hex.a
        end
    end

    if envTable.data.hex then
        envTable.data.icon = envTable.data.hex .. envTable.data.icon
        envTable.data.name = envTable.data.hex .. envTable.data.name
    end

    unitFrame.healthBar.unitName:SetAlpha(0)
    unitFrame.healthBar.border:SetAlpha(0)
    unitFrame.healthBar.barTexture:SetAlpha(0)
    unitFrame.healthBar.barTextureMask:SetAlpha(0)
    unitFrame.healthBar.background:SetAlpha(0)

    -- Combat modifiers
    if UnitAffectingCombat(unitId) then
        envTable.data.alpha = 0.8
        --envTable.f.base:SetScale(1)
        --envTable.f.top:SetScale(1)
    else
        envTable.data.alpha = 0.6
        --envTable.f.base:SetScale(0.75)
        --envTable.f.top:SetScale(0.75)
    end

    -- border
    if UnitIsUnit('target', unitId) then
        envTable.tx.box:SetVertexColor(1.0, 1.0, 0.0, 1.0)
        envTable.tx.box2:SetVertexColor(1.0, 1.0, 0.0, 1.0)
        envTable.tx.box:SetAlpha(1)
        envTable.tx.box2:SetAlpha(1)
    else
        envTable.tx.box:SetVertexColor(0, 0, 0, 0)
        envTable.tx.box2:SetVertexColor(0, 0, 0, 0)
        envTable.tx.box:SetAlpha(1)
        envTable.tx.box2:SetAlpha(1)
    end

    -- Health
    if UnitIsDeadOrGhost(unitId) then
        envTable.data.healthText = 'dead'
        envTable.data.healthText2 = ''
    else
        envTable.data.health = UnitHealth(unitId) or 0
        envTable.data.maxHealth = UnitHealthMax(unitId) or 1
        envTable.data.healthPct = math.floor(envTable.data.health / envTable.data.maxHealth * 100)
        envTable.data.healthText = string.format('%d%%', envTable.data.healthPct)
        envTable.data.healthText2 = string.format('%s', Plater.FormatNumber(envTable.data.health, 1))
    end

    -- health bar
    local healthBarWidth = envTable.data.healthPct * modTable.prefs.multi
    if healthBarWidth > (modTable.prefs.multi * 100) then
        healthBarWidth = (modTable.prefs.multi * 100)
    end
    if envTable.tx.hbar then envTable.tx.hbar:SetWidth(healthBarWidth) end

    -- text
    if envTable.fs.name then envTable.fs.name:SetText(tostring(envTable.data.name or 'Unknown')) end
    envTable.fs.icon:SetText(tostring(envTable.data.icon or ''))

    if envTable.data.note1 and envTable.data.note2 then
        envTable.fs.note:SetText(envTable.data.note1)
        envTable.fs.info:SetText(envTable.data.note2)
    elseif envTable.data.note1 then
        envTable.fs.note:SetText(envTable.data.mobinfo or '')
        envTable.fs.info:SetText(envTable.data.note1)
    elseif envTable.data.guild then
        envTable.fs.note:SetText(envTable.data.guild)
        envTable.fs.info:SetText(envTable.data.guildRank or '')
    else
        envTable.fs.note:SetText(envTable.data.mobinfo or '')
        envTable.fs.info:SetText('')
    end

    if envTable.data.note3 then
        envTable.fs.debug:SetText(envTable.data.note3)
        envTable.fs.debug2:SetText(envTable.data.debug or '')
    else
        envTable.fs.debug:SetText(envTable.data.debug or '')
        envTable.fs.debug2:SetText(envTable.data.debug2 or '')
    end

    --health
    envTable.fs.target:SetText(tostring(envTable.data.target or ''))
    envTable.fs.health:SetText(tostring(envTable.data.healthText or ''))
    envTable.fs.hpm:SetText(tostring(envTable.data.healthText2 or ''))
    
    -- bar color
    if envTable.tx.cap then envTable.tx.cap:SetVertexColor(envTable.data.rgba[1], envTable.data.rgba[2], envTable.data.rgba[3], envTable.data.rgba[4]) end
    if envTable.tx.hbar then envTable.tx.hbar:SetVertexColor(envTable.data.rgba[1], envTable.data.rgba[2], envTable.data.rgba[3], envTable.data.rgba[4]) end
    
    -- alpha
    --envTable.tx.bk:SetAlpha(0.6)
    envTable.tx.cap:SetAlpha(envTable.data.alpha)
    envTable.tx.hbar:SetAlpha(envTable.data.alpha)
    envTable.tx.box:SetAlpha(envTable.data.alpha)
    --envTable.fs.name:SetAlpha(envTable.data.alpha)
    --envTable.fs.note:SetAlpha(envTable.data.alpha)
    --envTable.fs.info:SetAlpha(envTable.data.alpha)
    --envTable.fs.target:SetAlpha(envTable.data.alpha)
end

