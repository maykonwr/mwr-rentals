Config = {}

-- Tempo em minutos antes do restart para ativar a chuva
Config.MinutesBeforeRestart = 10

-- Tipos de clima chuvoso disponíveis
Config.RainWeathers = {
    'RAIN',
    'THUNDER', 
    'CLEARING'
}

-- Clima escolhido (ou 'random' para aleatório)
Config.SelectedWeather = 'RAIN' -- ou 'random'

-- Ativar debug no console
Config.Debug = true

-- Horários de restart do servidor (formato 24h)
-- Adicione todos os horários que seu servidor reinicia
Config.RestartTimes = {
    '06:00',
    '12:00', 
    '18:00',
    '00:00'
}