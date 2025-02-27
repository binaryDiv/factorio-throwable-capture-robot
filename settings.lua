-- Define startup settings
data:extend {
    -- Whether to replace the capture bot rocket with the capsule, or only add the capsule as an alternative
    {
        setting_type = "startup",
        type = "bool-setting",
        name = "throwable-capture-robot-replace-rocket",
        default_value = true,
    },
}
