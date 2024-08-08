--[[ ctrl - pet.lua - t@wse.nyc - 8/6/24 ]]

local _, ctrl = ...
local c, s, a = ctrl.c, ctrl.s, ctrl.a

local mod = {
    name = 'pet',
    color = c.o,
    symbol = s.pet,
    options = {
        events = {
            'PLAYER_ENTERING_WORLD',
            'ZONE_CHANGED',
            'ZONE_CHANGED_INDOORS',
            'NEW_PET_ADDED',
            'COMPANION_UPDATE',
            'PLAYER_REGEN_ENABLED',
            'PLAYER_MOUNT_DISPLAY_CHANGED',
        }
    }
}

ctrl.pet = ctrl.mod:new(mod)

local newPetGuid = nil

local function summonPet()
    if InCombatLockdown() or IsMounted() then return end
    if C_PetJournal.GetSummonedPetGUID() then return end

    if newPetGuid then
        C_PetJournal.SummonPetByGUID(newPetGuid)
    else
        C_PetJournal.SummonRandomPet(true)
    end
end

function ctrl.pet.NEW_PET_ADDED(et)
    local guid = et[1]
    local isSummonable, _, _ = C_PetJournal.GetPetSummonInfo(guid)
    ctrl.pet:debug('NEW_PET_ADDED ' .. tostring(guid) .. ' isSummonable: ' .. tostring(isSummonable))
    if isSummonable then newPetGuid = guid end
end

function ctrl.pet.COMPANION_UPDATE()
    summonPet()
end

function ctrl.pet.PLAYER_ENTERING_WORLD(evt)
    summonPet()
end

function ctrl.pet.ZONE_CHANGED(evt)
    summonPet()
end

function ctrl.pet.ZONE_CHANGED_INDOORS(evt)
    summonPet()
end

function ctrl.pet.PLAYER_REGEN_ENABLED(evt)
    summonPet()
end

function ctrl.pet.PLAYER_MOUNT_DISPLAY_CHANGED(evt)
    summonPet()
end

ctrl.pet:init()
