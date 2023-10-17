local addonName, addonTable = ...

local SPELL_TYPE_HEAL = "Heal"
local SPELL_TYPE_DAMAGE = "Damage"
local BASE_MANA = addonTable.Player.baseMana
local spellDmg = GetSpellBonusDamage(2);
addonTable.SPELL_TYPE_HEAL = SPELL_TYPE_HEAL
addonTable.SPELL_TYPE_DAMAGE = SPELL_TYPE_DAMAGE
local m = addonTable.cMath

-- Table of Spells Using Their Spell ID as the Key
addonTable.Spells = {
    ["48120"] = {
        name = "Binding Heal",
        baseCastingTime = 1.5,
        coefficientFormula = function()
            return 5 * 50
        end,
        manaCost = .27,
        minValue = 1952,
        maxValue = 2508,
        spellType = SPELL_TYPE_HEAL,
        targets = 2,
        spellDescription = "Chonky"
    },
    ["48089"] = {
        name = "Circle of Healing",
        baseCastingTime = 0,
        coefficientFormula = "",
        manaCost = .21,
        minValue = 958,
        maxValue = 1058,
        spellType = SPELL_TYPE_HEAL,
        targets = 5,
        spellDescription = ""
    },
    ["48068"] = {
        name = "Renew",
        baseCastingTime = 0,
        coefficientFormula = "",
        minValue = 1400,
        maxValue = 1400,
        spellType = SPELL_TYPE_HEAL,
        targets = 1,
        spellDescription = ""
    },
    ["48066"] = {
        name = "Power Word: Shield",
        baseCastingTime = 0,
        minValue = 1400,
        maxValue = 1400,
        coefficientFormula = "",
        spellType = SPELL_TYPE_HEAL
    },
    spirit = {
        -- Spell Power Per Point of Spirit
        valuePP = 0,
    },
    haste = {
        -- Haste Percent Per Point of Haste Rating
        valuePP = 0.030497
    },
    ["critical strike"] = {
        -- Critical Strike Percent Per Point of Critical Strike Rating
        valuePP = 0.021782
    },
    hit = {
        -- Hit Chance Percent Per Point of Critical Strike Rating
        valuePP = 0.030506
    },
}
addonTable.Spells["48120"].spellDescription ="Heals a friendly target and the caster for " .. 1952 + m.Round(addonTable.SpellUtilities.calc_heal_coefficient(1.5) * spellDmg, 0) .." to " .. 2508 + m.Round(addonTable.SpellUtilities.calc_heal_coefficient(1.5) * spellDmg, 0) ..". Low threat."
--addonTable["48120"].spellDescription = "Heals a friendly target and the caster for 1952 to 2508. Low threat.";
--addonTable["48089"].spellDescription = "Heals up to " .. addonTable.Spells["48089"] .. "friendly party or raid members within 15 yards of the target for 958 to 1058."
