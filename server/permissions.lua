CineDirector.Permissions = {}
function CineDirector.Permissions.role(source)
  if IsPlayerAceAllowed(source, Config.RoleAces.admin) then return 'admin' end
  if IsPlayerAceAllowed(source, Config.RoleAces.moderator) then return 'moderator' end
  return 'user'
end
function CineDirector.Permissions.canUse(source) return IsPlayerAceAllowed(source, Config.RequiredAce) or CineDirector.Permissions.role(source) ~= 'user' end
function CineDirector.Permissions.canEdit(source, owner) return CineDirector.Permissions.role(source) ~= 'user' or tostring(source) == tostring(owner) end
