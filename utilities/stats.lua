-- Utility Methods for Stat Calculations
local addonName, addon = ...
local statTable = addon.Stats


local function QueryTalentRank(tabIndex, talentIndex, inspect)
    local talentName, talentIcon, talentTier, talentColumn, talentSelected, talentAvailable = GetTalentInfo(tabIndex, talentIndex, inspect);
    return talentTier
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

local function AdjustItemStats(itemStatTable)
    if itemStatTable["spirit"] then
        itemStatTable["spellpower"] = itemStatTable["spellpower"] and (itemStatTable["spellpower"] + CalcStat(statTable["spirit"], itemStatTable["spirit"])) or CalcStat(statTable["spirit"], itemStatTable["spirit"])
    end
    if itemStatTable["intellect"] then
        local mana, crit = CalcStat(statTable["intellect"], itemStatTable["intellect"])
        itemStatTable["intellect"] = mana
        itemStatTable["critChance"] = crit
    end
    if itemStatTable["hit"] then
        itemStatTable["hit"] = CalcStat(statTable["hit"], itemStatTable["hit"])
    end
    if itemStatTable["haste"] then
        itemStatTable["haste"] = CalcStat(statTable["haste"], itemStatTable["haste"])
    end
    if itemStatTable["critical"] then
        itemStatTable["critChance"] = itemStatTable["critChance"] and (itemStatTable["critChance"] + CalcStat(statTable["critical strike"], itemStatTable["critical"])) or CalcStat(statTable["critical strike"], itemStatTable["critical"])
    end
    if itemStatTable["stamina"] then
        itemStatTable["stamina"] = CalcStat(statTable["stamina"], itemStatTable["stamina"])
    end
    if itemStatTable["mana"] then
        itemStatTable["mana"] = itemStatTable["mana"]
    end
end

addon.CalcStat = CalcStat
addon.Utilities = {
    QueryTalentRank = QueryTalentRank,
    AdjustItemStats = AdjustItemStats,
}