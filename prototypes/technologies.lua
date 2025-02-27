local utils = require("prototypes.utils")

-- Check mod setting: Replace capture bot rocket?
if utils.settings.get_replace_rocket() then
    -- *Replace* the capture bot rocket recipe with the capsule recipe in the Captivity technology
    utils.technologies.replace_recipe("captivity", "capture-robot-rocket", "capture-robot-capsule")

    -- Remove the Rocketry prerequisite from the Captivity technology
    utils.technologies.remove_prerequisite("captivity", "rocketry")
else
    -- Add capture bot capsule recipe to Captivity technology, additional to the rocket recipe
    utils.technologies.add_recipe("captivity", "capture-robot-capsule", 1)
end
