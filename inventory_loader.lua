tu = require("common")
default = require("default")

inventories = {peripheral.find("inventory")}
itemStorages = {peripheral.find("item_storage")}

for k,v in pairs(itemStorages) do
    table.insert(inventories, v)
end

defaults = default.load()
inputTypes = {}
outputTypes = {}

for itemType, mode in pairs(defaults) do
    if mode == "ii" then
        table.insert(inputTypes, itemType)
    elseif mode == "oo" then
        table.insert(outputTypes, itemType)
    end
end

inputs = {}
outputs = {}

if #inventories >= 2 then
    print("Select inventories...")
    for _,i in pairs(inventories) do
        inventoryType = peripheral.getType(i)
        
        if tu.contains(inputTypes, inventoryType) then
            table.insert(inputs, i)
            print("   Using as input: " .. inventoryType)
        elseif tu.contains(outputTypes, inventoryType) then
            table.insert(outputs, i)
            print("   Using as output: " .. inventoryType)
        else
            print("  " .. peripheral.getName(i) .. "?")
            print("  [I]nput, [O]utput, [II] All inputs, [OO] All outputs")
            response = string.sub(read(), 1, 2)
            response = string.upper(response)
        
            if response == "I" then
                table.insert(inputs, i)
                print("   Using as input.")
            elseif response == "O" then
                table.insert(outputs, i)
                print("   Using as output.")
            elseif response == "II" then
                table.insert(inputs, i)
                table.insert(inputTypes, inventoryType)
                print("   Using " .. inventoryType .. " as inputs.")
            elseif response == "OO" then
                table.insert(outputs, i)
                table.insert(outputTypes, inventoryType)
                print("   Using " .. inventoryType .. " as outputs.")
            end        
        end
    end
    print("Done selecting inventories. Starting now.")
elseif #inventories == 1 then
    error("You must connect at least 2 inventory-capable blocks.")
    return
else
    error("No compatible inventories found. Please connect at least 2 inventory-capable blocks to this computer.")
    return
end

function isItemStorage(inv)
    return tu.contains(peripheral.getMethods(peripheral.getName(inv)), "pushItem")
end

function countInventories(side)
    count = {}
    for _,inv in pairs(side) do
        if isItemStorage(inv) then
            items = inv.items()
        else
            items = inv.list()
        end
        
        for __,item in pairs(items) do
            if not tu.containsKey(count, item.name) then
                count[item.name] = item.count
            else
                count[item.name] = count[item.name] + item.count
            end
        end
    end
    return count
end

function compare(compareTo, itemType, count)
    for k,v in pairs(compareTo) do
        if k == itemType then
            return count - v
        end
    end
    return count
end

function tryMoveItems(ins, outs)
    for itemType,count in pairs(ins) do
        numToTransfer = compare(outs, itemType, count)
        if numToTransfer > 0 then
            pcall(function() moveItems(itemType, numToTransfer) end)
        end
    end
end

function moveItems(itemType, num)
    for _,i in pairs(inputs) do
        if not isItemStorage(i) then
            for slot,item in pairs(i.list()) do
                if item.name == itemType then
                    for __,o in pairs(outputs) do
                        num = num - i.pushItems(peripheral.getName(o), slot, num)
                    end
                end
                if num <= 0 then
                    return
                end
            end
            if num <= 0 then
                return
            end
        else
            for __,o in pairs(outputs) do
                num = num - i.pushItem(peripheral.getName(o), {name=itemType}, num)
                if num <= 0 then
                    return
                end
            end
        end
    end
    if num <= 0 then
        return
    end
end

while true do
    inputItems = countInventories(inputs)
    outputItems = countInventories(outputs)
    tryMoveItems(inputItems, outputItems)
    sleep(2)
end
