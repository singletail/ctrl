--[[ ctrl - sfx.lua - t@wse.nyc - 8/5/24 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'sfx',
    color = c.v,
    symbol = s.sfx,
    options = {
        debug = true
    }
}

ctrl.sfx = ctrl.mod:new(mod)
ctrl.sfx.handle = nil

local sf = {
    ['TANK'] = 'tank-train',
    ['HEALER'] = 'tindeck',
    ['DAMAGER'] = 'pacman_death',
    ['NONE'] = 'pacman_death',
    ['RESURRECT'] = 'sonicring',
    ['TAUNT'] = 'orch_hit',
}

local function sfxPath(input)
    if tonumber(input) then return input end
    local pathStr = ctrl.p.sfx
    if sf[input] then
        pathStr = pathStr .. sf[input]
    else
        pathStr = pathStr .. input
    end
    if string.sub(pathStr, -4) ~= '.mp3' or string.sub(pathStr, -4) ~= '.ogg' then
        pathStr = pathStr .. '.mp3'
    end
    return pathStr
end



local function playfile(soundFile, chnl)
    local willPlay
    ctrl.sfx:stop()
    willPlay, ctrl.sfx.handle = PlaySoundFile(soundFile, chnl)
    if not willPlay then
        ctrl.sfx.error(ctrl.sfx, 'Error playing soundFile ' .. soundFile)
    end
end

function ctrl.sfx:play(snd, chnl)
    local soundFile = sfxPath(snd)
    chnl = chnl or 'SFX'
    playfile(soundFile, chnl)
end

function ctrl.sfx:stop()
    if ctrl.sfx.handle then StopSound(ctrl.sfx.handle, 0) end
end

function ctrl.sfx:error(msg)
    if self.options.debug then
        ctrl.alert:add(msg)
    end
    self:warn(msg)
end
