Config = Config or {}

Config.Inventory = 'ox' -- qb / lj / ps / ox inventory that you use
Config.PaymentType = 'cash' -- cash / bank used for when returning vehicles
Config.FuelScript = 'cdn-fuel' -- cdn-fuel / ps-fuel / lj-fuel / LegacyFuel
Config.MoneyReturn = 0.5 -- this is 50% money return once the rental vehicle is returned
Config.Locations = {
    [1] = {
        blip = {
            sprite = 225, color = 46, shortrange = true, scale = 0.7, name = 'Aluguel de veículos',
        },
        ped = {
            hash = `s_m_y_valet_01`,
            coords = vector4(-1228.80, -175.56, 39.33, 216.10),
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            icon = 'fas fa-car',
        },
        vehicles = {
            [1] = {
                vehicleimage = 'https://media.discordapp.net/attachments/1127979309139775530/1211415472650715157/latest.png?ex=65ee1d93&is=65dba893&hm=be79f20406518999e3256203856bb9a1e9d6c9e53ed9e10ed8a75f41aef02645&=&format=webp&quality=lossless&width=550&height=309', -- Image of the vehicle 
                vehiclehash = 'sultan', -- Name of the vehicle (must be a vehicle from within the shared vehicles.lua in core)
                icon = 'fas fa-car',
                gas = math.random(30, 70), -- Random amount of gas the vehicle will have 
                price = 500, -- Price of the vehicle to rent
            },
            [2] = {
                vehicleimage = 'https://media.discordapp.net/attachments/1127979309139775530/1211415650824884244/latest.png?ex=65ee1dbe&is=65dba8be&hm=54d465f57dcf17cca5fc7a476dd6a242d1abf2c4405eda743a8b3925d75717c4&=&format=webp&quality=lossless&width=550&height=309',
                vehiclehash = 'bison', icon = 'fas fa-car', gas = math.random(30, 70), price = 1500,
            },
            [3] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1127979309139775530/1211415298280923146/surge.png?ex=65ee1d6a&is=65dba86a&hm=91af0b9ba1b9146db48646244d0e08599a330d45d186e292efb0680bcb89f6d4&',
                vehiclehash = 'surge', icon = 'fas fa-car', gas = math.random(30, 70), price = 900,
            },
            [4] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1127979309139775530/1211415838087843840/gta-mag-maibatsu-sanchez-livery-406178.png?ex=65ee1dea&is=65dba8ea&hm=a65abacbb6e4ffdaa3318d56e8e8e7148cd593f5b3cd1235aa8a1520de5d61ab&',
                vehiclehash = 'sanchez', icon = 'fas fa-car', gas = math.random(30, 70), price = 800,
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
            sprite = 225, color = 46, shortrange = true, scale = 0.75, name = 'Aluguel de veículos',
        },
        ped = {
            hash = `s_m_y_valet_01`,
            coords = vector4(1105.29, 2659.03, 38.14, 358.38),
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            icon = 'fas fa-car',
        },
        vehicles = {
            [1] = {
                vehicleimage = 'https://media.discordapp.net/attachments/1127979309139775530/1211415472650715157/latest.png?ex=65ee1d93&is=65dba893&hm=be79f20406518999e3256203856bb9a1e9d6c9e53ed9e10ed8a75f41aef02645&=&format=webp&quality=lossless&width=550&height=309', -- Image of the vehicle 
                vehiclehash = 'sultan', -- Name of the vehicle (must be a vehicle from within the shared vehicles.lua in core)
                icon = 'fas fa-car',
                gas = math.random(30, 70), -- Random amount of gas the vehicle will have 
                price = 500, -- Price of the vehicle to rent
            },
            [2] = {
                vehicleimage = 'https://media.discordapp.net/attachments/1127979309139775530/1211415650824884244/latest.png?ex=65ee1dbe&is=65dba8be&hm=54d465f57dcf17cca5fc7a476dd6a242d1abf2c4405eda743a8b3925d75717c4&=&format=webp&quality=lossless&width=550&height=309',
                vehiclehash = 'bison', icon = 'fas fa-car', gas = math.random(30, 70), price = 1500,
            },
            [3] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1127979309139775530/1211415298280923146/surge.png?ex=65ee1d6a&is=65dba86a&hm=91af0b9ba1b9146db48646244d0e08599a330d45d186e292efb0680bcb89f6d4&',
                vehiclehash = 'surge', icon = 'fas fa-car', gas = math.random(30, 70), price = 900,
            },
            [4] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1127979309139775530/1211415838087843840/gta-mag-maibatsu-sanchez-livery-406178.png?ex=65ee1dea&is=65dba8ea&hm=a65abacbb6e4ffdaa3318d56e8e8e7148cd593f5b3cd1235aa8a1520de5d61ab&',
                vehiclehash = 'sanchez', icon = 'fas fa-car', gas = math.random(30, 70), price = 800,
            },
        },
        spawnpoints = {
            vector4(1105.53, 2663.66, 37.51, 359.01),
            vector4(1101.73, 2663.55, 37.51, 0.13),
            vector4(1098.34, 2664.05, 37.51, 0.15),
        },
    },
    

    -- To add more locations simply copy the array above an simply change the number and the information within
}