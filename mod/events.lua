--[[          ctrl - events.lua - t@wse.nyc - 8/5/24        ]]
--[[   Quality of life event reactions, not event handlers. ]]

local _, ctrl = ...
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'events',
    color = c.o,
    symbol = s.taunt,
    options = {
        events = {
            'DUEL_REQUESTED',
            'PLAYER_REGEN_DISABLED',
            'PLAYER_REGEN_ENABLED',
            'PLAYER_DEAD',
            'PLAYER_ALIVE',
            'PLAYER_GUILD_UPDATE',
            'SYSTEM_VISIBILITY_CHANGED',
            'UI_ERROR_MESSAGE',
            'UI_INFO_MESSAGE',
            'INITIAL_HOTFIXES_APPLIED',
            'SYSMSG',
            'GENERIC_ERROR',
            'LUA_WARNING',
            'ADDON_ACTION_BLOCKED',
            'ADDON_ACTION_FORBIDDEN',
            'MACRO_ACTION_BLOCKED',
            'MACRO_ACTION_FORBIDDEN',
            'ENCOUNTER_LOOT_RECEIVED',
            'PLAYER_CONTROL_LOST',
            'PLAYER_CONTROL_GAINED',
            'DISPLAY_SIZE_CHANGED',
            'UI_SCALE_CHANGED',
            'VOICE_CHAT_CONNECTION_SUCCESS',
            'ZONE_CHANGED',
            'ZONE_CHANGED_INDOORS',
            'GROUP_ROSTER_UPDATE',
            'PARTY_LEADER_CHANGED',
            'ROLE_CHANGED_INFORM',
            'READY_CHECK',
            'PARTY_MEMBER_DISABLE',
            'ACTIVE_PLAYER_SPECIALIZATION_CHANGED',
            'OBJECT_ENTERED_AOI',
            'OBJECT_LEFT_AOI',
            'PLAYER_IMPULSE_APPLIED',
            'UNIT_TARGETABLE_CHANGED',
        },
    }
}

ctrl.events = ctrl.mod:new(mod)

local function alert(...)
    local msg, sfx = ...
    if msg then
        ctrl.alert.add(ctrl.events, tostring(msg))
        ctrl.events.info(ctrl.events, tostring(msg))
    end
    if sfx then
        ctrl.sfx.play(ctrl.events, tostring(sfx))
    end
end

function ctrl.events.events_event(e, et)
    e = e or 'Unknown Event'
    local evtStr = ''

    if et then
        for i = 1, et.n do
            evtStr = evtStr .. et[i] .. ', '
        end
    end
    alert(c.b .. e .. ' ' .. c.v .. evtStr)
end

function ctrl.events.PLAYER_REGEN_DISABLED()
    alert(c.r .. 'PLAYER_REGEN_DISABLED()', 'beepbeep')
end

function ctrl.events.PLAYER_REGEN_ENABLED()
    alert(c.g .. 'PLAYER_REGEN_ENABLED()', 'untaunt')
end

function ctrl.events.PLAYER_DEAD()
    alert(c.r .. 'PLAYER_DEAD()', 'wrong')
end

function ctrl.events.PLAYER_ALIVE()
    alert(c.g .. 'PLAYER_ALIVE()', 'sonicring')
end

function ctrl.events.PLAYER_GUILD_UPDATE(et)
    local unitId = et[1] or 'unknown'
    local unitName = UnitName(unitId) or unitId
    alert(c.c .. 'PLAYER_GUILD_UPDATE: ' .. unitName, 'among-us-role-reveal-sound')
end

function ctrl.events.DUEL_REQUESTED(playerName)
    if C_FriendList.IsIgnored(playerName) then return end

    local nameplate = C_NamePlate.GetNamePlateForUnit(playerName)
    if not nameplate then return end
    local unitName = nameplate.namePlateUnitToken
    if not unitName then return end
    local guid = UnitGUID(unitName)
    if not guid or C_FriendList.IsFriend(guid) or IsPlayerInGuildFromGUID(guid) then return end

    local ignored = C_FriendList.AddIgnore(playerName)

    local msg = c.r .. playerName .. ' requested a duel'
    if ignored == true then
        msg = msg .. ' and is now being ignored.'
    else
        msg = msg .. ' but could not be ignored. Check ignore list.'
    end

    ctrl.events.info(ctrl.events, msg)
end

ctrl.events:init()
