--- Role and capability resolution. ACE grants may elevate persisted roles.
CineDirector = CineDirector or {}
CineDirector.Permissions = CineDirector.Permissions or {}
local Permissions = CineDirector.Permissions
Permissions.roles = { user = 1, director = 2, moderator = 3, admin = 4, owner = 5 }

--- Returns the highest role available to a player.
---@param source number
---@return string
function Permissions.role(source)
    local prefix = CineDirector.Config.get('Core.permissions.acePrefix', 'cinedirector.')
    local highest, selected = 0, CineDirector.Config.get('Core.permissions.defaultRole', 'user')
    for role, rank in pairs(Permissions.roles) do
        if rank > highest and IsPlayerAceAllowed(source, prefix .. role) then highest, selected = rank, role end
    end
    return selected
end
--- Checks whether a player has at least the requested role.
---@param source number
---@param required string
---@return boolean
function Permissions.has(source, required)
    return (Permissions.roles[Permissions.role(source)] or 0) >= (Permissions.roles[required] or math.huge)
end
