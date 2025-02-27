local utils = require("prototypes.utils")

local sounds = require("__base__.prototypes.entity.sounds")
local item_sounds = require("__base__.prototypes.item_sounds")

-- Define capture robot capsule
local capture_robot_capsule = {
    type = "capsule",
    name = "capture-robot-capsule",
    order = "r[capture-robot-grenade]",
    subgroup = "capsule",
    icon = "__space-age__/graphics/icons/capture-bot.png",
    stack_size = 10,
    weight = 100 * kg,
    default_import_location = "gleba",

    capsule_action = {
        type = "throw",
        attack_parameters = {
            type = "projectile",
            activation_type = "throw",
            ammo_category = "capsule",
            range = 20,
            cooldown = 60,
            projectile_creation_distance = 0.6,

            ammo_type = {
                target_type = "entity",
                target_filter = { "biter-spawner", "spitter-spawner" },
                action = {
                    {
                        type = "direct",
                        action_delivery = {
                            type = "projectile",
                            projectile = "capture-robot-rocket",
                            starting_speed = 0.1,
                        },
                    },
                    {
                        type = "direct",
                        action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "play-sound",
                                    sound = sounds.throw_projectile,
                                },
                            },
                        },
                    },
                },
            },
        },
    },

    inventory_move_sound = item_sounds.robotic_inventory_move,
    pick_sound = item_sounds.robotic_inventory_pickup,
    drop_sound = item_sounds.robotic_inventory_move,
}

-- Add item prototype
data:extend { capture_robot_capsule }

-- Check mod setting: Replace capture bot rocket?
if utils.settings.get_replace_rocket() then
    -- Remove capture bot rocket item
    data.raw["ammo"]["capture-robot-rocket"] = nil
end
