local addonName, addonTable = ...

addonTable.colors = {
    colorCodes = {
    blue = "ff0000ff",
    green = "ff00ff00",
    orange = "ffffa500",
    purple = "ff800080",
    red = "ffff0000",
    teal = "ff008080",
    yellow = "ffffff00",
    },
    formatter = function(text, color)
        return "|c" .. color .. text .. "|r"
    end
}