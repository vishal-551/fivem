--- Startup dependency verification and concise status report.
local required = { Config.Core.resources.oxmysql, Config.Core.resources.oxlib, Config.Core.resources.qbcore }
CreateThread(function()
    Wait(0)
    local missing = {}
    for _, resource in ipairs(required) do
        local state = GetResourceState(resource)
        if state ~= 'started' then missing[#missing + 1] = resource; print(('[CineDirector] ^1WARNING^7 dependency %s is %s'):format(resource, state)) end
    end
    if #missing == 0 then print('[CineDirector] Core startup report: oxmysql, ox_lib, qb-core available.') else print(('[CineDirector] ^1Core started with %d missing dependency/dependencies.^7'):format(#missing)) end
    CineDirector.Database.ready = GetResourceState(Config.Core.resources.oxmysql) == 'started'
end)
