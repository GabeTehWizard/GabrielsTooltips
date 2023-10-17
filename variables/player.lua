local addonName, addonTable = ...

-- Get the Player Data
local name, class = UnitClass("player")

-- Define Player Table
addonTable.Player = {
    -- Player Character Name
    name = name,
    -- Localized Player Class
    class = class,
    baseMana = 3863,
}

addonTable.Talents = {
    improvedRenew = "",
    divineFury = "",
    improvedHealing = "",
    healingPrayers = "",
    spiritOfRedemption = "",
    spiritualGuidance = "",
    spiritualHealing = "",
    holyConcentration = "",
    blessedResilience = "",
    empoweredHealing = "",
    empoweredRenew = "",
    divineProvidence = "",
    twinDisciplines = "",
    meditation = "",
    improvedPowerWordShield = "",
    mentalAgility = "",
    mentalStrength = "",
    soulWarding = "",
    focusedPower = "",
    enlightenment = "",
    improvedFlashHeal = "",
    divineAegis = "",
    borrowedTime = "",
}