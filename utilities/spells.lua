local addonName, addonTable = ...

local m = addonTable.cMath

local calc_heal_coefficient = function(cast_time)
    return m.Round(cast_time / 3.5 * 1.88, 4)
end

addonTable.SpellUtilities = {
    calc_heal_coefficient = calc_heal_coefficient
}