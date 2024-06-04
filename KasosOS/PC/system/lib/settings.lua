local settings = settings
_G.
settings.__index = settings

--- Get the value of a setting
---@param key string The name of the setting
---@return mixed The value of the setting
function settings:get(key)
    return self.settings[key]
end

--- Set the value of a setting
---@param key string The name of the setting
---@param value mixed The value of the setting
function settings:set(key, value)
    self.settings[key] = value
end
