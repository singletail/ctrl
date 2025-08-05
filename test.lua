-- 13 Eye beam 198013
-- 10 The Hunt 370965 macro (??)
-- 5  Chaos Strike 162794
-- 23 Throw Glaive 185123

-- 21 Disrupt 183752

-- Single-Button Assistant - macro 1229376
-- extra action button macro --- slot 16 macro 7 "Suicide"(???)

local function rc()
    local x = IsActionInRange(23, 'target')
    print(x)
end

rc()


local function ss()
    for i=1,100 do
        local t,id,s = GetActionInfo(i)
        if t == 'spell' then
            local spellInfo = C_Spell.GetSpellInfo(id)
            if spellInfo then print(i, t, id, s, spellInfo.name) end
        end
    end
end
ss()


local function rc2()
   local x = {GetFramesRegisteredForEvent("PLAYER_ENTERING_WORLD")}))
   --end
   --DevTools_Dump(x[1])
   DisplayTableInspectorWindow(x[2])
end

rc2()

local function r()
   local x = GetCurrentEnvironment()
   --end
   --DevTools_Dump(x[1])
   DisplayTableInspectorWindow(x)
end

r()