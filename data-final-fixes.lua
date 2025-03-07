local utils = require("prototypes.utils")

-- Check mod setting: Replace capture bot rocket?
if utils.settings.get_replace_rocket() then
    -- Replace rocket with capsule in other recipes that use it (Biolab, Captive biter spawner)
    utils.recipes.replace_ingredient_in_all_recipes("capture-robot-rocket", "capture-robot-capsule")

    -- Remove recipe for capture-robot-rocket, as well as its recycling recipe
    data.raw["recipe"]["capture-robot-rocket"] = nil
    data.raw["recipe"]["capture-robot-rocket-recycling"] = nil

    -- Remove capture bot rocket item
    data.raw["ammo"]["capture-robot-rocket"] = nil
end
