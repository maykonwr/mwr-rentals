-- Receber comando para mudar o clima
RegisterNetEvent('auto-rain:setWeather', function(weatherType)
    SetWeatherTypeNowPersist(weatherType)
    SetRainLevel(1.0)
    
    -- Garantir que a chuva seja visível
    if weatherType == 'RAIN' or weatherType == 'THUNDER' then
        SetRainLevel(0.8)
    end
end)