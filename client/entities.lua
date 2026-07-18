local C, U = CineDirector.Client, CineDirector.Util
C.Entities = {}
local function model(hash) RequestModel(hash); while not HasModelLoaded(hash) do Wait(0) end end
function C.Entities.spawn(kind, data)
  local limit = kind == 'actor' and Config.MaxActors or kind == 'prop' and Config.MaxProps or Config.MaxVehicles
  local count = 0; for _, existing in pairs(C.entities) do if existing.type == kind then count = count + 1 end end
  if count >= limit then return nil, ('Maximum %s count reached'):format(kind) end
  local hash = joaat(data.model); if not IsModelInCdimage(hash) then return nil, 'Invalid model' end
  model(hash); C.pushUndo(); local pos = data.position and U.tableToVec(data.position) or GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0
  local entity = kind == 'actor' and CreatePed(4, hash, pos.x, pos.y, pos.z, data.heading or 0.0, false, true) or kind == 'vehicle' and CreateVehicle(hash, pos.x, pos.y, pos.z, data.heading or 0.0, false, true) or CreateObject(hash, pos.x, pos.y, pos.z, false, true, false)
  SetEntityAsMissionEntity(entity, true, true); PlaceObjectOnGroundProperly(entity)
  local record = { id = ('%s_%s'):format(kind, entity), handle = entity, type = kind, model = data.model, name = data.name or kind, heading = data.heading or 0.0 }
  C.entities[record.id] = record; return record
end
function C.Entities.delete(id) local r = C.entities[id]; if r and DoesEntityExist(r.handle) then C.pushUndo(); DeleteEntity(r.handle) end; C.entities[id] = nil end
function C.Entities.clone(id) local r = C.entities[id]; if not r then return end; local p = GetEntityCoords(r.handle); return C.Entities.spawn(r.type, { model = r.model, name = r.name .. ' Copy', position = U.vecToTable(p + vector3(1,0,0)), heading = GetEntityHeading(r.handle) }) end
function C.Entities.serialize()
  local out = {}; for id,r in pairs(C.entities) do if DoesEntityExist(r.handle) then local p = GetEntityCoords(r.handle); out[#out+1] = { id=id,type=r.type,model=r.model,name=r.name,position=U.vecToTable(p),heading=GetEntityHeading(r.handle) } end end; return out
end
function C.Entities.clear() for id in pairs(C.entities) do C.Entities.delete(id) end end
