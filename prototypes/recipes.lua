-- Define recipe for capture robot capsule (same as for the original rocket)
local capture_robot_capsule_recipe = {
    type = "recipe",
    name = "capture-robot-capsule",
    energy_required = 10,
    ingredients = {
        { type = "item", name = "flying-robot-frame", amount = 1 },
        { type = "item", name = "steel-plate", amount = 2 },
        { type = "item", name = "processing-unit", amount = 2 },
        { type = "item", name = "bioflux", amount = 20 },
    },
    results = {
        { type = "item", name = "capture-robot-capsule", amount = 1 },
    },
    -- Recipe is enabled via research
    enabled = false,
}

-- Add prototype
data:extend { capture_robot_capsule_recipe }
