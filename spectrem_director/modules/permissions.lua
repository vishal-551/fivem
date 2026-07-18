SpectremDirector.Permissions = {}
function SpectremDirector.Permissions.role(source)
  for role,rank in pairs(Config.roles) do if IsPlayerAceAllowed(source,'spectrem_director.'..role) then return role,rank end end
  return 'user',Config.roles.user
end
function SpectremDirector.Permissions.has(source,required) local _,rank=SpectremDirector.Permissions.role(source); return rank >= (Config.roles[required] or math.huge) end
