--[[ ctrl - libs.lua - t@wse.nyc - 6/14/25 ]] --

---@class ctrl
local ctrl = select(2, ...)

local c, s = ctrl.c, ctrl.s

local rc = LibStub("LibRangeCheck-3.0")
--rc.RegisterCallback(self, rc.CHECKERS_CHANGED, function() print("need to refresh my stored checkers") end)

ctrl.unitRange = function(unit)
    local minRange, maxRange = rc:GetRange(unit)
    if not minRange then
        return 0
    elseif not maxRange then
        return minRange
    else
        return maxRange
    end
end