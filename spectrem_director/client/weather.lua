SpectremDirector.Weather={weather='CLEAR',hour=12,minute=0}
function SpectremDirector.Weather.apply(data) SpectremDirector.Weather=data;if SpectremDirector.Features.weather then exports['Renewed-Weathersync']:setWeather(data.weather) else SetWeatherTypeNowPersist(data.weather) end;NetworkOverrideClockTime(data.hour,data.minute,0) end
