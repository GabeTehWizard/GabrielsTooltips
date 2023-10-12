-- Utility Methods for Stat Calculations
local addonName, addon = ...

local function CalcStatBase(num1, num2)
    return math.floor(num1 * num2 * 100 + 0.5) / 100
end

local function CalcStat(aStat, aStatValue)
    if not aStat.valuePP2 then
        return CalcStatBase(aStatValue, aStat.valuePP)
    elseif aStat.valuePP2 then
        return CalcStatBase(aStatValue, aStat.valuePP), CalcStatBase(aStatValue, aStat.valuePP2)
    end
    return 0, 0 -- Return default values or handle this case as needed
end

addon.CalcStat = CalcStat
