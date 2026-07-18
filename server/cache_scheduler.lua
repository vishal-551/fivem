--- Low-frequency cache cleanup; no busy loop is created.
CreateThread(function()
    while true do
        Wait(CineDirector.Config.get('Core.cache.sweepSeconds', 60) * 1000)
        CineDirector.Cache.sweep()
    end
end)
