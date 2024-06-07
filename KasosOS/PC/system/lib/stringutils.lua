--- Utility functions for strings
---@class stringutil
local stringutil = {}
stringutil.__index = stringutil

--- Splits a string by a separator
---@param inputstr string The string to split
---@param sep string The separator
---@return table splitted The splitted string
function stringutil.split(inputstr, sep)
    sep = sep or "%s"
    local t = {}
    for str in inputstr:gmatch("([^"..sep.."]+)") do
      table.insert(t, str)
    end
    return t
end

return stringutil