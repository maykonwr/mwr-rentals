local QBCore = exports['qb-core']:GetCoreObject()

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


RegisterNetEvent('mwr-rentals:returnvehicle', function(price, vehicle)
    local PlayerID = source
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    if not vehicle then return end
    local money = price * Config.MoneyReturn
    Player.Functions.AddMoney(Config.PaymentType, money, 'Devolução do veículo')
    Player.Functions.RemoveItem('rentalpapers', 1)
    TriggerClientEvent('QBCore:Notify', PlayerID, Lang:t('info.money_received', {money = money}), 'primary', 6000)
end)


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
