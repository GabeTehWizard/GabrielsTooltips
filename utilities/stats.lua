-- Utility Methods for Stat Calculations
local addonName, addon = ...

local function QueryTalentRank(tabIndex, talentIndex, inspect)
    local talentName, talentIcon, talentTier, talentColumn, talentSelected, talentAvailable = GetTalentInfo(tabIndex, talentIndex, inspect);
    return talentTier
end

local function QueryLineValue(line)
    return tonumber(string.match(line, "%d+"))
end

local function ParseStatLine(line, combatStats)
    for stat, _ in pairs(combatStats) do
        if string.find(string.lower(line), stat) then
            return stat, QueryLineValue(line)
        end
    end
    return "", 0
end

local function CalcStatBase(num1, num2)
    return math.floor(num1 * num2 * 100 + 0.5) / 100
end

local function CalcStat(aStat, aStatValue)
    if not aStat.valuePP2 then
        return CalcStatBase(aStatValue, aStat.valuePP)
    elseif aStat.valuePP2 then
        return CalcStatBase(aStatValue, aStat.valuePP), CalcStatBase(aStatValue, aStat.valuePP2)
    end
    return 0, 0
end

addon.CalcStat = CalcStat
addon.Utilities = {
    QueryLineValue = QueryLineValue,
    ParseStatLine = ParseStatLine,
    QueryTalentRank = QueryTalentRank,
}