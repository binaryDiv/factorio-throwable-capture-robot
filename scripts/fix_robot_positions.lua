local utils = require("scripts.utils")

-- Find all capture-robot-rocket projectiles around a player and register them for the "on_object_destroyed" event,
-- as well as saving additional data about them in the mod storage for later.
function register_capture_robot_projectiles_around_player(player, target_position)
    -- Find capture robot projectiles around player
    local capture_robot_projectiles = utils.find_capture_robot_projectiles_near(player)

    -- Register "on_object_destroyed" event for capture robot projectiles
    for _, projectile in pairs(capture_robot_projectiles) do
        -- We store the event position, i.e. the position the player clicked to throw the capsule, as the projectile's
        -- target position.
        utils.register_capture_robot_projectile(projectile, target_position)
    end
end

-- For a given position, find biter spawners and capture robots occupying them, fix the position of the capture robots
-- to center them on the spawner and remove redundant capture robots.
function fix_capture_robots_on_spawners(surface, target_position)
    -- Find biter spawner that is targeted by the capture robot projectile.
    -- Ignore event if no spawner was found at the position (in which case the robot just explodes) or if more than one
    -- spawner was found (see comment of utils function).
    local targeted_spawner = utils.find_spawner_at_position(surface, target_position)
    if targeted_spawner == nil then
        return
    end

    -- Find all capture robots that are in the process of capturing this spawner
    local capture_robots = utils.find_capture_robots_on_spawner(targeted_spawner)

    -- Nothing to do if no capture robot was found
    if #capture_robots == 0 then
        return
    end

    if #capture_robots == 1 then
        -- Exactly one capture robot was found on the spawner.
        -- Fix the position by moving the robot to the center of the spawner.
        capture_robots[1].teleport(targeted_spawner.position)
    else
        -- More than one capture robot was found on the spawner. This means a capture robot was created on a spawner
        -- that is already occupied by another capture robot. We only want one capture robot, though, so we find out
        -- which robot was there first and destroy all others.
        utils.destroy_redundant_capture_robots(capture_robots)
    end
end
