--- Expiring namespaced in-memory cache. Entries are only retained while actively read.
CineDirector = CineDirector or {}
CineDirector.Cache = { stores = {} }
local Cache = CineDirector.Cache

--- Retrieves or creates a named cache namespace.
---@param name string
---@return table
function Cache.namespace(name)
    if not Cache.stores[name] then Cache.stores[name] = {} end
    return Cache.stores[name]
end
--- Stores a value for a bounded lifetime.
function Cache.set(namespace, key, value, ttl)
    Cache.namespace(namespace)[tostring(key)] = { value = value, expires = GetGameTimer() + (ttl or CineDirector.Config.get('Core.cache.ttlSeconds', 300)) * 1000 }
end
--- Gets a value, removing it when expired.
function Cache.get(namespace, key)
    local entry = Cache.namespace(namespace)[tostring(key)]
    if not entry or entry.expires <= GetGameTimer() then Cache.namespace(namespace)[tostring(key)] = nil; return nil end
    return entry.value
end
--- Invalidates one entry or a complete namespace.
function Cache.clear(namespace, key)
    if key == nil then Cache.stores[namespace] = {} else Cache.namespace(namespace)[tostring(key)] = nil end
end
--- Removes all expired entries. Call this from a low-frequency scheduler.
function Cache.sweep()
    local now = GetGameTimer()
    for _, store in pairs(Cache.stores) do for key, entry in pairs(store) do if entry.expires <= now then store[key] = nil end end end
end
function Cache.player(key) return Cache.get('players', key) end
function Cache.scene(key) return Cache.get('scenes', key) end
function Cache.animation(key) return Cache.get('animations', key) end
function Cache.weather(key) return Cache.get('weather', key) end
function Cache.camera(key) return Cache.get('cameras', key) end
