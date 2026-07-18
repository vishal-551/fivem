local QBCore = exports['qb-core']:GetCoreObject()
local function identifier(src) local p=QBCore.Functions.GetPlayer(src); return p and p.PlayerData.citizenid or ('src:'..src) end
local function allowed(src) if CineDirector.Permissions.canUse(src) then return true end; TriggerClientEvent(CineDirector.Events.notify,src,'You do not have CineDirector access.','error'); return false end
RegisterNetEvent(CineDirector.Events.save, function(id,name,payload,autosave)
  local src=source; if not allowed(src) or type(payload)~='table' then return end
  local owner=identifier(src); if id then local current=CineDirector.Repository.loadProject(owner,id); if not current then return end; if not autosave then CineDirector.Repository.backup(id,json.decode(current.payload)) end end
  local saved=CineDirector.Repository.saveProject(owner,id,name,payload); TriggerClientEvent(CineDirector.Events.notify,src,autosave and 'Autosaved.' or 'Project saved.','success'); TriggerClientEvent('cinedirector:client:projectSaved',src,saved)
end)
RegisterNetEvent(CineDirector.Events.load, function(id)
  local src=source; if not allowed(src) then return end; local row=CineDirector.Repository.loadProject(identifier(src),id)
  if row then row.payload=json.decode(row.payload); TriggerClientEvent('cinedirector:client:projectLoaded',src,row) end
end)
lib.callback.register('cinedirector:server:listProjects', function(src) if not allowed(src) then return {} end return MySQL.query.await('SELECT id,name,updated_at FROM cinedirector_projects WHERE owner_identifier=? ORDER BY updated_at DESC',{identifier(src)}) end)
