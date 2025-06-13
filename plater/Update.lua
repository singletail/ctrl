function(self, unitId, unitFrame, envTable, modTable)
    envTable.data = envTable.data or {}
    modTable.cache = modTable.cache or {}

    if UnitGUID(unitId) and UnitGUID(unitId) ~= envTable.data.guid then
        envTable.tx.error:SetAlpha(1)
        envTable.fs.id:SetText(modTable.prefs.hex.y .. string.sub(unitId, 10))
        envTable.data = {
            guid = UnitGUID(unitId),
            reaction = UnitReaction('player', unitId) or 0,
            rgba = modTable.prefs.reaction[envTable.data.reaction],
        }
        if UnitIsPlayer(unitId) then
            envTable.data.name = UnitPVPName(unitId) or UnitName(unitId) or ''
            envTable.data.guild, envTable.data.guildRank = GetGuildInfo(unitId)
            envTable.data.note = tostring(envTable.data.guild or '')
            envTable.data.info = tostring(envTable.data.guildRank or '')
            envTable.data.class = select(2, UnitClass(unitId)) or 'nil'
            envTable.data.icon = modTable.prefs.icon[envTable.data.class] or modTable.prefs.icon['nil']
            if C_FriendList.IsFriend(envTable.data.guid) then
                envTable.data.icon = modTable.prefs.hex.p .. '㎠'
                envTable.data.name = modTable.prefs.hex.p .. envTable.data.name
            elseif modTable.prefs.guild[envTable.data.guild] then
                envTable.data.icon = string.format('%s%s', modTable.prefs.guild[envTable.data.guild][1], modTable.prefs.hex[modTable.prefs.guild[envTable.data.guild][2]])
                envTable.data.note = string.format('%s%s', modTable.prefs.hex[modTable.prefs.guild[envTable.data.guild][2]], envTable.data.guild)
            end
            envTable.data.alpha = 1
            envTable.data.scale = 1
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
                modTable.cache[envTable.data.npcId].icon = modTable.prefs.icon[modTable.cache[envTable.data.npcId].classification] or modTable.prefs.icon['nil']
                if modTable.cache[envTable.data.npcId].creatureType == modTable.cache[envTable.data.npcId].family then
                    modTable.cache[envTable.data.npcId].family = nil end
                modTable.cache.note = tostring(modTable.cache[envTable.data.npcId].creatureType) .. ' ' .. tostring(modTable.cache[envTable.data.npcId].family)
                modTable.cache[envTable.data.npcId].alpha = modTable.prefs.alpha[modTable.cache[envTable.data.npcId].classification]
                
                if _G['CtrlDB'] and _G['CtrlDB'][envTable.data.npcId] then
                    local ent = _G['CtrlDB'][envTable.data.npcId]
                    if ent.p then
                        modTable.cache[envTable.data.npcId].icon = tostring(ent.p[1]) or '?'
                        modTable.cache[envTable.data.npcId].rgba = ent.p[2] or {1, 1, 1, 1}
                        modTable.cache[envTable.data.npcId].hex = ent.p[3] or modTable.prefs.hex.a
                        modTable.cache[envTable.data.npcId].alpha = 1
                        modTable.cache[envTable.data.npcId].note = ent.t or ''
                        modTable.cache[envTable.data.npcId].note2 = ent.t2 or ''
                        modTable.cache[envTable.data.npcId].note3 = ent.t3 or ''
                        modTable.cache[envTable.data.npcId].scale = ent.scale or 1
                    end
                end
            end

            envTable.data.name = modTable.cache[envTable.data.npcId].name or 'error'
            envTable.data.classification = modTable.cache[envTable.data.npcId].classification or ''
            envTable.data.icon = modTable.cache[envTable.data.npcId].icon or ''
            if modTable.cache[envTable.data.npcId].rgba then envTable.data.rgba = modTable.cache[envTable.data.npcId].rgba end
            if modTable.cache[envTable.data.npcId].hex then envTable.data.hex = modTable.cache[envTable.data.npcId].hex end
            envTable.data.note = modTable.cache[envTable.data.npcId].note or ''
            envTable.data.note2 = modTable.cache[envTable.data.npcId].note2 or ''
            envTable.data.note3 = modTable.cache[envTable.data.npcId].note3 or ''
            envTable.data.alpha = modTable.cache[envTable.data.npcId].alpha
            envTable.data.scale = modTable.cache[envTable.data.npcId].scale or 0.75

            if unitType == 'Creature' or unitType == 'Vehicle' then
                envTable.data.unitType = unitType --temp
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
            envTable.data.target = modTable.prefs.hex.p
        elseif UnitIsPlayer(unitId..'target') then
            envTable.data.target = modTable.prefs.hex.g
        end
        envTable.data.target = envTable.data.target .. '㎘ ' .. (GetUnitName(unitId..'target') .. ' ' or '')
    elseif UnitIsPlayer(unitId) then
        envTable.data.target = tostring(envTable.data.guildRank or '')
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

    unitFrame.healthBar.unitName:SetText(envTable.data.name)
    envTable.fs.icon:SetText(tostring(envTable.data.icon))
    envTable.fs.note:SetText(tostring(envTable.data.note))
    envTable.fs.debug:SetText(tostring(envTable.data.note2 or ''))
    envTable.fs.debug2:SetText(tostring(envTable.data.note3 or ''))
    envTable.fs.info:SetText(tostring(envTable.data.target))

    envTable.tx.frame:SetVertexColor(envTable.data.rgba[1], envTable.data.rgba[2], envTable.data.rgba[3], envTable.data.alpha)
    envTable.tx.circle:SetVertexColor(envTable.data.rgba[1], envTable.data.rgba[2], envTable.data.rgba[3], envTable.data.alpha)
    envTable.fs.npcId:SetText(modTable.prefs.hex.v..tostring(envTable.data.npcId))
    envTable.tx.frame:SetAlpha(envTable.data.alpha)
    envTable.tx.circle:SetAlpha(envTable.data.alpha)
    unitFrame.healthBar:SetScale(envTable.data.scale)
    envTable.tx.error:SetAlpha(0) -- no errors
end

