local addonName, addonTable = ...

-- Table of Stats and Their Related Values
addonTable.Stats = {
    stamina = {
        -- Hit Points Per Point of Stamina
        valuePP = 10
    },
    intellect = {
        -- Mana Value Per Point of Intellect
        valuePP = 20,
        -- Critical Percent Per Point of Intellect
        valuePP2 = 0.006,
    },
    spirit = {
        -- Spell Power Per Point of Spirit
        valuePP = .25,
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