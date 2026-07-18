--- Shared configuration accessor and validation helpers.
CineDirector = CineDirector or {}
CineDirector.Config = {}

--- Returns a nested configuration value without raising for missing optional keys.
---@param path string Dot-separated configuration path.
---@param fallback any Value returned when the path does not exist.
---@return any
function CineDirector.Config.get(path, fallback)
    local value = Config
    for key in path:gmatch('[^.]+') do
        value = type(value) == 'table' and value[key] or nil
        if value == nil then return fallback end
    end
    return value
end

--- Validates core configuration once during startup.
---@return boolean valid
function CineDirector.Config.validate()
    local core = Config.Core
    if type(core) ~= 'table' or type(core.resources) ~= 'table' then
        print('^1[CineDirector]^7 Missing Config.Core configuration.')
        return false
    end
    return true
end
