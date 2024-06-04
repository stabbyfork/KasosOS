local tableutil = {}

function tableutil.shallow_copy(table)
    local newTable = {}
    for k, v in pairs(table) do
        newTable[k] = v
    end
    return newTable
end

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