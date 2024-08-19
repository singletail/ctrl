function(self, unitId, unitFrame, envTable, modTable)
    if self.str.name == '' then self.v.guid = nil end
    if UnitGUID(unitId) and UnitGUID(unitId) ~= self.v.guid then
        
        --reset
        self.v.guid = UnitGUID(unitId)
        self.v.spawnId = 0
        self.str = {
            debug = '',
            icon = '',
            note = {
                [1] = '',
                [2] = '',
                [3] = '',
            },
            target = '',
            name = '',
            info = '',
        }
        
        if UnitIsPlayer(unitId) then
            self.str.name = UnitPVPName(unitId) or GetUnitName(unitId) or ''
            self.str.info = GetGuildInfo(unitId) or ''
            if C_FriendList.IsFriend(self.v.guid) then
                self.str.icon = string.format('%s%s', envTable.c.p, '♥')
                self.str.name = string.format('%s%s', envTable.c.p, self.str.name)
            elseif envTable.guilds[self.str.info] then
                self.str.icon = string.format('%s%s', envTable.guilds[self.str.info].sCol, envTable.guilds[self.str.info].sChar)
            end
        else
            self.str.name = GetUnitName(unitId) or ''
            
            -- unit id
            local unitType, _, _, _, _, uID, spawnUID = strsplit("-", self.v.guid)
            self.v.uid = tonumber(uID)
            
            -- unit spawn id
            if unitType == "Creature" or unitType == "Vehicle" then
                self.v.spawnId = tonumber(bit.rshift(bit.band(tonumber(string.sub(spawnUID, 1, 5), 16), 0xffff8), 3))
            end
            
            -- notes
            if _G.CtrlDB then
                if _G.CtrlDB[self.v.uid] then
                    local col = envTable.c.w
                    if _G.CtrlDB[self.v.uid].color then col = _G.CtrlDB[self.v.uid].color end
                    if _G.CtrlDB[self.v.uid].t1 then self.str.note[1] = string.format('%s%s', col, _G.CtrlDB[self.v.uid].t1) end
                    if _G.CtrlDB[self.v.uid].t2 then self.str.note[2] = string.format('%s%s', col, _G.CtrlDB[self.v.uid].t2) end
                    if _G.CtrlDB[self.v.uid].t3 then self.str.note[3] = string.format('%s%s', col, _G.CtrlDB[self.v.uid].t3) end
                    if _G.CtrlDB[self.v.uid].symbol then self.str.icon = string.format('%s%s', col, _G.CtrlDB[self.v.uid].symbol) end
                end
            end
            
            -- debug
            if self.v.debug then self.str.debug = string.format('%s%d', envTable.c.r, self.v.uid) end
            
            -- name with spawnId
            if self.v.spawnId and tonumber(self.v.spawnId) and tonumber(self.v.spawnId) > 0 then
                unitFrame.healthBar.unitName:SetText(string.format('%s %d', self.str.name, self.v.spawnId))
            end
            
        end
        
        if unitFrame.label.icon then unitFrame.label.icon:SetText(self.str.icon) end
        if unitFrame.label.note and unitFrame.label.note[1] then unitFrame.label.note[1]:SetText(self.str.note[1]) end
        if unitFrame.label.note and unitFrame.label.note[2] then unitFrame.label.note[2]:SetText(self.str.note[2]) end
        if unitFrame.label.note and unitFrame.label.note[3] then unitFrame.label.note[3]:SetText(self.str.note[3]) end
        if unitFrame.label.debug then unitFrame.label.debug:SetText(self.str.debug) end
        
    end
    
    -- target
    local targetUnit = string.format('%s%s', unitId, 'target')
    if UnitExists(targetUnit) and not UnitIsDead(targetUnit) then
        self.str.target = GetUnitName(targetUnit) or ''
    end
    
    -- unit threat
    if not UnitIsPlayer(unitId) then
        local _, threatStatus, threatPct, _, _ = UnitDetailedThreatSituation('player', unitId)
        if threatStatus then
            self.str.info = string.format('%s %d', envTable.threatStr[threatStatus], math.floor(threatPct))
        end
    end
    
    if unitFrame.label.target then unitFrame.label.target:SetText(self.str.target) end
    if unitFrame.label.info then unitFrame.label.info:SetText(self.str.info) end
    
end



