SpectremDirector.Features={}
CreateThread(function() Wait(0); for feature,resource in pairs(Config.resources) do SpectremDirector.Features[feature]=GetResourceState(resource)=='started'; if not SpectremDirector.Features[feature] then print(('[spectrem_director] %s unavailable; feature disabled.'):format(resource)) end end end)
