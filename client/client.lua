local QBCore = exports['qb-core']:GetCoreObject()

local rentalVehicles = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
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
        --QBCore.Functions.LoadModel(hash)
        --local RentalPed = CreatePed(0, hash, coords.x, coords.y, coords.z-1.0, coords.w, false, false)
        --[[ TaskStartScenarioInPlace(RentalPed, scenario, true)
        FreezeEntityPosition(RentalPed, true)
        SetEntityInvincible(RentalPed, true)
        SetBlockingOfNonTemporaryEvents(RentalPed, true) ]]

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
    local rentals = {
        id = 'rentals',
        title = Lang:t('info.current_rentals'),
        options = {}
    }
    local options = {}
    for key, rental in pairs(rentalVehicles) do
        if rental.id == id then
            local vehicleCoords = GetEntityCoords(rental.vehicle)
            local street = GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
            local streetName = GetStreetNameFromHashKey(street)
            local gasLevel = GetVehicleFuelLevel(rental.vehicle)
            options[#options+1] = {
                title = rental.vehicleName,
                description = Lang:t('info.return_vehicle'),
                arrow = true,
                metadata = {
                    {label = Lang:t('info.vehicle_plate'), value = rental.vehiclePlate},
                    {label = Lang:t('info.vehicle_fuel'), value = gasLevel},
                    {label = Lang:t('info.vehicle_location'), value = streetName},
                },
                event = 'mwr-rentals:returnvehicle',
                args = {
                    key = key,
                    vehicle = rental.vehicle,
                    returnCoords = rental.returnCoords,
                    rentalPrice = rental.rentalPrice,
                }
            }
        end
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

    local vehicleLocation = GetEntityCoords(rentalVehicle)
    local dist = #(vector3(returnCoords) - vehicleLocation)
    if dist < 15 then
        NetworkRequestControlOfEntity(rentalVehicle)
        Wait(500)
        SetVehicleAsNoLongerNeeded(rentalVehicle)
        NetworkFadeOutEntity(rentalVehicle, false, true)
        DeleteEntity(rentalVehicle)
        table.remove(rentalVehicles, data.key)
        TriggerServerEvent('mwr-rentals:returnvehicle', rentalPrice, rentalVehicle)
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
        -- Todos os pontos de spawn estão ocupados, exiba uma mensagem de aviso para os jogadores.
        lib.notify({ id = 'invalid_rental_spawnpoint', type = 'error', description = Lang:t('error.invalid_rental_spawnpoint'), position = 'center-right' })
        return
    end

    -- Se pelo menos um ponto de spawn estiver livre, permita que o jogador alugue um veículo.
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
        elseif randomChance <= 90 then  -- Adicionando uma nova condição para "GG"
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
    
    if rentTime ~= nil and rentTime >= 1 then -- Verifica se o tempo de aluguel é pelo menos 1
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
        local vehiclePlate = generatePlate() -- Gerar placa aleatória ou usar a placa fornecida pelo item
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
        applyPlate(rentalVehicle, vehiclePlate) -- Aplicar placa ao veículo
        TriggerEvent('vehiclekeys:client:SetOwner', vehiclePlate)
        TriggerServerEvent('mwr-rentals:sendvehicledata', vehicleName, vehiclePlate, rentTime)

        table.insert(rentalVehicles, {
            id = id,
            vehicleName = vehicleName,
            vehicle = rentalVehicle,
            vehiclePlate = vehiclePlate,
            returnCoords = coords, 
            rentalPrice = vehiclePrice
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
                TriggerEvent('vehiclekeys:client:SetOwner', plate)
            else        
                lib.notify({ id = 'not_the_right_vehicle', type = 'error', description = Lang:t('error.not_the_right_vehicle'), position = 'center-right' })
            end
        end
    end)
end
