local cData = {}

RegisterNetEvent('Nui:OpenMarkets', function(data)
    SendNUIMessage({
        act = 'openMarket',
        items = data,
    })
end)

RegisterNUICallback('Nui:setFocus', function(data, cb)
    SetNuiFocus(data[1], data[1])
end)

Citizen.CreateThread(function()
    for v, k in pairs(Config.Markets) do
        for _, coords in pairs(k.coords) do
            local blip = AddBlipForCoord(coords)
            SetBlipSprite(blip, 52)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ticks = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for v, k in pairs(Config.Markets) do
            for _, coords in pairs(k.coords) do
                local dist = #(playerCoords - coords)
                if dist < 5.0 then
                    ticks = 5
                    DrawMarker(2, coords.x, coords.y, coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, .5, .5, .5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                    if dist < 1.5 then
                        DrawText3D(coords.x, coords.y, coords.z + 0.2, "Apasa ~g~[E]~w~ pentru a deschide magazinul")
                    end
                    if dist < 1.5 then
                        if IsControlJustPressed(1, 38) then
                            cData = k.items
                            TriggerEvent('Nui:OpenMarkets', cData)
                        end
                    end
                end
            end
        end
        Citizen.Wait(ticks)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamRelativePitch()
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

RegisterNUICallback('Nui:marketBuy', function(data, cb)
    TriggerServerEvent('Nui:marketBuy', data)
end)