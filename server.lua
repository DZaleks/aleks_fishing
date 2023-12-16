function SendNotificationFromServer(player, message, type)
    print(player)
    print(message)
    print(type)
end

RegisterNetEvent('aleks_fishing:losebait', function(success, FishData, item)
    local playerItems = {}
    local count = 1
    if success == false then
        SendNotificationFromServer(source, "You lost your bait", "info")
        
    else
        TriggerEvent('aleks_fishing:sendDiscordLog', source, FishData)
        
        --if FishData == "Tuna" then
        --    Do something
        --end
        
        SendNotificationFromServer(source, "You caught ".. FishData .. "!", "success")
        exports.ox_inventory:AddItem(source, item, count)
    end

    local playerItems = exports.ox_inventory:GetInventoryItems(source)
    local durabilityValue = nil
    local SlotID = nil

    for _, item in ipairs(playerItems) do
        if item.name == Config.FishingrodItem then
            durabilityValue = item.metadata.durability
            SlotID = item.slot
            if durabilityValue >= 10 then
                break
            end
            if durabilityValue == nil then
                return false
            end
        end
    end
    if durabilityValue ~= nil and SlotID ~= nil then
        exports.ox_inventory:SetDurability(source, SlotID, durabilityValue - math.random(0,1))
    end
    exports.ox_inventory:RemoveItem(source, Config.FishbaitItem, 1)
end)


RegisterNetEvent('aleks_fishing:getFish', function()
    exports.ox_inventory:RemoveItem(source, Config.FishbaitItem, 1)
end)

---------- Discord Log ---------- 

RegisterNetEvent('aleks_fishing:sendDiscordLog')
AddEventHandler('aleks_fishing:sendDiscordLog', function(source, fish)
    if Config.DiscordWebhook == nil then return end
    local allIdentifier = GetPlayerIdentifiers(source)

    for k, v in ipairs(allIdentifier) do
        if string.match(v, "discord:") then
            identifier = v:gsub('discord:', '')
            break
        end
    end

    for _, id2 in ipairs(allIdentifier) do
        if string.find(id2, "license:") then
            identifier2 = id2
            break
        end
    end

    local logMessage = string.format("**Fish:** %s\n\n**Player:** %s \n<@%s>\n%s",  fish, source, identifier, identifier2)

    local discordPayload = {
        ["embeds"] = {
            {
                ["title"] = "Fish caught!",
                ["description"] = logMessage,
                ["color"] = 65280
            }
        }
    }
    PerformHttpRequest(Config.DiscordWebhook, function(statusCode, responseText, headers)
    end, 'POST', json.encode(discordPayload), { ['Content-Type'] = 'application/json' })
end)