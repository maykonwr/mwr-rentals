Config = Config or {}

Config.Inventory = 'ox' -- ox inventory is the only (support for more inventories in the future)
Config.PaymentType = 'cash' -- cash / bank used for when returning vehicles
Config.FuelScript = 'cdn-fuel' -- cdn-fuel / ps-fuel / lj-fuel / LegacyFuel
Config.MoneyReturn = 0.5 -- this is 50% money return once the rental vehicle is returned
Config.Locations = {
    [1] = {
        blip = {
            sprite = 225, color = 46, shortrange = true, scale = 0.75, name = 'Aluguel de veículos',
        },
        ped = {
            hash = `s_m_y_valet_01`,
            coords = vector4(-58.15, 163.78, 81.49, 165.91),
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            icon = 'fas fa-car',
        },
        vehicles = {
            [1] = {
                vehicleimage = 'https://media.discordapp.net/attachments/1127979309139775530/1211415472650715157/latest.png?ex=65ee1d93&is=65dba893&hm=be79f20406518999e3256203856bb9a1e9d6c9e53ed9e10ed8a75f41aef02645&=&format=webp&quality=lossless&width=550&height=309', -- Image of the vehicle 
                vehiclehash = 'sultan', -- Name of the vehicle (must be a vehicle from within the shared vehicles.lua in core)
                icon = 'fas fa-car',
                gas = math.random(30, 100), -- Random amount of gas the vehicle will have 
                price = 500, -- Price of the vehicle to rent
            },
            [2] = {
                vehicleimage = 'https://media.discordapp.net/attachments/1127979309139775530/1211415650824884244/latest.png?ex=65ee1dbe&is=65dba8be&hm=54d465f57dcf17cca5fc7a476dd6a242d1abf2c4405eda743a8b3925d75717c4&=&format=webp&quality=lossless&width=550&height=309',
                vehiclehash = 'bison', icon = 'fas fa-car', gas = math.random(30, 100), price = 1500,
            },
            [3] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1127979309139775530/1211415298280923146/surge.png?ex=65ee1d6a&is=65dba86a&hm=91af0b9ba1b9146db48646244d0e08599a330d45d186e292efb0680bcb89f6d4&',
                vehiclehash = 'surge', icon = 'fas fa-car', gas = math.random(30, 100), price = 900,
            },
            [4] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1127979309139775530/1211415838087843840/gta-mag-maibatsu-sanchez-livery-406178.png?ex=65ee1dea&is=65dba8ea&hm=a65abacbb6e4ffdaa3318d56e8e8e7148cd593f5b3cd1235aa8a1520de5d61ab&',
                vehiclehash = 'sanchez', icon = 'fas fa-car', gas = math.random(30, 100), price = 800,
            },
        },
        spawnpoints = {
            vector4(-61.62, 165.47, 80.89, 123.66),
            vector4(-59.0, 159.47, 80.89, 124.42),
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
                vehiclehash = 'sultan', icon = 'fas fa-car', gas = math.random(30, 100), price = 500,
            },
            [2] = {
                vehicleimage = 'https://media.discordapp.net/attachments/1127979309139775530/1211415650824884244/latest.png?ex=65ee1dbe&is=65dba8be&hm=54d465f57dcf17cca5fc7a476dd6a242d1abf2c4405eda743a8b3925d75717c4&=&format=webp&quality=lossless&width=550&height=309',
                vehiclehash = 'bison', icon = 'fas fa-car', gas = math.random(30, 100), price = 1500,
            },
            [3] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1127979309139775530/1211415298280923146/surge.png?ex=65ee1d6a&is=65dba86a&hm=91af0b9ba1b9146db48646244d0e08599a330d45d186e292efb0680bcb89f6d4&',
                vehiclehash = 'surge', icon = 'fas fa-car', gas = math.random(30, 100), price = 900,
            },
            [4] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1127979309139775530/1211415838087843840/gta-mag-maibatsu-sanchez-livery-406178.png?ex=65ee1dea&is=65dba8ea&hm=a65abacbb6e4ffdaa3318d56e8e8e7148cd593f5b3cd1235aa8a1520de5d61ab&',
                vehiclehash = 'sanchez', icon = 'fas fa-car', gas = math.random(30, 100), price = 800,
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
            sprite = 423, color = 46, shortrange = true, scale = 0.75, name = 'Aluguel de avião',
        },
        ped = {
            hash = `s_m_m_pilot_02`,
            coords = vector4(-1268.79, -3423.3, 13.94, 358.82),
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            icon = 'fas fa-plane',
        },
        vehicles = {
            [1] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1083210781845360663/1210716125764128768/alpha-z1.png?ex=65eb9242&is=65d91d42&hm=bbec6cc9fecb7b34df938ddab9913bbbc9e16e6b0c370d12f19edd7dc9f1008c&',
                vehiclehash = 'alphaz1', icon = 'fas fa-plane', gas = math.random(30, 100), price = 15000,
            },
            [2] = {
                vehicleimage = 'https://cdn.discordapp.com/attachments/1083210781845360663/1210716301006348339/Z.png?ex=65eb926c&is=65d91d6c&hm=785509ca094b5fa7b466613224e85738a2a92e4a36e8d79a217f9a795379437f&',
                vehiclehash = 'dodo', icon = 'fas fa-plane', gas = math.random(30, 100), price = 50000,
            },
        },
        spawnpoints = {
            vector4(-1270.57, -3398.07, 14.74, 332.19),
            vector4(-1288.35, -3391.21, 13.69, 326.93),
            vector4(-1279.5, -3377.22, 13.69, 329.43),
            vector4(-1267.69, -3383.99, 13.69, 330.08),
        },
    },

    -- To add more locations simply copy the array above an simply change the number and the information within
}