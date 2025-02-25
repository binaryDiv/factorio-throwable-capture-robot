-- Unlock recipe for capture robot capsule with Captivity technology (same as the rocket)
table.insert(
    data.raw["technology"]["captivity"].effects,
    -- Add effect to the start of the list
    1,
    {
        type = "unlock-recipe",
        recipe = "capture-robot-capsule",
    }
)
