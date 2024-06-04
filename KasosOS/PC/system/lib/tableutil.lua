--- Utility functions for tables
---@class tableutil
local tableutil = {}
tableutil.__index = tableutil

--- Shallow copy a table, does not copy nested tables
function tableutil.shallow_copy(table)
    local newTable = {}
    for k, v in pairs(table) do
        newTable[k] = v
    end
    return newTable
end

--- Deep copy a table, copies nested tables
function tableutil.deep_copy(table)
    local newTable = {}
    for k, v in pairs(table) do
        if type(v) == "table" then
            newTable[k] = tableutil.deep_copy(v)
        else
            newTable[k] = v
        end
    end
    return newTable
end

return tableutil