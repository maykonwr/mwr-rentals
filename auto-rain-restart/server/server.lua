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

-- Função para ativar a chuva silenciosamente
local function activateRain()
    if rainActivated then return end
    
    local weather = Config.SelectedWeather
    if weather == 'random' then
        weather = Config.RainWeathers[math.random(#Config.RainWeathers)]
    end
    
    TriggerClientEvent('auto-rain:setWeather', -1, weather)
    rainActivated = true
    
    if Config.Debug then
        print('[AUTO-RAIN] Chuva ativada silenciosamente: ' .. weather)
    end
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

-- Comando para testar manualmente (admin/console apenas)
RegisterCommand('testrain', function(source, args, rawCommand)
    if source == 0 then -- Console apenas
        activateRain()
        print('[AUTO-RAIN] Chuva ativada manualmente via console')
    end
end, false)

-- Comando para verificar próximo restart (console apenas)
RegisterCommand('nextrestart', function(source, args, rawCommand)
    if source == 0 then -- Console apenas
        local nextRestart = getNextRestartTime()
        if nextRestart then
            print('[AUTO-RAIN] Próximo restart em: ' .. nextRestart.diff .. ' minutos')
        end
    end
end, false)