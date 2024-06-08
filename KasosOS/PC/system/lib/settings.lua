local settings = settings
settings.__index = settings

--- Get the value of a setting
---@param key string The name of the setting
---@return any setting The value of the setting
function settings.get(key)
    return settings[key]
end

--- Set the value of a setting
---@param key string The name of the setting
---@param value any The value of the setting
function settings.set(key, value)
    settings[key] = value
end
