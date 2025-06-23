local QBCore = exports['qb-core']:GetCoreObject()

local rentalVehicles = {}
local PlayerData = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    if Config.Inventory == 'ox' then
        Wait(500)
        exports.ox_inventory:displayMetadata({
            name = 'Nome',
            vehicle_model = 'Modelo do veículo',
            vehicle_plate = 'Placa de carro',
            rental_date = 'Data de locação',
            rental_time = 'Horario do aluguel',
            rental_expiration = 'Alugado até'
        })
    end
    
    Wait(2000)
    TriggerServerEvent('mwr-rentals:syncrentals')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = QBCore.Functions.GetPlayerData()
        if Config.Inventory == 'ox' then
            Wait(500)
            exports.ox_inventory:displayMetadata({
                name = 'Nome',
                vehicle_model = 'Modelo do veículo',
                vehicle_plate = 'Placa de carro',
                rental_date = 'Data de locação',
                rental_time = 'Horario do aluguel',
                rental_expiration = 'Alugado até'
            })
        end
        
        if PlayerData and PlayerData.citizenid then
            Wait(2000)
            TriggerServerEvent('mwr-rentals:syncrentals')
        end
    end
end)

RegisterNetEvent('apartments:client:SetHomeBlip', function()
    Wait(2000)
    TriggerServerEvent('mwr-rentals:syncrentals')
end)

RegisterNetEvent('qb-apartments:client:SetHomeBlip', function()
    Wait(2000)
    TriggerServerEvent('mwr-rentals:syncrentals')
end)

RegisterNetEvent('apartments:client:exitApartment', function()
    Wait(2000)
    TriggerServerEvent('mwr-rentals:syncrentals')
end)

RegisterNetEvent('qb-apartments:client:exitApartment', function()
    Wait(2000)
    TriggerServerEvent('mwr-rentals:syncrentals')
end)

AddEventHandler('playerSpawned', function()
    Wait(3000)
    if PlayerData and PlayerData.citizenid then
        TriggerServerEvent('mwr-rentals:syncrentals')
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        if PlayerData and PlayerData.citizenid then
            TriggerServerEvent('mwr-rentals:syncrentals')
        end
    end
end)

RegisterNetEvent('mwr-rentals:receiverentals', function(serverRentals)
    rentalVehicles = {}
    
    for _, rental in ipairs(serverRentals) do
        if rental.networkId then
            QBCore.Functions.TriggerCallback('mwr-rentals:checkvehicleexists', function(exists)
                if exists then
                    local vehicle = NetworkGetEntityFromNetworkId(rental.networkId)
                    if DoesEntityExist(vehicle) then
                        table.insert(rentalVehicles, {
                            id = rental.id,
                            vehicleName = rental.vehicleName,
                            vehicle = vehicle,
                            vehiclePlate = rental.vehiclePlate,
                            returnCoords = rental.returnCoords,
                            rentalPrice = rental.rentalPrice,
                            networkId = rental.networkId
                        })
                    else
                        table.insert(rentalVehicles, {
                            id = rental.id,
                            vehicleName = rental.vehicleName,
                            vehicle = nil,
                            vehiclePlate = rental.vehiclePlate,
                            returnCoords = rental.returnCoords,
                            rentalPrice = rental.rentalPrice,
                            networkId = rental.networkId
                        })
                    end
                else
                    table.insert(rentalVehicles, {
                        id = rental.id,
                        vehicleName = rental.vehicleName,
                        vehicle = nil,
                        vehiclePlate = rental.vehiclePlate,
                        returnCoords = rental.returnCoords,
                        rentalPrice = rental.rentalPrice,
                        networkId = rental.networkId
                    })
                end
            end, rental.networkId)
        else
            table.insert(rentalVehicles, {
                id = rental.id,
                vehicleName = rental.vehicleName,
                vehicle = nil,
                vehiclePlate = rental.vehiclePlate,
                returnCoords = rental.returnCoords,
                rentalPrice = rental.rentalPrice,
                networkId = nil
            })
        end
    end
end)

CreateThread(function()
    for id, data in pairs(Config.Locations) do
        local hash = data.ped.hash
        local coords = data.ped.coords
        local scenario = data.ped.scenario
        local targetIcon = data.ped.icon
        local blipSprite = data.blip.sprite
        local blipColor = data.blip.color
        local blipShortRange = data.blip.shortrange
        local blipScale = data.blip.scale
        local blipName = data.blip.name

        local rentalBlip = AddBlipForCoord(coords)
        SetBlipSprite(rentalBlip, blipSprite)
        SetBlipColour(rentalBlip, blipColor)
        SetBlipAsShortRange(rentalBlip, blipShortRange)
        SetBlipScale(rentalBlip, blipScale)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(blipName)
        EndTextCommandSetBlipName(rentalBlip)

        local RentalPed = exports['rep-talkNPC']:CreateNPC({
            npc = 's_m_y_valet_01',
            coords = vector4(coords.x, coords.y, coords.z-1.0, coords.w),
            name = 'Manobrista do Hotel',
            animName = "mini@strip_club@idles@bouncer@base",
            animDist = "base",
            tag = "Aluguel",
            color = "#b43f49",
            startMSG = 'Ola, sou o manobrista do hotel. \n\n Em que posso ajudar?'
        }, {
            [1] = {
                label = "Como posso alugar um carro?",
                shouldClose = false,
                action = function()
                    exports['rep-talkNPC']:updateMessage("É fácil. \n\n Basta escolher a forma de pagamento, o tempo que deseja ficar com o veículo e o modelo dele. \n\n Ah, lembre-se que se você devolver o veículo, receberá novamente 50% do valor!")
                end
            },
            [2] = {
                label = "Quais são minhas opções?",
                shouldClose = false,
                action = function()
                    exports['rep-talkNPC']:changeDialog( "Certo, você tem duas opções: \n\n Alugar ou devolver. \n\n Qual vai ser?",
                        {
                            [1] = {
                                label = "Alugar veículo",
                                shouldClose = true,
                                action = function()
                                    RentalMenu(id, data)
                                end
                            },
                            [2] = {
                                label = "Devolver veículo",
                                shouldClose = true,
                                action = function()
                                    TriggerServerEvent('mwr-rentals:syncrentals')
                                    Wait(1000)
                                    ShowRentals(id)
                                end
                            }
                        }
                    )
                end
            },
            [3] = {
                label = "Estou apenas de passagem",
                shouldClose = true,
                action = function()
                    TriggerEvent('rep-talkNPC:client:close')
                end
            }
        })
    end
end)

function ShowRentals(id)
    if not id then return end
    Wait(500)
    
    local rentals = {
        id = 'rentals',
        title = Lang:t('info.current_rentals'),
        options = {}
    }
    local options = {}
    
    for key, rental in pairs(rentalVehicles) do
        if rental.id == id then
            local vehicleExists = false
            local vehicleCoords = vector3(0, 0, 0)
            local streetName = "Localização desconhecida"
            local gasLevel = 0
            local actualVehicle = nil
            
            if rental.vehicle and DoesEntityExist(rental.vehicle) then
                vehicleExists = true
                actualVehicle = rental.vehicle
            elseif rental.networkId then
                local vehicle = NetworkGetEntityFromNetworkId(rental.networkId)
                if DoesEntityExist(vehicle) then
                    vehicleExists = true
                    actualVehicle = vehicle
                    rental.vehicle = vehicle
                end
            end
            
            if vehicleExists and actualVehicle then
                vehicleCoords = GetEntityCoords(actualVehicle)
                local street = GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
                streetName = GetStreetNameFromHashKey(street)
                gasLevel = GetVehicleFuelLevel(actualVehicle)
            end
            
            options[#options+1] = {
                title = rental.vehicleName .. (vehicleExists and "" or " (Não encontrado)"),
                description = vehicleExists and Lang:t('info.return_vehicle') or "Veículo perdido - Devolução administrativa disponível",
                arrow = true,
                metadata = {
                    {label = Lang:t('info.vehicle_plate'), value = rental.vehiclePlate},
                    {label = Lang:t('info.vehicle_fuel'), value = vehicleExists and math.floor(gasLevel) .. "%" or "N/A"},
                    {label = Lang:t('info.vehicle_location'), value = streetName},
                    {label = "Status", value = vehicleExists and "Encontrado" or "Perdido"},
                },
                event = 'mwr-rentals:returnvehicle',
                args = {
                    key = key,
                    vehicle = actualVehicle,
                    returnCoords = rental.returnCoords,
                    rentalPrice = rental.rentalPrice,
                    vehiclePlate = rental.vehiclePlate,
                    networkId = rental.networkId,
                    vehicleExists = vehicleExists
                }
            }
        end
    end
    
    if #options == 0 then
        options[#options+1] = {
            title = "Nenhum veículo alugado",
            description = "Você não possui veículos alugados neste local",
            disabled = true
        }
    end
    
    rentals['options'] = options
    lib.registerContext(rentals)
    lib.showContext('rentals')
end

RegisterNetEvent('mwr-rentals:returnvehicle', function (data)
    if not data then return end
    
    local rentalVehicle = data.vehicle
    local returnCoords = data.returnCoords
    local rentalPrice = data.rentalPrice
    local vehiclePlate = data.vehiclePlate
    local networkId = data.networkId
    local vehicleExists = data.vehicleExists
    
    if not vehicleExists and networkId then
        rentalVehicle = NetworkGetEntityFromNetworkId(networkId)
        if DoesEntityExist(rentalVehicle) then
            vehicleExists = true
        end
    end

    if vehicleExists and rentalVehicle and DoesEntityExist(rentalVehicle) then
        local vehicleLocation = GetEntityCoords(rentalVehicle)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local dist = #(vector3(returnCoords) - vehicleLocation)
        local playerDist = #(playerCoords - vehicleLocation)
        
        
        if dist < 50 or playerDist < 10 then
            NetworkRequestControlOfEntity(rentalVehicle)
            Wait(1000)
            
            if NetworkHasControlOfEntity(rentalVehicle) then
                SetVehicleAsNoLongerNeeded(rentalVehicle)
                NetworkFadeOutEntity(rentalVehicle, false, true)
                DeleteEntity(rentalVehicle)
                
                table.remove(rentalVehicles, data.key)
                
                TriggerServerEvent('mwr-rentals:removevehicledata', vehiclePlate)
                TriggerServerEvent('mwr-rentals:returnvehicle', rentalPrice, rentalVehicle)
                
                lib.notify({ 
                    id = 'vehicle_returned', 
                    type = 'success', 
                    description = 'Veículo devolvido com sucesso!', 
                    position = 'center-right' 
                })
            else
                lib.notify({ 
                    id = 'no_control', 
                    type = 'error', 
                    description = 'Não foi possível obter controle do veículo. Tente novamente.', 
                    position = 'center-right' 
                })
            end
        else
            lib.notify({ 
                id = 'vehicle_too_far', 
                type = 'error', 
                description = 'Veículo muito longe. Aproxime-se do veículo ou leve-o ao ponto de devolução.', 
                position = 'center-right' 
            })
        end
    else
        
        local alert = lib.alertDialog({
            header = 'Veículo Perdido',
            content = 'O veículo não foi encontrado. Isso pode acontecer após a seguradora recuperar ou por roubo.\n\nDeseja fazer a devolução administrativa?\n\n• Você receberá apenas 25% do valor pago\n• O veículo será removido dos seus aluguéis',
            centered = true,
            cancel = true,
            labels = {
                confirm = 'Devolver (25%)',
                cancel = 'Cancelar'
            }
        })
        
        if alert == 'confirm' then
            table.remove(rentalVehicles, data.key)
            
            TriggerServerEvent('mwr-rentals:removevehicledata', vehiclePlate)
            TriggerServerEvent('mwr-rentals:returnvehicle', rentalPrice * 0.5, nil)
            
            lib.notify({ 
                id = 'admin_return', 
                type = 'success', 
                description = 'Devolução administrativa realizada. Você recebeu 25% do valor.', 
                position = 'center-right' 
            })
        end
    end
end)

function RentalMenu(id, data)
    if not id then return end
    local allSpawnPointsOccupied = true
    for _, spawnPoint in ipairs(data.spawnpoints) do
        if not IsAnyVehicleNearPoint(spawnPoint.x, spawnPoint.y, spawnPoint.z, 1.0) then
            allSpawnPointsOccupied = false
            break
        end
    end

    if allSpawnPointsOccupied then
        lib.notify({ id = 'invalid_rental_spawnpoint', type = 'error', description = Lang:t('error.invalid_rental_spawnpoint'), position = 'center-right' })
        return
    end

    local resgisteredMenu = {
        id = 'rentalmenu',
        title = Lang:t('info.available_vehicle'),
        options = {}
    }
    local options = {}

    function generatePlate()
        local randomChance = math.random(1, 100)
        
        if randomChance <= 70 then
            return "MWRS" .. math.random(100, 999)
        elseif randomChance <= 90 then
            return "GG" .. math.random(100, 999)
        else
            return "GUT" .. math.random(100, 999)
        end
    end
    
    function applyPlate(vehicle, plate)
        SetVehicleNumberPlateText(vehicle, plate)
    end

    for _, v in pairs(data.vehicles) do
        local vehiclename = QBCore.Shared.Vehicles[v.vehiclehash]['name']
        options[#options+1] = {
            title = vehiclename,
            image = v.vehicleimage,
            icon = v.icon,
            description = Lang:t('info.vehicle_fuel'),
            progress = v.gas,
            arrow = true,
            metadata = {
                {label = Lang:t('info.vehicle_price'), value = '$'..v.price},
            },
            event = 'mwr-rentals:sendform',
            args = {
                id = id,
                hash = v.vehiclehash,
                coords = data.spawnpoints,
                vehicle = vehiclename,
                price = v.price,
                gas = v.gas
            }
        }
    end

    resgisteredMenu['options'] = options
    lib.registerContext(resgisteredMenu)
    lib.showContext('rentalmenu')
end

RegisterNetEvent('mwr-rentals:sendform', function (data)
    if not data then return end
    local header = 'Formulário de aluguel'
    local input = lib.inputDialog(header, {
        { 
            type = 'select', 
            label = Lang:t('info.payment_method'), 
            options = {
                { value = 'cash', label = Lang:t('info.payment_cash'), icon = 'fas fa-wallet'},
                { value = 'bank', label = Lang:t('info.payment_bank'), icon = 'fas fa-landmark'},
            }
        },
        { type = 'number', label = Lang:t('info.time_for_rental'), default = 0 },
    })
    local payMethod = input[1]
    local rentTime = input[2]
    
    if rentTime ~= nil and rentTime >= 1 then
        if payMethod then
            TriggerServerEvent('mwr-rentals:sendinfomation', data, payMethod, rentTime)
        else
            lib.notify({ id = 'no_payment_method', type = 'error', description = Lang:t('error.no_payment_method'), position = 'center-right' })
        end
    else
        lib.notify({ id = 'invalid_rental_time', type = 'error', description = Lang:t('error.invalid_rental_time'), position = 'center-right' })
    end
end)

RegisterNetEvent('mwr-rentals:createvehicle', function (data, rentTime)
    if not data then return end
    local hash = data.hash
    local vehiclePrice = data.price
    local vehicleName = data.vehicle
    local vehicleGas = data.gas
    local spawnPoints = data.coords
    local id = data.id
    local coords = spawnPoints[math.random(#spawnPoints)]
    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 1.0) then
        repeat
            coords = spawnPoints[math.random(#spawnPoints)]
        until not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 1.0)
    end
    QBCore.Functions.LoadModel(hash)
    local rentalVehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w, true, true)
    if DoesEntityExist(rentalVehicle) then
        vehicleRented = true
        local vehiclePlate = generatePlate()
        networkID = NetworkGetNetworkIdFromEntity(rentalVehicle)
        SetEntityAsMissionEntity(rentalVehicle)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        NetworkRegisterEntityAsNetworked(rentalVehicle)
        SetNetworkIdCanMigrate(networkID, true)
        SetVehicleDirtLevel(rentalVehicle, 0)
        SetVehicleEngineOn(rentalVehicle, true, true)
        SetVehicleDoorsLocked(rentalVehicle, 1)
        exports[Config.FuelScript]:SetFuel(rentalVehicle, vehicleGas)
        NetworkFadeInEntity(rentalVehicle, 1)
        applyPlate(rentalVehicle, vehiclePlate)
        TriggerEvent('vehiclekeys:client:SetOwner', vehiclePlate)
        TriggerServerEvent('mwr-rentals:sendvehicledata', vehicleName, vehiclePlate, rentTime)

        local rentalData = {
            id = id,
            vehicleName = vehicleName,
            vehicle = rentalVehicle,
            vehiclePlate = vehiclePlate,
            returnCoords = coords, 
            rentalPrice = vehiclePrice,
            networkId = networkID
        }

        table.insert(rentalVehicles, rentalData)
        
        TriggerServerEvent('mwr-rentals:savevehicledata', {
            id = id,
            vehicleName = vehicleName,
            vehiclePlate = vehiclePlate,
            returnCoords = coords,
            rentalPrice = vehiclePrice,
            networkId = networkID
        })
    end
end)

RegisterNetEvent('mwr-rentals:client:givekeys', function (plate)
    local closeVeh = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0)
    local vehPlate = GetVehicleNumberPlateText(closeVeh)
    if closeVeh then
        if vehPlate == plate then
            TriggerEvent('vehiclekeys:client:SetOwner', plate)
        else
            lib.notify({ id = 'not_the_right_vehicle', type = 'error', description = Lang:t('error.not_the_right_vehicle'), position = 'center-right' })
        end
    else
        lib.notify({ id = 'no_vehicle_nearby', type = 'error', description = Lang:t('error.no_vehicle_nearby'), position = 'center-right' })
    end
end)

if Config.Inventory == 'ox' then
    exports('usekeys', function(data)
        local closeVeh = lib.getClosestVehicle(GetEntityCoords(cache.ped), 3.0, true)
        local vehPlate = GetVehicleNumberPlateText(closeVeh)
        local response = lib.callback.await('mwr-rentals:usekeys', false, data.slot)
        if response then
            if vehPlate == response.metadata.vehicle_plate then
                TriggerEvent('vehiclekeys:client:SetOwner', response.metadata.vehicle_plate)
            else        
                lib.notify({ id = 'not_the_right_vehicle', type = 'error', description = Lang:t('error.not_the_right_vehicle'), position = 'center-right' })
            end
        end
    end)
end