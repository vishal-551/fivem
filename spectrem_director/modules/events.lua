--- Registers an event once, preventing accidental duplicate network handlers.
SpectremDirector.EventBus = { handlers = {} }
function SpectremDirector.EventBus.register(name, handler, networked)
  assert(type(name)=='string' and type(handler)=='function', 'Invalid event registration')
  if SpectremDirector.EventBus.handlers[name] then return false end
  if networked then RegisterNetEvent(name) end
  AddEventHandler(name, handler); SpectremDirector.EventBus.handlers[name]=true; return true
end
