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

local function PrintItemTooltipSummary(itemStatTable, aGameTooltip)
    if itemStatTable["stamina"] then
        aGameTooltip:AddLine("Health" .. ": " .. itemStatTable["stamina"])
    end
    if itemStatTable["intellect"] then
        aGameTooltip:AddLine("Mana" .. ": " .. itemStatTable["mana"])
    end
    if itemStatTable["hit"] then
        aGameTooltip:AddLine("Hit" .. ": " .. itemStatTable["hit"] .. "%")
    end
    if itemStatTable["haste"] then
        aGameTooltip:AddLine("Haste" .. ": " .. itemStatTable["haste"] .. "%")
    end
    if itemStatTable["critical"] then
        aGameTooltip:AddLine("Critical Chance" .. ": " .. itemStatTable["critChance"] .. "%")
    end
    if itemStatTable["spirit"] then
        aGameTooltip:AddLine("Relative MP5" .. ": " .. "Coming soon#tm")
    end
    if itemStatTable["spellpower"] then
        aGameTooltip:AddLine("Total Spell Power" .. ": " .. itemStatTable["spellpower"])
    end
end

local function UpdateTooltip()
    local keywords = {
        critical = true,
        haste = true,
        intellect = true,
        spirit = true,
        stamina = true,
        hit = true,
        spellpower = true, -- Include the specific keyword
        armor = true,
        mana = true,
        defense = true,
        hastepercent = true,
    }

    local data = {} -- Initialize the data table

    local numLines = GameTooltip:NumLines()
    local tooltipText = ""

    for i = 2, numLines do -- Start from the second line (the first line is the item's name)
        local line = _G["GameTooltipTextLeft" .. i] -- Get the line object
        if line then
            local text = line:GetText()
            if text then
                text = text:gsub("%.", "")
                tooltipText = tooltipText .. text .. " " -- Append the line's text to the tooltipText
            end
        end
    end

    tooltipText = tooltipText:lower()
	tooltipText = string.gsub( tooltipText, "|c%x%x%x%x%x%x%x%x", "" )
	tooltipText = string.gsub( tooltipText, "|c%x%x %x%x%x%x%x", "" ) -- the trading parts colour has a space instead of a zero for some weird reason
	tooltipText = string.gsub( tooltipText, "|r", "" )
    tooltipText = string.gsub( tooltipText, "spell power", "spellpower")
    tooltipText = string.gsub( tooltipText, "%d+ / %d+", "")
    tooltipText = string.gsub( tooltipText, "haste rating by 340 for 12", "10 hastepercent")
    tooltipText = string.gsub( tooltipText, "1 min cooldown", "")
    tooltipText = string.gsub( tooltipText, "chance to restore mana", "")
    tooltipText = string.gsub( tooltipText, "requires at least %d red gem", "")
    tooltipText = string.gsub( tooltipText, "requires at least %d yellow gem", "")
    tooltipText = string.gsub( tooltipText, "requires at least %d blue gem", "")
    tooltipText = string.gsub( tooltipText, "2%% mana", "")
    tooltipText = string.gsub( tooltipText, "3%% increased critical damage", "")
    tooltipText = string.gsub( tooltipText, "1%% spell reflect", "")
    tooltipText = string.gsub( tooltipText, "2%% intellect", "")
    tooltipText = string.gsub( tooltipText, "%d*%%", "")
    tooltipText = string.gsub( tooltipText, "per 5 seconds", "")
    tooltipText = string.gsub( tooltipText, "requires level %d+", "")
    tooltipText = string.gsub( tooltipText, "[^%w%s]", "")

    local num = nil
    local key = ""
    for word in string.gmatch(tooltipText, "%S+") do

        if keywords[word] then
            key = word
        elseif tonumber(word) then
            num = tonumber(word)
        end

        if (num ~= nil and key ~= "") then
            data[key] = data[key] and (data[key] + num) or num
            key = ""
            num = nil
        end
    end
    addonData.Utilities.AdjustItemStats(data)
    PrintItemTooltipSummary(data, GameTooltip)
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