local QBCore = exports['qb-core']:GetCoreObject()

local serverRentalVehicles = {}

-- Função para salvar dados no arquivo JSON
local function saveRentalData()
    SaveResourceFile(GetCurrentResourceName(), 'rental_data.json', json.encode(serverRentalVehicles, {indent = true}))
end

-- Função para carregar dados do arquivo JSON
local function loadRentalData()
    local data = LoadResourceFile(GetCurrentResourceName(), 'rental_data.json')
    if data then
        local decoded = json.decode(data)
        if decoded then
            serverRentalVehicles = decoded
            print('[mwr-rentals] Dados de aluguel carregados: ' .. #serverRentalVehicles .. ' registros')
        end
    else
        print('[mwr-rentals] Nenhum arquivo de dados encontrado, iniciando com dados vazios')
    end
end

-- Carregar dados ao iniciar o resource
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        loadRentalData()
        
        -- Limpar veículos expirados (mais de 24 horas)
        local currentTime = os.time()
        local cleanedCount = 0
        local totalPlayers = 0
        
        for citizenid, rentals in pairs(serverRentalVehicles) do
            totalPlayers = totalPlayers + 1
            local validRentals = {}
            
            for _, rental in ipairs(rentals) do
                if rental.timestamp and (currentTime - rental.timestamp) < 86400 then
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
        
        if cleanedCount > 0 then
            saveRentalData()
            print('[mwr-rentals] Limpeza automática: ' .. cleanedCount .. ' veículos expirados removidos')
        end
    end
end)

-- Salvar dados ao parar o resource
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        saveRentalData()
        print('[mwr-rentals] Dados de aluguel salvos')
    end
end)

-- Salvar dados periodicamente (a cada 5 minutos)
CreateThread(function()
    while true do
        Wait(300000) -- 5 minutos
        saveRentalData()
    end
end)

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
    
    os.setlocale('pt_BR.UTF-8')
    
    local Date = os.date('%A, %d de %B')
    
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

RegisterNetEvent('mwr-rentals:savevehicledata', function(rentalData)
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    if not serverRentalVehicles[citizenid] then
        serverRentalVehicles[citizenid] = {}
    end
    
    rentalData.timestamp = os.time()
    
    table.insert(serverRentalVehicles[citizenid], rentalData)
    
    -- Salvar imediatamente após adicionar um novo aluguel
    saveRentalData()
end)

RegisterNetEvent('mwr-rentals:syncrentals', function()
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    if serverRentalVehicles[citizenid] then
        TriggerClientEvent('mwr-rentals:receiverentals', PlayerID, serverRentalVehicles[citizenid])
    else
        TriggerClientEvent('mwr-rentals:receiverentals', PlayerID, {})
    end
end)

RegisterNetEvent('mwr-rentals:removevehicledata', function(vehiclePlate)
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    if serverRentalVehicles[citizenid] then
        for i, rental in ipairs(serverRentalVehicles[citizenid]) do
            if rental.vehiclePlate == vehiclePlate then
                table.remove(serverRentalVehicles[citizenid], i)
                break
            end
        end
        
        -- Salvar após remover um aluguel
        saveRentalData()
    end
end)

RegisterNetEvent('mwr-rentals:returnvehicle', function(price, vehicle)
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    
    local money = price * Config.MoneyReturn
    Player.Functions.AddMoney(Config.PaymentType, money, 'Devolução do veículo')
    
    if Config.Inventory == 'ox' then
        local items = exports.ox_inventory:Search(PlayerID, 'slots', 'rentalpapers')
        if items and items[1] then
            exports.ox_inventory:RemoveItem(PlayerID, 'rentalpapers', 1, nil, items[1].slot)
        end
        
        local keyItems = exports.ox_inventory:Search(PlayerID, 'slots', 'rentalkeys')
        if keyItems and keyItems[1] then
            exports.ox_inventory:RemoveItem(PlayerID, 'rentalkeys', 1, nil, keyItems[1].slot)
        end
    else
        Player.Functions.RemoveItem('rentalpapers', 1)
        Player.Functions.RemoveItem('rentalkeys', 1)
    end
    
    TriggerClientEvent('QBCore:Notify', PlayerID, 'Você recebeu $' .. money .. ' de volta pela devolução do veículo!', 'success', 6000)
end)

QBCore.Functions.CreateCallback('mwr-rentals:checkvehicleexists', function(source, cb, netId)
    if not netId then 
        cb(false)
        return 
    end
    
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local exists = DoesEntityExist(vehicle)
    cb(exists)
end)

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
        saveRentalData()
        TriggerClientEvent('QBCore:Notify', source, 'Veículos alugados limpos para ' .. targetPlayer.PlayerData.name, 'success')
        TriggerClientEvent('mwr-rentals:receiverentals', targetId, {})
    else
        TriggerClientEvent('QBCore:Notify', source, 'Jogador não possui veículos alugados', 'error')
    end
end, 'admin')

QBCore.Commands.Add('saverentals', 'Salvar dados de aluguel manualmente (Admin)', {}, false, function(source, args)
    saveRentalData()
    TriggerClientEvent('QBCore:Notify', source, 'Dados de aluguel salvos manualmente', 'success')
end, 'admin')

QBCore.Commands.Add('loadrentals', 'Recarregar dados de aluguel (Admin)', {}, false, function(source, args)
    loadRentalData()
    TriggerClientEvent('QBCore:Notify', source, 'Dados de aluguel recarregados', 'success')
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