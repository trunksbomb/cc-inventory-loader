fn = "default.txt"
separator = "="

local function exists()
    f = io.open(fn, "r")
    if f ~= nil then
        io.close(f)
        return true
    end
    return false
end

local function load()
    defaults = {}
    if not exists() then
        return defaults
    end
    
    for line in io.lines(fn) do
        sepPos = string.find(line, separator)
        itemType = string.sub(line,1,sepPos-1)
        mode = string.sub(line,sepPos+1)
        defaults[itemType] = mode        
    end
    return defaults
end

return { load = load }
