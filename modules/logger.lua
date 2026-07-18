--- Structured logging with optional asynchronous database persistence.
CineDirector = CineDirector or {}
CineDirector.Logger = {}
local Logger = CineDirector.Logger
local levels = { DEBUG = 1, INFO = 2, WARNING = 3, ERROR = 4 }

--- Writes a log entry to console and, on the server, to the database without blocking callers.
---@param level 'DEBUG'|'INFO'|'WARNING'|'ERROR'
---@param message string
---@param context? table
function Logger.write(level, message, context)
    level = levels[level] and level or 'INFO'
    if level == 'DEBUG' and not CineDirector.Config.get('Core.debug', false) then return end
    local encoded = context and json.encode(context) or '{}'
    print(('[CineDirector][%s] %s'):format(level, tostring(message)))
    if IsDuplicityVersion() and CineDirector.Database and CineDirector.Database.ready then
        CreateThread(function()
            CineDirector.Database.Create('logs', { level = level, message = tostring(message), context = encoded })
        end)
    end
end
for name in pairs(levels) do Logger[name:lower()] = function(message, context) Logger.write(name, message, context) end end
