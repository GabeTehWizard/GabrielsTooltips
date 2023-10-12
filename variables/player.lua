local addonName, addonTable = ...

-- Get the Player Class
local name, class = UnitClass("player")

-- Define Player Table
addonTable.Player = {
    name = name,
    class = class,
}