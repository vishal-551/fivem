--- Idempotent event registration for local and networked resource events.
CineDirector = CineDirector or {}
CineDirector.Events = CineDirector.Events or {}
CineDirector.EventManager = { registered = {} }
local Manager = CineDirector.EventManager

--- Registers an event exactly once.
---@param name string
---@param handler fun(...)
---@param networked? boolean
---@return boolean registered
function Manager.register(name, handler, networked)
    assert(type(name) == 'string' and type(handler) == 'function', 'Invalid event registration')
    if Manager.registered[name] then
        CineDirector.Logger.warning('Duplicate event registration prevented', { event = name })
        return false
    end
    if networked then RegisterNetEvent(name) end
    AddEventHandler(name, handler)
    Manager.registered[name] = true
    return true
end
