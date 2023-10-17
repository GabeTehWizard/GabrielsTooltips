-- Utility Methods for Stat Calculations
local addonName, addonData = ...
local frame = CreateFrame("Frame")
local function BlueFont(text)
    return addonData.colors.formatter(text, addonData.colors.colorCodes.teal)
end

local function TealFont(text)
    return addonData.colors.formatter(text, addonData.colors.colorCodes.teal)
end

function OnActiveTalentGroupChanged(self, event, arg1, arg2)
    local primaryTalentGroup, secondaryTalentGroup = GetActiveTalentGroup(false, false)

    if primaryTalentGroup == 1 then
        print("Primary Talent Group is active.")
    elseif primaryTalentGroup == 2 then
        print("Secondary Talent Group is active.")
    end
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
    print("tooltip")
    local numLines = GameTooltip:NumLines()
    -- Iterate through each line in the tooltip
    for i = 2, numLines do -- Start from the second line (the first line is the item's name)
        local line = _G["GameTooltipTextLeft" .. i] -- Get the line object
        if line then
            local text = line:GetText()
            if text then
                -- Use string patterns to extract the stat name and value
                local stat, value = addonData.Utilities.ParseStatLine(text, addonData.Stats)
                if stat ~= "" and value ~= nil then
                    -- Replace the line with your modified text
                    line:SetText(text .. " |cFFFFD700" .. FormatStatPercent(stat, value) .. "|r")
                end
            end
        end
    end
end

local function UpdateSpellTooltip(self)
    local spellID = tostring(select(2, self:GetSpell()))

    if addonData.Spells[spellID] then
        local numLines = GameTooltip:NumLines()
        for i = 3, numLines do
            local line = _G["GameTooltipTextLeft" .. i]
            local text = line:GetText()
            if string.find(text, "cast") or string.find(text, "Channeled") then
                local nextLine = _G["GameTooltipTextLeft" .. (i + 1)] -- Get the next line
                if nextLine then
                    nextLine:SetText(addonData.Spells["48120"].spellDescription) -- I must add tooltips here
                    break
                end
            end
        end
    end
end

local function GetMajorGlyphs()
    for slotIndex = 1, 6 do
        local glyphInfo = GetGlyphSocketInfo(slotIndex)
        if glyphInfo then
            local glyphID, glyphType, _, glyphSpellID = GetGlyphSocketInfo(slotIndex, 2)
            print("Printing ID")
            print("Glyph Type: ".. glyphType)
            print(glyphSpellID)

            print("Success")
        end
    end
end

local function TalentUpdateEvent()
    -- GetMajorGlyphs()
end

-- Define a function to handle the "PLAYER_ENTERING_WORLD" event
local function OnPlayerEnteringWorld(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        -- This event occurs when the character is fully loaded into the game world.
        print(TealFont("Gabriel's Tooltips: ") .. "Character Loaded Successfully...")
        OnActiveTalentGroupChanged()
        print(addonData.Utilities.QueryTalentRank(2,3,false))
        print(TealFont("Gabriel's Tooltips: ") .. "Updating Character Variables...")
        print(TealFont("Gabriel's Tooltips: ") ..  "Updating Talent Variables...")
        print(TealFont("Gabriel's Tooltips: ") ..  "Updating Glyph Variables...")
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
        OnActiveTalentGroupChanged()
    end
end

-- Register the event and set up the frame in this function
local function RegisterEventHandlers()
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    frame:SetScript("OnEvent", OnPlayerEnteringWorld)
end

-- Call the function at the top of your main Lua file to set up event handling
addonData.RegisterEventHandlers = RegisterEventHandlers
addonData.Events = {
    UpdateTooltip = UpdateTooltip,
    UpdateSpellTooltip = UpdateSpellTooltip
}