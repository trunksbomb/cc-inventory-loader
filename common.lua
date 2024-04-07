local function contains(table, element)
    for i,v in pairs(table) do
        if v == element then
            return true
        end
    end
    return false
end

local function containsSubkey(table, key, keyName)
    for i,v in pairs(table) do
        if v[key] == keyName then
            return true
        end
    end
    return false
end

local function containsKey(table, key)
    for k,v in pairs(table) do
        if k == key then
            return true
        end
    end
    return false
end

local function printTable(table)
    for k,v in pairs(table) do
        print("[" .. k .. ", " .. v .. "]")
    end
end

return { contains = contains, 
containsKey = containsKey, 
containsSubkey = containsSubkey,
printTable = printTable }
