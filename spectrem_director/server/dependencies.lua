SpectremDirector.Features = {}
CreateThread(function()
  Wait(0)
  for feature, resource in pairs(Config.resources) do
    local started=GetResourceState(resource)=='started'; SpectremDirector.Features[feature]=started
    print(('[spectrem_director] %s: %s'):format(resource, started and '^2available^7' or '^3missing; related feature disabled^7'))
  end
end)
