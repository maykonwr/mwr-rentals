local QBCore = exports['qb-core']:GetCoreObject()

-- Tabela para armazenar veículos alugados no servidor
local serverRentalVehicles = {}

RegisterNetEvent('mwr-rentals:sendinfomation', function(data, payMethod, rentTime)
	local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)

    local Payment = data.price
    if Player.PlayerData.money[payMethod] >= Payment then
        Player.Functions.RemoveMoney(payMethod, Payment, 'Vehicle rental')
        TriggerClientEvent('mwr-rentals:createvehicle', PlayerID, data, rentTime)
    else
		TriggerClientEvent('QBCore:Notify', PlayerID, Lang:t('error.insufficent_funds'), 'error')
    end
end)

if Config.Inventory == 'ox' then
    exports.ox_inventory:registerHook('createItem', function(payload)
        local metadata = payload.metadata
        return metadata
    end, {
        itemFilter = {
            rentalpapers = true,
            rentalkeys = true
        }
    })
end

RegisterNetEvent('mwr-rentals:sendvehicledata', function(vehicle, plate, rentTime)
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    if not vehicle then return end

    local paperItem = 'rentalpapers'
    local keyItem = 'rentalkeys'
    local Time = os.date('%I:%M %p')
    
    -- Definindo a localização para português
    os.setlocale('pt_BR.UTF-8')
    
    local Date = os.date('%A, %d de %B') -- Formato de data em português
    
    local currentTimestamp = os.time()
    local addTime = currentTimestamp + rentTime * 60 * 60
    local expireTime = os.date('%I:%M %p', addTime)
    
    local paperMetadata = {
        name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
        vehicle_model = vehicle,
        vehicle_plate = plate,
        rental_date = Date,
        rental_time = Time,
        rental_expiration = expireTime,
    }
    local keyMetadata = {
        vehicle_model = vehicle,
        vehicle_plate = plate
    }

    if Config.Inventory == 'ox' then
        exports.ox_inventory:AddItem(PlayerID, paperItem, 1, paperMetadata)
        exports.ox_inventory:AddItem(PlayerID, keyItem, 1, keyMetadata)
    else
        Player.Functions.AddItem(paperItem, 1, nil, paperMetadata)
        Player.Functions.AddItem(keyItem, 1, nil, keyMetadata)
        TriggerClientEvent('inventory:client:ItemBox', PlayerID,  QBCore.Shared.Items[paperItem], 'add')
        TriggerClientEvent('inventory:client:ItemBox', PlayerID,  QBCore.Shared.Items[keyItem], 'add')
    end
end)

-- Evento para salvar dados do veículo no servidor
RegisterNetEvent('mwr-rentals:savevehicledata', function(rentalData)
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    if not serverRentalVehicles[citizenid] then
        serverRentalVehicles[citizenid] = {}
    end
    
    -- Adicionar timestamp para controle
    rentalData.timestamp = os.time()
    
    table.insert(serverRentalVehicles[citizenid], rentalData)
    
    -- Log para debug
    print(string.format("[MWR-RENTALS] Veículo salvo para %s: %s (%s)", citizenid, rentalData.vehicleName, rentalData.vehiclePlate))
end)

-- Evento para sincronizar veículos alugados
RegisterNetEvent('mwr-rentals:syncrentals', function()
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    if serverRentalVehicles[citizenid] then
        TriggerClientEvent('mwr-rentals:receiverentals', PlayerID, serverRentalVehicles[citizenid])
        print(string.format("[MWR-RENTALS] Sincronização enviada para %s: %d veículos", citizenid, #serverRentalVehicles[citizenid]))
    else
        TriggerClientEvent('mwr-rentals:receiverentals', PlayerID, {})
        print(string.format("[MWR-RENTALS] Nenhum veículo encontrado para %s", citizenid))
    end
end)

-- Evento para remover veículo alugado do servidor
RegisterNetEvent('mwr-rentals:removevehicledata', function(vehiclePlate)
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    if serverRentalVehicles[citizenid] then
        for i, rental in ipairs(serverRentalVehicles[citizenid]) do
            if rental.vehiclePlate == vehiclePlate then
                table.remove(serverRentalVehicles[citizenid], i)
                print(string.format("[MWR-RENTALS] Veículo removido para %s: %s", citizenid, vehiclePlate))
                break
            end
        end
    end
end)

RegisterNetEvent('mwr-rentals:returnvehicle', function(price, vehicle)
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    
    -- Calcular o dinheiro de volta
    local money = price * Config.MoneyReturn
    Player.Functions.AddMoney(Config.PaymentType, money, 'Devolução do veículo')
    
    -- Remover documentos de aluguel
    if Config.Inventory == 'ox' then
        local items = exports.ox_inventory:Search(PlayerID, 'slots', 'rentalpapers')
        if items and items[1] then
            exports.ox_inventory:RemoveItem(PlayerID, 'rentalpapers', 1, nil, items[1].slot)
        end
        
        -- Remover chaves também
        local keyItems = exports.ox_inventory:Search(PlayerID, 'slots', 'rentalkeys')
        if keyItems and keyItems[1] then
            exports.ox_inventory:RemoveItem(PlayerID, 'rentalkeys', 1, nil, keyItems[1].slot)
        end
    else
        Player.Functions.RemoveItem('rentalpapers', 1)
        Player.Functions.RemoveItem('rentalkeys', 1)
    end
    
    TriggerClientEvent('QBCore:Notify', PlayerID, 'Você recebeu $' .. money .. ' de volta pela devolução do veículo!', 'success', 6000)
    
    print(string.format("[MWR-RENTALS] Veículo devolvido por %s. Valor recebido: $%s", Player.PlayerData.citizenid, money))
end)

-- Callback para verificar se um veículo existe
QBCore.Functions.CreateCallback('mwr-rentals:checkvehicleexists', function(source, cb, netId)
    if not netId then 
        cb(false)
        return 
    end
    
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local exists = DoesEntityExist(vehicle)
    cb(exists)
end)

-- Comando administrativo para limpar veículos alugados de um jogador
QBCore.Commands.Add('clearrentals', 'Limpar veículos alugados de um jogador (Admin)', {{name = 'id', help = 'ID do jogador'}}, true, function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('QBCore:Notify', source, 'ID inválido', 'error')
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', source, 'Jogador não encontrado', 'error')
        return
    end
    
    local citizenid = targetPlayer.PlayerData.citizenid
    if serverRentalVehicles[citizenid] then
        serverRentalVehicles[citizenid] = {}
        TriggerClientEvent('QBCore:Notify', source, 'Veículos alugados limpos para ' .. targetPlayer.PlayerData.name, 'success')
        TriggerClientEvent('mwr-rentals:receiverentals', targetId, {})
    else
        TriggerClientEvent('QBCore:Notify', source, 'Jogador não possui veículos alugados', 'error')
    end
end, 'admin')

-- Comando para verificar veículos alugados
QBCore.Commands.Add('checkrentals', 'Verificar veículos alugados (Admin)', {{name = 'id', help = 'ID do jogador (opcional)'}}, false, function(source, args)
    local targetId = args[1] and tonumber(args[1]) or source
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', source, 'Jogador não encontrado', 'error')
        return
    end
    
    local citizenid = targetPlayer.PlayerData.citizenid
    local rentals = serverRentalVehicles[citizenid] or {}
    
    TriggerClientEvent('QBCore:Notify', source, string.format('%s possui %d veículos alugados', targetPlayer.PlayerData.name, #rentals), 'primary')
    
    for i, rental in ipairs(rentals) do
        print(string.format("Rental %d: %s (%s) - NetworkID: %s", i, rental.vehicleName, rental.vehiclePlate, rental.networkId))
    end
end, 'admin')

if Config.Inventory == 'ox' then
    lib.callback.register('mwr-rentals:usekeys', function(source, slot)
        local itemData = exports.ox_inventory:GetSlot(source, slot)
        if itemData then
            return itemData
        end
    end)
else
    QBCore.Functions.CreateUseableItem('rentalkeys', function(source, item)
        local PlayerId = source
        if not item.info.vehicle_plate then return end
        TriggerClientEvent('mwr-rentals:client:givekeys', PlayerId, item.info.vehicle_plate)
    end)
end

-- Limpeza de dados antigos APENAS no início do servidor (reinício)
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("[MWR-RENTALS] Iniciando limpeza de dados antigos...")
        
        local currentTime = os.time()
        local cleanedCount = 0
        local totalPlayers = 0
        
        for citizenid, rentals in pairs(serverRentalVehicles) do
            totalPlayers = totalPlayers + 1
            local validRentals = {}
            
            for _, rental in ipairs(rentals) do
                if rental.timestamp and (currentTime - rental.timestamp) < 86400 then -- 24 horas
                    table.insert(validRentals, rental)
                else
                    cleanedCount = cleanedCount + 1
                end
            end
            
            if #validRentals == 0 then
                serverRentalVehicles[citizenid] = nil
            else
                serverRentalVehicles[citizenid] = validRentals
            end
        end
        
        print(string.format("[MWR-RENTALS] Limpeza concluída: %d veículos antigos removidos de %d jogadores", cleanedCount, totalPlayers))
    end
end)