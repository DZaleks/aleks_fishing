local FishingActive = false
WaitCooldownActive = false
local sleep = 10000
MODEL = `prop_fishing_rod_01`


function SendNotification(message, type)
    print(message)
    print(type)
end


function WaterCheck()
    local headPos = GetPedBoneCoords(GetPlayerPed(-1), 31086, 0.0, 0.0, 0.0)
    local offsetPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 50.0, -25.0)
    local water, waterPos = TestProbeAgainstWater(headPos.x, headPos.y, headPos.z, offsetPos.x, offsetPos.y, offsetPos.z)
    return water, waterPos
end

function StopFishing()
    DeleteObject(POLE)
    DeleteEntity(POLE)
    ClearPedTasks(GetPlayerPed(-1))
    DeleteObject(POLE)
    RemoveAnimDict('mini@tennis')
    RemoveAnimDict('amb@world_human_stand_fishing@idle_a')
    FishingActive = false
end

function GetRandomFish()
    local totalLuck = 0

    for _, fish in ipairs(Config.Fish) do
        totalLuck = totalLuck + tonumber(fish.luck)
    end

    local randomValue = math.random(1, totalLuck)

    local selectedFish = nil
    for _, fish in ipairs(Config.Fish) do
        randomValue = randomValue - tonumber(fish.luck)
        if randomValue <= 0 then
            selectedFish = fish
            break
        end
    end

    return selectedFish.displayName, selectedFish.difficulty, selectedFish.name
end


function GetFish()
    local chance = math.random(1,100)
    if FishingActive == true and WaitCooldownActive == false then
        WaitCooldownActive = true
        Wait(Config.FishCooldown)
        WaitCooldownActive = false
        if FishingActive == false then return end
        if chance <= Config.FindChance then
            SendNotification("You caught something ...", "info")
            Wait(1500)
            local FishData, Difficulty, item = GetRandomFish()
            local success = lib.skillCheck(Difficulty)
            if success == true then 
                TriggerServerEvent('aleks_fishing:losebait', success, FishData, item)
            else 
                local losechance = math.random(1,100)
                if losechance <= Config.BaitLoseChanceOnFail then
                    TriggerServerEvent('aleks_fishing:losebait', success, FishData, item)
                end
            end
        else
            return
        end
    else
        return
    end
end

function GetAngelDurability()
    local angelSlots = exports.ox_inventory:GetSlotsWithItem(Config.FishingrodItem)
    for _, item in ipairs(angelSlots) do
        if item and item.metadata and item.metadata.durability and tonumber(item.metadata.durability) > 0.1 then
            return true
        end
    end
    return false
end

function StartFishing()
    if FishingActive == true then return end
    local isNearWater, WaterLocation = WaterCheck()
    local hasKoeder = exports.ox_inventory:GetItemCount(Config.FishbaitItem)
    if isNearWater == 1 then
        HasAngel = GetAngelDurability()
        if HasAngel == true and hasKoeder >= 1 then
            lib.requestModel(MODEL, 100)
            POLE = CreateObject(MODEL, GetEntityCoords(GetPlayerPed(-1)), true, false, false)
            AttachEntityToEntity(POLE, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
            SetModelAsNoLongerNeeded(MODEL)

            lib.requestAnimDict('mini@tennis', 100)
            lib.requestAnimDict('amb@world_human_stand_fishing@idle_a', 100)
            TaskPlayAnim(GetPlayerPed(-1), 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, false, false, false)
            Wait(1000)
            TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 11, 0, false, false, false)
            FishingActive = true
            ActivateFishingControl()
            sleep = 10000
            CreateThread(function()
                while true do
                    if FishingActive == true then
                        local HasAngel = GetAngelDurability()

                        if FishingActive == false then break end
                        if HasAngel == false or HasAngel == nil then
                            SendNotification("You got no fishing rod!", "error")
                            StopFishing()
                            break
                        end
                        local hasKoeder = exports.ox_inventory:GetItemCount(Config.FishbaitItem)
                        if hasKoeder >= 1 then
                            GetFish()
                        else
                            StopFishing()
                            SendNotification("You got no more fish bait!", "error")
                            FishingActive = false
                            break
                        end
                    else
                        break
                    end
                    Wait(sleep)
                end
            end)
        else
            SendNotification("You got no fishbait or fishing rod!", "error")
        end
    else
        SendNotification("You need to be at the water!", "error")
    end
end

function ActivateFishingControl()
    CreateThread(function()
        while true do
            ShowHelpText("Press ~INPUT_FRONTEND_RRIGHT~ to cancel")
            if IsControlJustReleased(0, 194) then
                StopFishing()
                break
            end
            Wait(0)
        end
    end)
end

RegisterNetEvent('aleks_fishing:startFishing', function()
    if not FishingActive then
        StartFishing()
    else
        SendNotification("You're already fishing!", "error")
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    if FishingActive == true then
        StopFishing()
    end
end)

function ShowHelpText(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end