Config = Config or {}

Config.Inventory = 'ox' -- qb / lj / ps / ox inventory that you use
Config.PaymentType = 'cash' -- cash / bank used for when returning vehicles
Config.FuelScript = 'cdn-fuel' -- cdn-fuel / ps-fuel / lj-fuel / LegacyFuel
Config.MoneyReturn = 0.5 -- this is 50% money return once the rental vehicle is returned
Config.Locations = {
    [1] = {
        blip = {
            sprite = 225, color = 46, shortrange = true, scale = 0.7, name = 'Aluguel de veículos - Centro',
        },
        ped = {
            hash = `s_m_y_valet_01`,
            coords = vector4(-1228.80, -175.56, 39.33, 216.10),
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            icon = 'fas fa-car',
        },
        vehicles = {
            [1] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384795936651477052/latest.png?ex=6853bb37&is=685269b7&hm=15775be0558367827badb5085759377532e86136a36b81758f1055f822b843a8&', -- Image of the vehicle 
                vehiclehash = 'kalahari', -- Name of the vehicle (must be a vehicle from within the shared vehicles.lua in core)
                icon = 'fas fa-car',
                gas = math.random(50, 70), -- Random amount of gas the vehicle will have 
                price = 1000, -- Price of the vehicle to rent
            },
            [2] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384796388239478866/latest.png?ex=6853bba3&is=68526a23&hm=45ecad1e7afd534bf1186dd771ca33d0dbbfb9f7f6e90d91dc30372d516a2e89&',
                vehiclehash = 'bison', icon = 'fas fa-car', gas = math.random(50, 70), price = 2000,
            },
            [3] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384796322682507335/latest.png?ex=6853bb93&is=68526a13&hm=ea0a74f42e0e3f9d0afc81a902218855293347b3638c84a995c3d560241a8cc5&',
                vehiclehash = 'surge', icon = 'fas fa-car', gas = math.random(50, 70), price = 1500,
            },
            [4] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384796453896982598/latest.png?ex=6853bbb2&is=68526a32&hm=6d80b423bb7928673c64821c1cd2313f03045ea0340cb5a9af9f959c19a74108&',
                vehiclehash = 'ratbike', icon = 'fas fa-car', gas = math.random(50, 70), price = 1500,
            },
        },
        spawnpoints = {
            vector4(-1221.28, -181.17, 38.57, 107.82),
            vector4(-1219.25, -186.64, 38.57, 95.35),
            vector4(-1219.95, -190.73, 38.57, 95.59),
            vector4(-1233.86, -181.34, 38.63, 77.60),
        },
    },
    [2] = {
        blip = {
            sprite = 225, color = 46, shortrange = true, scale = 0.75, name = 'Aluguel de veículos - Sandy Shores',
        },
        ped = {
            hash = `s_m_y_valet_01`,
            coords = vector4(1105.29, 2659.03, 38.14, 358.38),
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            icon = 'fas fa-car',
        },
        vehicles = {
            [1] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384795936651477052/latest.png?ex=6853bb37&is=685269b7&hm=15775be0558367827badb5085759377532e86136a36b81758f1055f822b843a8&', -- Image of the vehicle 
                vehiclehash = 'kalahari', -- Name of the vehicle (must be a vehicle from within the shared vehicles.lua in core)
                icon = 'fas fa-car',
                gas = math.random(50, 70), -- Random amount of gas the vehicle will have 
                price = 1000, -- Price of the vehicle to rent
            },
            [2] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384796388239478866/latest.png?ex=6853bba3&is=68526a23&hm=45ecad1e7afd534bf1186dd771ca33d0dbbfb9f7f6e90d91dc30372d516a2e89&',
                vehiclehash = 'bison', icon = 'fas fa-car', gas = math.random(50, 70), price = 2000,
            },
            [3] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384796322682507335/latest.png?ex=6853bb93&is=68526a13&hm=ea0a74f42e0e3f9d0afc81a902218855293347b3638c84a995c3d560241a8cc5&',
                vehiclehash = 'surge', icon = 'fas fa-car', gas = math.random(50, 70), price = 1500,
            },
            [4] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384796453896982598/latest.png?ex=6853bbb2&is=68526a32&hm=6d80b423bb7928673c64821c1cd2313f03045ea0340cb5a9af9f959c19a74108&',
                vehiclehash = 'ratbike', icon = 'fas fa-car', gas = math.random(50, 70), price = 1500,
            },
        },
        spawnpoints = {
            vector4(1105.53, 2663.66, 37.51, 359.01),
            vector4(1101.73, 2663.55, 37.51, 0.13),
            vector4(1098.34, 2664.05, 37.51, 0.15),
        },
    },
    [3] = {
        blip = {
            sprite = 225, color = 46, shortrange = true, scale = 0.75, name = 'Aluguel de veículos - Paleto Bay',
        },
        ped = {
            hash = `s_m_y_valet_01`,
            coords = vector4(-276.43, 6226.28, 31.70, 45.0),
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            icon = 'fas fa-car',
        },
        vehicles = {
            [1] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384795936651477052/latest.png?ex=6853bb37&is=685269b7&hm=15775be0558367827badb5085759377532e86136a36b81758f1055f822b843a8&',
                vehiclehash = 'kalahari',
                icon = 'fas fa-car',
                gas = math.random(50, 70),
                price = 1000,
            },
            [2] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1134935950313656330/1384796388239478866/latest.png?ex=6853bba3&is=68526a23&hm=45ecad1e7afd534bf1186dd771ca33d0dbbfb9f7f6e90d91dc30372d516a2e89&',
                vehiclehash = 'bison', icon = 'fas fa-car', gas = math.random(50, 70), price = 2000,
            },
        },
        spawnpoints = {
            vector4(-280.12, 6230.45, 31.49, 45.0),
            vector4(-283.45, 6233.78, 31.49, 45.0),
        },
    },

    -- To add more locations simply copy the array above an simply change the number and the information within
}