-- Title: GabrielsTooltips Addon for Wrath Classic
-- Interface: 30402
-- Version: 1.0
local addonName, addon = ...

-- Get the localized name of the player's class
local _, class = UnitClass("player")

-- Define a set of lowercase stat names
local combatStats = {
    stamina = true,
    intellect = true,
    spirit = true,
    haste = true,
    ["critical strike"] = true, -- Use square brackets for keys with spaces
    hit = true
}

local statValues = {
    stamina = 10,
    intellect = 20,
    intellectCrit = 166.6667,
    spirit = .25,
    haste = 32.79,
    ["critical strike"] = 45.91,
    hit = 32.78
}

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

local function CalcStatPercent(aStatName, aStatValue)
    return math.floor(aStatValue / statValues[aStatName] * 100 + 0.5) / 100 
end

local function FormatStatPercent(aStatName, aStatValue)
    if aStatName ~= "intellect" and aStatName ~= "stamina" then
        return "+" .. CalcStatPercent(aStatName, aStatValue) .. "%"
    elseif aStatName == "intellect" then
        return "(+" .. CalcStatPercent("intellectCrit", aStatValue) .. " Mana) (+" .. CalcStatPercent(aStatName, aStatValue) .. "%)"
    else 
        return "(+" .. CalcStatPercent(aStatName, aStatValue) .. " Hit Points)"
    end
end

local function UpdateTooltip()
    local numLines = GameTooltip:NumLines()
    addon.Test1()
    -- Iterate through each line in the tooltip
    for i = 2, numLines do -- Start from the second line (the first line is the item's name)
        local line = _G["GameTooltipTextLeft" .. i] -- Get the line object

        if line then
            local text = line:GetText()
            if text then
                -- Use string patterns to extract the stat name and value
                local stat, value = ParseStatLine(text, combatStats)
                if stat ~= "" and value ~= nil then
                    -- Replace the line with your modified text
                    line:SetText(text .. " |cFFFFD700" .. FormatStatPercent(stat, value) .. "|r")
                end
            end
        end
    end
end

if class == "PRIEST" then
   -- Hook into GameTooltip's "OnTooltipSetItem" event
    GameTooltip:HookScript("OnTooltipSetItem", UpdateTooltip) 
else
    -- The player's class is not a Priest, so we disable the addon.
    print("Your character is not a Priest. This addon is for Priests only.")
    return
end