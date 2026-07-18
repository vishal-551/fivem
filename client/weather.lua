local C = CineDirector.Client
function C.applyWeather(data) C.weather=data; SetWeatherTypeOvertimePersist(data.weather or 'CLEAR', 0.5); SetWeatherTypeNowPersist(data.weather or 'CLEAR'); NetworkOverrideClockTime(data.hour or 12,data.minute or 0,0); SetBlackout(data.blackout or false) end
