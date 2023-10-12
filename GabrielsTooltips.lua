-- Title: GabrielsTooltips Addon for Wrath Classic
-- Interface: 30402
-- Version: 1.0
local addonName, addonData = ...

local player = addonData.Player

-- Define a set of lowercase stat names

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

local function FormatStatPercent(aStatName, aStatValue)
    if aStatName ~= "intellect" and aStatName ~= "stamina" then
        return "(+" .. addonData.CalcStat(addonData.Stats[aStatName], aStatValue) .. "%)"
    elseif aStatName == "intellect" then
        local mana, critical = addonData.CalcStat(addonData.Stats[aStatName], aStatValue)
        return "(+" .. mana .. " Mana) (+" .. critical .. "%)"
    else 
        return "(+" .. addonData.CalcStat(addonData.Stats[aStatName], aStatValue) .. " Hit Points)"
    end
end

local function UpdateTooltip()
    local numLines = GameTooltip:NumLines()
    -- Iterate through each line in the tooltip
    for i = 2, numLines do -- Start from the second line (the first line is the item's name)
        local line = _G["GameTooltipTextLeft" .. i] -- Get the line object
        if line then
            local text = line:GetText()
            if text then
                -- Use string patterns to extract the stat name and value
                local stat, value = ParseStatLine(text, addonData.Stats)
                if stat ~= "" and value ~= nil then
                    -- Replace the line with your modified text
                    line:SetText(text .. " |cFFFFD700" .. FormatStatPercent(stat, value) .. "|r")
                end
            end
        end
    end
end

if player.class == "PRIEST" then
   -- Hook into GameTooltip's "OnTooltipSetItem" event
    GameTooltip:HookScript("OnTooltipSetItem", UpdateTooltip) 
else
    -- The player's class is not a Priest, so we disable the addon.
    print("Your character is not a Priest. This addon is for Priests only.")
    return
end