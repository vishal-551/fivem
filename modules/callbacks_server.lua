--- Promise-aware server callbacks invoked by clients through one controlled event.
CineDirector = CineDirector or {}
CineDirector.Callbacks = CineDirector.Callbacks or { server = {}, client = {}, sequence = 0 }
local Callbacks = CineDirector.Callbacks

--- Registers a server callback once.
function Callbacks.registerServer(name, handler)
    assert(type(handler) == 'function', 'Callback handler must be a function')
    assert(not Callbacks.server[name], ('Duplicate callback: %s'):format(name))
    Callbacks.server[name] = handler
end
CineDirector.EventManager.register('cinedirector:core:callback:server', function(requestId, name, payload)
    local source = source
    local handler = Callbacks.server[name]
    if not handler then return TriggerClientEvent('cinedirector:core:callback:response', source, requestId, false, 'Unknown callback') end
    local ok, result = xpcall(function() return handler(source, payload) end, debug.traceback)
    if not ok then CineDirector.Logger.error('Server callback failed', { callback = name, error = result }); result = 'Internal callback error' end
    TriggerClientEvent('cinedirector:core:callback:response', source, requestId, ok, result)
end, true)
