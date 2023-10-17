-- Title: GabrielsTooltips Addon for Wrath Classic
-- Interface: 30402
-- Version: 1.0
-- Main Script File
local addonName, addonData = ...
local player = addonData.Player

if player.class == "PRIEST" then
   -- Hook into GameTooltip's "OnTooltipSetItem" event
    addonData.RegisterEventHandlers()
    GameTooltip:HookScript("OnTooltipSetItem", addonData.Events.UpdateTooltip)
    GameTooltip:HookScript("OnTooltipSetSpell", addonData.Events.UpdateSpellTooltip)
else
    print("Your character is not a Priest. This addon is for Priests only.")
    return
end