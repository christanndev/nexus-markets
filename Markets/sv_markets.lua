if Config.Framework == "vRP" then
    local Tunnel = module("vrp", "lib/Tunnel")
    local Proxy = module("vrp", "lib/Proxy")
    local vRP = Proxy.getInterface("vRP")
    local vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())

    RegisterServerEvent('Nui:marketBuy', function(data)
        local player = source
        local user_id = vRP.getUserId({player})

        for k, v in pairs(data.shoppingCart) do
            local pricePerOne = tonumber(v.price)
            local totalPrice = (tonumber(v.amount) or 1) * pricePerOne
            local canPay = false

            if totalPrice > 1 then
                if data.method == "Cash" then
                    if vRP.tryPayment({user_id, totalPrice}) then
                        vRP.giveInventoryItem({user_id, v.label, (tonumber(v.amount) or 1), false})    
                    else
                        vRPclient.notify(player, {"Nu ai destui bani"})
                    end
                else
                    if vRP.tryBankPayment({user_id, totalPrice}) then
                        vRP.giveInventoryItem({user_id, v.label, (tonumber(v.amount) or 1), false})   
                    else
                        vRPclient.notify(player, {"Nu ai destui bani"}) 
                    end
                end
            end
        end
    end)
elseif Config.Framework == 'ESX' then
    local ESX = nil
    
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    
    RegisterServerEvent('Nui:marketBuy', function(data)
        local player = source
        local xPlayer = ESX.GetPlayerFromId(player)

        for k, v in pairs(data.shoppingCart) do
            local pricePerOne = tonumber(v.price)
            local totalPrice = (tonumber(v.amount) or 1) * pricePerOne
            local canPay = false

            if totalPrice > 1 then
                if data.method == "Cash" then
                    if xPlayer.getMoney() >= totalPrice then
                        xPlayer.removeMoney(totalPrice)
                        xPlayer.addInventoryItem(v.label, (tonumber(v.amount) or 1))
                    else
                        TriggerClientEvent('esx:showNotification', player, "Nu ai destui bani")
                    end
                else
                    if xPlayer.getAccount('bank').money >= totalPrice then
                        xPlayer.removeAccountMoney('bank', totalPrice)
                        xPlayer.addInventoryItem(v.label, (tonumber(v.amount) or 1))
                    else
                        TriggerClientEvent('esx:showNotification', player, "Nu ai destui bani")
                    end
                end
            end
        end
    end)

elseif Config.Framework == 'QBCore' then
    local QBCore = exports['qb-core']:GetCoreObject()

    RegisterServerEvent('Nui:marketBuy', function(data)
        local player = source
        local user_id = QBCore.Functions.GetPlayer(player).PlayerData.citizenid

        for k, v in pairs(data.shoppingCart) do
            local pricePerOne = tonumber(v.price)
            local totalPrice = (tonumber(v.amount) or 1) * pricePerOne
            local canPay = false

            if totalPrice > 1 then
                if data.method == "Cash" then
                    if QBCore.Functions.GetPlayer(player).Functions.RemoveMoney('cash', totalPrice) then
                        QBCore.Functions.GetPlayer(player).Functions.AddItem(v.label, (tonumber(v.amount) or 1))
                    else
                        TriggerClientEvent('QBCore:Notify', player, "Nu ai destui bani", "error")
                    end
                else
                    if QBCore.Functions.GetPlayer(player).Functions.RemoveMoney('bank', totalPrice) then
                        QBCore.Functions.GetPlayer(player).Functions.AddItem(v.label, (tonumber(v.amount) or 1))
                    else
                        TriggerClientEvent('QBCore:Notify', player, "Nu ai destui bani", "error")
                    end
                end
            end
        end
    end)
end