--- Promise-aware client callback client and response dispatcher.
CineDirector = CineDirector or {}
CineDirector.Callbacks = CineDirector.Callbacks or { server = {}, client = {}, sequence = 0, pending = {} }
local Callbacks = CineDirector.Callbacks
Callbacks.pending = Callbacks.pending or {}

--- Calls a server callback and awaits its response.
---@param name string
---@param payload any
---@return boolean, any
function Callbacks.awaitServer(name, payload)
    Callbacks.sequence = Callbacks.sequence + 1
    local id = ('%s:%s'):format(GetPlayerServerId(PlayerId()), Callbacks.sequence)
    local promise = promise.new(); Callbacks.pending[id] = promise
    TriggerServerEvent('cinedirector:core:callback:server', id, name, payload)
    local response = Citizen.Await(promise)
    return response.ok, response.result
end
CineDirector.EventManager.register('cinedirector:core:callback:response', function(id, ok, result)
    local pending = Callbacks.pending[id]; if not pending then return end
    Callbacks.pending[id] = nil; pending:resolve({ ok = ok, result = result })
end, true)
