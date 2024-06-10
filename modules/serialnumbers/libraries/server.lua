function MODULE:GenerateUniqueSerialNumber()
    local serial
    local isUnique = false
    while not isUnique do
        serial = tostring(math.random(100000, 999999))
        isUnique = true
        for _, item in pairs(lia.item.instances) do
            if item:getData("SerialNumber") == serial then
                isUnique = false
                break
            end
        end
    end
    return serial
end

function MODULE:registerSerialNumberEtc(item)
    local client = item:getOwner()
    if not client then return end
    local character = client:getChar()
    if not character then return end
    local serialNumber = self:GenerateUniqueSerialNumber()
    if not serialNumber then return end
    local charID = character:getID()
    item:setData("SerialNumber", serialNumber)
    item:setData("ownerCharID", charID)
end

function MODULE:FindFileItem(player)
    local character = player:getChar()
    if character then
        for _, item in pairs(character:getInv():getItems()) do
            if item.uniqueID == "feile124" then return true, item.id end
        end
    end
    return false
end

function MODULE:FindOwnersBySerialNumber(serialNumber)
    local owners = {}
    for _, item in pairs(lia.item.instances) do
        if item.isWeapon and item:getData("SerialNumber") == serialNumber and not item:getData("SerialNumber_Scratched") then
            local charID = item:getData("ownerCharID")
            if charID then
                local character = lia.char.loaded[charID]
                if character then
                    local ownerName = character:getName()
                    local ownerData = {
                        name = ownerName,
                        charID = charID,
                        serialNumber = serialNumber
                    }

                    table.insert(owners, ownerData)
                end
            end
        end
    end
    return owners
end

function MODULE:InitiateSerialScratch(player, item)
    local validItems = {}
    validItems = self:GetValidWeaponsForPlayer(player)
    if validItems then
        net.Start("SerialNumbers.InitiateSerialScratch")
        net.WriteTable(validItems)
        net.Send(player)
    else
        player:notify("You have no weapon in your inventory")
    end
end

function MODULE:GetValidWeaponsForPlayer(player)
    local character = player:getChar()
    local validWeapons = {}
    for k, v in pairs(character:getInv():getItems()) do
        if v.isWeapon and not v:getData("SerialNumber_Scratched") then
            local weaponInfo = {
                name = v.name,
                serialNumber = v.id
            }

            table.insert(validWeapons, weaponInfo)
        end
    end
    return validWeapons
end