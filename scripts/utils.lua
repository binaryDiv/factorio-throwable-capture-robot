local utils = {}

-- Find capture robot projectiles that were spawned around the player
function utils.find_capture_robot_projectiles_near(player)
    local surface = player.surface

    return surface.find_entities_filtered {
        name = "capture-robot-rocket",
        position = player.position,
        -- The radius of the capsule is 20, but we only want to find the projectiles that were just spawned
        radius = 5,
    }
end

-- Register capture robot projectile for "on_object_destroyed" event and store information in mod storage
function utils.register_capture_robot_projectile(projectile, target_position)
    -- The "on_object_destroyed" event is only triggered for objects that have been explicitly registered.
    -- Registering the event returns a unique number that we can use to identify the projectile later and associate it
    -- with the information we need to store about it.
    local registration_number = script.register_on_object_destroyed(projectile)

    -- Ignore projectiles that have already been registered
    if storage.registered_capture_robots[registration_number] == nil then
        -- Store the projectile's target position (i.e. where the player clicked to throw the capsule) and surface
        storage.registered_capture_robots[registration_number] = {
            target_position = target_position,
            surface_index = projectile.surface.index,
        }
    end
end

-- Find biter spawner that is targeted by the capture robot projectile.
-- Returns nil if no spawner OR more than one spawner was found at the position.
function utils.find_spawner_at_position(surface, position)
    -- Search radius of a capture robot
    local capture_bot_search_radius = 0.28

    -- Find unit spawners within the capture robot search radius around the target position
    -- (Technically this also finds Gleba spawners, but this doesn't matter, because capture robots won't be created
    -- on top of Gleba spawners.)
    local spawners_at_position = surface.find_entities_filtered {
        type = "unit-spawner",
        area = {
            { position.x - capture_bot_search_radius, position.y - capture_bot_search_radius },
            { position.x + capture_bot_search_radius, position.y + capture_bot_search_radius },
        },
    }

    if #spawners_at_position == 0 then
        -- The capsule was thrown at a position without a spawner, so nothing should happen.
        return nil
    elseif #spawners_at_position > 1 then
        -- More than one spawner was found within the search radius near the position. Normally, this shouldn't happen
        -- because the search radius was chosen to be smaller than the margin of the biter's collision box.
        -- If this still does happen for some reason, we'll simply ignore the spawners. This only means that the capture
        -- robot's positions won't the fixed, which is only a cosmetic issue.
        return nil
    end

    return spawners_at_position[1]
end

-- Find all capture robot entities that are in the process of capturing a spawner (i.e. capture robots on top of a
-- spawner). This always returns a list, which may be empty.
function utils.find_capture_robots_on_spawner(spawner)
    -- We use the selection box here, which equals to the full tile size of the entity, to make sure we get the robot
    -- even if it's placed on the edge of the spawner. (A literal edge case...)
    return spawner.surface.find_entities_filtered {
        name = "capture-robot",
        area = spawner.selection_box,
    }
end

-- Destroy all capture robots in the list except the oldest one.
function utils.destroy_redundant_capture_robots(capture_robots)
    -- To find the oldest capture robot, we compare the unit numbers. These are always incrementing, so the oldest
    -- robot must have the smallest unit number.
    local oldest_unit_number = capture_robots[1].unit_number
    for _, capture_robot in pairs(capture_robots) do
        oldest_unit_number = math.min(oldest_unit_number, capture_robot.unit_number)
    end

    -- Destroy all capture robot except the oldest one
    for _, capture_robot in pairs(capture_robots) do
        if capture_robot.unit_number ~= oldest_unit_number then
            -- We're using die() instead of destroy(), which will cause the robot to explode instead of just
            -- disappear. This simulates the behavior of the rocket-launched capture robots, which will explode
            -- when they are (force-)fired at an invalid target.
            capture_robot.die()
        end
    end
end

return utils
