-- Mod initialization handler
function initialize_mod()
    -- Initialize mod storage
    if storage.registered_capture_robots == nil then
        storage.registered_capture_robots = {}
    end
end

-- Initialize mod storage when the mod is added to a save game or when there is an update or config change.
script.on_init(initialize_mod)
script.on_configuration_changed(initialize_mod)

-- Handle event: Player used a capture robot capsule
script.on_event(defines.events.on_player_used_capsule, function(event)
    if event.item.name ~= "capture-robot-capsule" then
        return
    end

    -- Find and register capture robot projectiles around player
    local player = game.players[event.player_index]
    register_capture_robot_projectiles_around_player(player, event.position)
end)

-- Handle event: A capture robot projectile was destroyed (i.e. arrived at it's destination)
script.on_event(defines.events.on_object_destroyed, function(event)
    -- Some object previously registered with "register_on_object_destroyed" was destroyed, but this could be any type
    -- of object that was registered by any mod. Check if we have information about it, otherwise ignore event.
    local capture_robot_data = storage.registered_capture_robots[event.registration_number]
    if capture_robot_data == nil then
        return
    end

    -- Remove registered data from mod storage
    storage.registered_capture_robots[event.registration_number] = nil

    -- Get target position (where the player clicked to throw the capsule) and surface of projectile
    local target_position = capture_robot_data.target_position
    local surface = game.surfaces[capture_robot_data.surface_index]

    -- Fix capture robots that have been created on spawners (fix position, remove redundant ones)
    fix_capture_robots_on_spawners(surface, target_position)
end)
