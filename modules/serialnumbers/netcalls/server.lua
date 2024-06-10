local MODULE = MODULE
net.Receive("SerialNumbers.FinishSerialScratch", function(len, ply)
    local scratch = net.ReadBool()
    local itemId = net.ReadUInt(32)
    local item = lia.item.instances[itemId]
    if item and scratch then
        if item.isWeapon then
            item:setData("SerialNumber_Scratched", true)
            ply:notify("The serial number was successfully removed.")
            local fileItemFound, fileItemId = MODULE:FindFileItem(ply)
            if fileItemFound then
                local fileItem = lia.item.instances[fileItemId]
                fileItem:remove()
                ply:notify("The file has been removed from your inventory.")
            else
                ply:notify("No file item found in inventory.")
            end
        else
            ply:notify("You cannot modify this weapon.")
        end
    else
        ply:notify("Operation cancelled or failed.")
    end
end)

net.Receive("SerialNumbers.OwnerRequest", function(len, ply)
    local serialNumber = net.ReadString()
    local ownersData = MODULE:FindOwnersBySerialNumber(serialNumber)
    net.Start("SerialNumbers.OwnerResponse")
    net.WriteTable(ownersData)
    net.Send(ply)
end)

util.AddNetworkString("SerialNumbers.InitiateSerialScratch")
util.AddNetworkString("SerialNumbers.FinishSerialScratch")
util.AddNetworkString("SerialNumbers.OpenComputer")
util.AddNetworkString("SerialNumbers.OwnerRequest")
util.AddNetworkString("SerialNumbers.OwnerResponse")