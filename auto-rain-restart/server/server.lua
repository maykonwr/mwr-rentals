local rainActivated = false
local lastCheckTime = 0

-- Função para obter o próximo horário de restart
local function getNextRestartTime()
    local currentTime = os.date("*t")
    local currentMinutes = currentTime.hour * 60 + currentTime.min
    
    local nextRestart = nil
    local minDiff = 1440 -- 24 horas em minutos
    
    for _, timeStr in ipairs(Config.RestartTimes) do
        local hour, min = timeStr:match("(%d+):(%d+)")
        local restartMinutes = tonumber(hour) * 60 + tonumber(min)
        
        local diff = restartMinutes - currentMinutes
        if diff < 0 then
            diff = diff + 1440 -- Adiciona 24h se já passou hoje
        end
        
        if diff < minDiff then
            minDiff = diff
            nextRestart = {
                minutes = restartMinutes,
                diff = diff
            }
        end
    end
    
    return nextRestart
end

-- Função para ativar a chuva
local function activateRain()
    if rainActivated then return end
    
    local weather = Config.SelectedWeather
    if weather == 'random' then
        weather = Config.RainWeathers[math.random(#Config.RainWeathers)]
    end
    
    TriggerClientEvent('auto-rain:setWeather', -1, weather)
    rainActivated = true
    
    if Config.Debug then
        print('[AUTO-RAIN] Chuva ativada: ' .. weather)
    end
    
    -- Notificar todos os jogadores
    TriggerClientEvent('chat:addMessage', -1, {
        color = {0, 150, 255},
        multiline = true,
        args = {"[SISTEMA]", "O clima mudou para chuva - Servidor reiniciará em breve!"}
    })
end

-- Thread principal de verificação
CreateThread(function()
    while true do
        Wait(30000) -- Verifica a cada 30 segundos
        
        local nextRestart = getNextRestartTime()
        if nextRestart then
            local minutesLeft = nextRestart.diff
            
            if Config.Debug and os.time() - lastCheckTime > 300 then -- Debug a cada 5 minutos
                print('[AUTO-RAIN] Próximo restart em: ' .. minutesLeft .. ' minutos')
                lastCheckTime = os.time()
            end
            
            -- Ativar chuva se faltam X minutos para o restart
            if minutesLeft <= Config.MinutesBeforeRestart and not rainActivated then
                activateRain()
            end
            
            -- Reset da flag após o restart (quando o tempo volta a ser maior)
            if minutesLeft > Config.MinutesBeforeRestart and rainActivated then
                rainActivated = false
                if Config.Debug then
                    print('[AUTO-RAIN] Sistema resetado após restart')
                end
            end
        end
    end
end)

-- Comando para testar manualmente (admin)
RegisterCommand('testrain', function(source, args, rawCommand)
    if source == 0 then -- Console
        activateRain()
        print('[AUTO-RAIN] Chuva ativada manualmente via console')
    else
        -- Verificar se é admin (adapte conforme seu sistema de permissões)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player and QBCore.Functions.HasPermission(source, 'admin') then
            activateRain()
            TriggerClientEvent('chat:addMessage', source, {
                color = {0, 255, 0},
                args = {"[ADMIN]", "Chuva ativada manualmente!"}
            })
        end
    end
end, false)

-- Comando para verificar próximo restart
RegisterCommand('nextrestart', function(source, args, rawCommand)
    local nextRestart = getNextRestartTime()
    if nextRestart then
        local message = 'Próximo restart em: ' .. nextRestart.diff .. ' minutos'
        
        if source == 0 then
            print('[AUTO-RAIN] ' .. message)
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 255, 0},
                args = {"[INFO]", message}
            })
        end
    end
end, false)