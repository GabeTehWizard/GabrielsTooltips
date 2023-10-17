local addonName, addonTable = ...

local Round = function(number, y)
    local multiplier = 10 ^ y
    return math.floor(number * multiplier + 0.5) / multiplier
end

addonTable.cMath = {
    Round = Round,
}

