--[[ ctrl - loot.lua - t@wse.nyc - 16 July 2025

# Loot module for ctrl addon

- Display a table of raid members:
    - Columns:
        - name
        - overall ilvl
        - number of need rolls made / won
        - number of greed rolls made / won
        - number of transmog rolls made / won
        - number of need rolls made/won with item <= ilvl for that slot *
    - Modes:
        - per day
        - per week
        - per tier
    - Sortable by any column

- Display large warnings with sound alert for:
    - Anyone trading a loot item to another player
    - Anyone winning an item for the wrong spec **
    - Anyone rolling need on an item that is not an upgrade for them *
    - Anyone winning a roll for an item that is not an upgrade for them *

- Display a scrolling window with events:
    - Loot win: Name, itemLink, slot, ilvl, former ilvl, need/greed, boss
    - Loot trade: Name1, name2, itemLink, ilvl, boss

- Saving data:
    - Save all of the above to a prefs file, with backup
    - Export current data for copy/paste in JSON or CSV format

- Challenges:
    * Tracking user ilvls requires an inspect function, which requires a queue.
    ** Tracking raid loot spec is not possible. Need to search the journal for eligibility via EJ_SetLootFilter(classID, specID)

- Possible additions, if necessary:
    - Log every boss kill with names of all members (for attendance tracking)
    - Log every roll
    - Convert into stand-alone addon
        - Synchronize data with other players
            - This would be a sneaky way to track loot specs

- To research:
    - PTR 11.2 has a new function: HasLootSpecializations() -- what does it do?
]]

---@class ctrl

local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'loot',
    color = c.g,
    symbol = s.target,
    options = {
        timers = {
            1/15
        },
        events = {
            'CHAT_MSG_LOOT',
            'ENCOUNTER_LOOT_RECEIVED',
            'ITEM_PUSH',
            'LOOT_CLOSED',
            'LOOT_ITEM_AVAILABLE',
            'LOOT_ITEM_ROLL_WON',
            'LOOT_OPENED',
            'LOOT_READY',
            'LOOT_ROLLS_COMPLETE',
            'MAIN_SPEC_NEED_ROLL',
            'PLAYER_LOOT_SPEC_UPDATED',
            'START_LOOT_ROLL',
        },
        frame = {
            name = 'ctrlloot',
            w=300,
            h=100,
            x=0,
            y=-140,
            a=a.t,
            pa=a.t,
            isResizable = 1,
            isMovable = 1,
            isClipsChildren = nil,
        },
        fontFile = 'AnkaCoder-Bold',
        fontSize = 11,
    }
}

ctrl.loot = ctrl.mod:new(mod)

local subframes = {
    ['sf'] = { class = 'ScrollingMessageFrame', target = 'main', anchors = { { a = a.tl, pa = a.tl, x = 16, y = -8 }, { a = a.br, pa = a.br, x = -8, y = 16 } } },
    --['bk'] = { anchors = { { a = a.tl, pa = a.tl, x = 12, y = -36 }, { a = a.br, pa = a.br, x = -12, y = 8, isClipsChildren = 1, } } },
    --['fcompass'] = { target = 'main', w = 1024, h = 64, a=a.c, pa=a.c, x=0, y=0 },
}

local textures = {
    ['tx'] = { t = 'dark1', target='main', path = ctrl.p.tx, l = -7 },
    ['bktx'] = { target='main', t = 'bluebk_inset_256', path = ctrl.p.tx, l = -6 },
}

local fontstrings = {
    ['fssym'] = { t=c.c.."㌗", a=a.tl, pa=a.tl, x=10, y=-10, target='main', fontFile='ProFontWindows-Regular.ttf', fontSize=36,},
}

local function ConfigureScrollFrame(self, f)
    local font = ctrl.loot.options.fontFile
    local fontSize = ctrl.loot.options.fontSize
    local fontObject = ctrl.font(font, fontSize, '')
    f:SetFontObject(fontObject)
    --f:SetFont(ctrl.p.fnt .. font, fontSize, "")
    f:SetSpacing(3)
    f:SetFading(false)
    f:SetMaxLines(2000)
    f:SetJustifyH('LEFT')
    f:EnableMouse(false)
    f:EnableMouseWheel(true)
    f:SetInsertMode("BOTTOM")
    f:SetScript('OnMouseWheel', function(s, delta)
        s:ScrollByAmount(delta * 3)
    end)
end

function ctrl.loot:add(msg, sf)
    if not sf then
        sf = self.f.sf
    end
    if not sf then
        return
    end
    if type(msg) == 'table' then
        msg = table.concat(msg, '\n')
    end
    sf:AddMessage(msg)
end

function ctrl.loot:getLootInfo()
    local info = GetLootInfo()
    if not info then
        self:add(c.r .. 'No loot info available')
        return
    end
    local msg = c.g .. 'getLootInfo(): ' .. ctrl.toStr(info)
    self:add(msg)
end

function ctrl.loot.CHAT_MSG_LOOT(evt)
    --text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
    local debugStr = ctrl.toStr(evt)
    ctrl.loot:add(c.r .. '[CHAT_MSG_LOOT] ' .. c.a .. debugStr .. c.d)
end

function ctrl.loot.ENCOUNTER_LOOT_RECEIVED(evt)
    --encounterID, itemID, itemLink, quantity, playerName, classFileName
    ctrl.loot:add(c.r .. 'ENCOUNTER_LOOT_RECEIVED ' .. 'encounterID: ' .. tostring(evt[1]) .. ', itemID: ' .. tostring(evt[2]) .. ', itemLink: ' .. evt[3] .. ', quantity: ' .. tostring(evt[4]) .. ', playerName: ' .. evt[5] .. ', classFileName: ' .. evt[6])
    ctrl.loot:debug('ENCOUNTER_LOOT_RECEIVED')
end

function ctrl.loot.ITEM_PUSH(evt)
    --bagSlot, iconFileID
    ctrl.loot:add(c.r .. 'ITEM_PUSH ' .. 'bagSlot: ' .. tostring(evt[1]) .. ', iconFileID: ' .. tostring(evt[2]))
    ctrl.loot:debug('ITEM_PUSH')
end

function ctrl.loot.LOOT_CLOSED()
    ctrl.loot:add(c.r .. 'LOOT_CLOSED')
    ctrl.loot:debug('LOOT_CLOSED')
end

function ctrl.loot.LOOT_ITEM_AVAILABLE(evt)
    --itemTooltip, lootHandle
    ctrl.loot:add(c.r .. 'LOOT_ITEM_AVAILABLE ' .. 'itemTooltip: ' .. tostring(evt[1]) .. ', lootHandle: ' .. tostring(evt[2]))
    ctrl.loot:debug('LOOT_ITEM_AVAILABLE')
end

function ctrl.loot.LOOT_ITEM_ROLL_WON(evt)
    --itemLink, rollQuantity, rollType, roll, upgraded
    ctrl.loot:add(c.r .. 'LOOT_ITEM_ROLL_WON ' .. 'itemLink: ' .. evt[1] .. ', rollQuantity: ' .. evt[2] .. ', rollType: ' .. evt[3] .. ', roll: ' .. evt[4] .. ', upgraded: ' .. tostring(evt[5]))
    ctrl.loot:debug('LOOT_ITEM_ROLL_WON')
end

function ctrl.loot.LOOT_OPENED(evt)
    --autoLoot, isFromItem
    ctrl.loot:add(c.r .. 'LOOT_OPENED ' .. 'autoLoot: ' .. tostring(evt[1]) .. ', isFromItem: ' .. tostring(evt[2]))
    ctrl.loot:debug('LOOT_OPENED')
end

function ctrl.loot.LOOT_READY()
    -- follow up with GetLootInfo()
    ctrl.loot:add(c.r .. 'LOOT_READY')
    ctrl.loot:debug('LOOT_READY')
    ctrl.loot:getLootInfo()
end

function ctrl.loot.LOOT_ROLLS_COMPLETE(evt)
    --lootHandle
    ctrl.loot:add(c.r .. 'LOOT_ROLLS_COMPLETE ' .. 'lootHandle: ' .. tostring(evt[1]))
    ctrl.loot:debug('LOOT_ROLLS_COMPLETE')
end

function ctrl.loot.MAIN_SPEC_NEED_ROLL(evt)
    --rollID, roll, isWinning
    ctrl.loot:add(c.r .. 'MAIN_SPEC_NEED_ROLL ' .. 'rollID: ' .. evt[1] .. ', roll: ' .. evt[2] .. ', isWinning: ' .. tostring(evt[3]))
    ctrl.loot:debug('MAIN_SPEC_NEED_ROLL')
end

function ctrl.loot.PLAYER_LOOT_SPEC_UPDATED()
    ctrl.loot:add(c.g .. 'PLAYER_LOOT_SPEC_UPDATED')
    ctrl.loot:debug('PLAYER_LOOT_SPEC_UPDATED')
end

function ctrl.loot.START_LOOT_ROLL(evt)
    -- rollID, rollTime, lootHandle
    ctrl.loot:add(c.r .. 'START_LOOT_ROLL ' .. 'rollID: ' .. evt[1] .. ', rollTime: ' .. evt[2] .. ', lootHandle: ' .. tostring(evt[3]))
    ctrl.loot:debug('START_LOOT_ROLL')
end

function ctrl.loot:update()
    --
end

function ctrl.loot:tick(interval)
    ctrl.loot:update()
end

function ctrl.loot.setup(self)
    self.f.main = ctrl.frame.new(self, self.options.frame)
    ctrl.frame.generate(self, subframes)
    ctrl.tx.generate(self, textures)
    ctrl.fs.generate(self, fontstrings)
    ConfigureScrollFrame(self, ctrl.loot.f.sf)
    ctrl.loot.f.sf:AddMessage(c.g .. 'Loot Frame Initialized')
end

ctrl.loot:init()
