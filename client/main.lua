ESX = exports["es_extended"]:getSharedObject()

searching = false
cachedDumpsters = {}

-- Citizen["CreateThread"](function()
--     while ESX == nil do
--         Citizen["Wait"](5)

-- 		TriggerEvent("esx:getSharedObject", function(library)
-- 			ESX = library
-- 		end)
--     end

--     if ESX["IsPlayerLoaded"]() then
-- 		ESX["PlayerData"] = ESX["GetPlayerData"]()
--     end
-- end)

-- RegisterNetEvent("esx:playerLoaded")
-- AddEventHandler("esx:playerLoaded", function(response)
-- 	ESX["PlayerData"] = response
-- end)

Citizen["CreateThread"](function()
    while true do
        local sleepThread = 750
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isInVehicle = IsPedInAnyVehicle(playerPed, false) -- Check if the player is in a vehicle

        if searching then DisableControls() end 
        if not isInVehicle then -- Only proceed if the player is not in a vehicle
            for i = 1, #Config["Dumpsters"] do
                local entity = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(Config["Dumpsters"][i]), false, false, false)
                local entityCoords = GetEntityCoords(entity)

                if DoesEntityExist(entity) then
                    sleepThread = 5
                    
                    if IsControlJustReleased(0, 38) then
                        if not cachedDumpsters[entity] then
                            Search(entity)
                        else
                            ESX["ShowNotification"](Strings["Searched"])
                        end
                    end

                    DrawText3D(entityCoords + vector3(0.0, 0.0, 1.5), Strings["Search"])
                    break
                end
            end
        else
            -- Optionally, display a notification that searching is not allowed while in a vehicle
            -- ESX["ShowNotification"]("You cannot search while in a vehicle.")
        end

        Citizen["Wait"](sleepThread)
    end
end)

DrawText3D = function(coords, text)
    SetDrawOrigin(coords)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    DrawRect(0.0, 0.0125, 0.015 + text:gsub("~.-~", ""):len() / 370, 0.03, 45, 45, 45, 150)
    ClearDrawOrigin()
end

Search = function(entity)
    searching = true
    cachedDumpsters[entity] = true
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

    Citizen.CreateThread(function()
        Citizen.Wait(1000)

        if not IsPedUsingScenario(playerPed, "PROP_HUMAN_BUM_BIN") then
            searching = false
            ClearPedTasks(playerPed)
            ESX.ShowNotification("Stop abusing!")
            ESX.ShowNotification("~y~You canceled the search...")
            return
        end
    end)

    exports["t0sic_loadingbar"]:StartDelayedFunction(Strings["Searching"], Config["SearchTime"], function()
        if not IsPedUsingScenario(playerPed, "PROP_HUMAN_BUM_BIN") then
            searching = false
            ClearPedTasks(playerPed)
            ESX.ShowNotification("~r~Stop abusing!")
            ESX.ShowNotification("~y~You canceled the search...")
            return
        end

        ESX.TriggerServerCallback(GetCurrentResourceName(), function(found, object, quantity)
            if found then
                ESX.ShowNotification(Strings["Found"] .. quantity .. "x " .. object)
            else
                ESX.ShowNotification(Strings["Nothing"])
            end
        end)
        searching = false
        ClearPedTasks(playerPed)
    end)
end

DisableControls = function()
    DisableControlAction(0, 73) -- X (Handsup)
    DisableControlAction(0, 323) -- X (Reset)
    DisableControlAction(0, 288) -- F1 (Phone)
    DisableControlAction(0, 289) -- F2 (Inventory)
    DisableControlAction(0, 170) -- F3 (Menu)
    DisableControlAction(0, 166) -- F5 (Menu)
    DisableControlAction(0, 167) -- F6 (Menu)
    DisableControlAction(0, 22) -- Spacebar (Jump)
    DisableControlAction(0, 36) -- Ctrl
    DisableControlAction(0, 34) -- A (Walk left)
    DisableControlAction(0, 35) -- D (Walk right)
    DisableControlAction(0, 24) -- Q (Hide)
end
