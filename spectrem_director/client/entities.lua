--- Local cinematic entities. They are deliberately non-networked previews.
SpectremDirector.Entities = { records = {} }
local Entities = SpectremDirector.Entities
local function count(kind)
    local total = 0
    for _, record in pairs(Entities.records) do if record.type == kind then total = total + 1 end end
    return total
end
local function requestModel(name)
    local hash = joaat(name)
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then return nil, 'Unknown model' end
    RequestModel(hash)
    local deadline = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < deadline do Wait(0) end
    if not HasModelLoaded(hash) then return nil, 'Model load timed out' end
    return hash
end
--- Spawns an actor, prop, or vehicle in the director's local workspace.
function Entities.spawn(kind, data)
    if not SpectremDirector.Types[kind] then return nil, 'Invalid entity type' end
    local limit = Config.limits[kind .. 's']
    if count(kind) >= limit then return nil, ('Maximum %s count reached'):format(kind) end
    local hash, errorMessage = requestModel(data.model)
    if not hash then return nil, errorMessage end
    local position = data.position and SpectremDirector.Util.vector(data.position) or GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0
    local heading = tonumber(data.heading) or GetEntityHeading(PlayerPedId())
    local handle = kind == 'actor' and CreatePed(4, hash, position.x, position.y, position.z, heading, false, true)
        or kind == 'vehicle' and CreateVehicle(hash, position.x, position.y, position.z, heading, false, true)
        or CreateObject(hash, position.x, position.y, position.z, false, false, false)
    SetEntityAsMissionEntity(handle, true, true)
    if kind == 'prop' then PlaceObjectOnGroundProperly(handle) end
    local id = ('%s:%d'):format(kind, handle)
    Entities.records[id] = { id = id, handle = handle, type = kind, model = data.model, name = SpectremDirector.Util.name(data.name, kind) }
    SetModelAsNoLongerNeeded(hash)
    return Entities.records[id]
end
function Entities.remove(id) local record=Entities.records[id]; if record and DoesEntityExist(record.handle) then DeleteEntity(record.handle) end; Entities.records[id]=nil end
function Entities.clear() for id in pairs(Entities.records) do Entities.remove(id) end end
function Entities.serialize() local output={}; for _,record in pairs(Entities.records) do if DoesEntityExist(record.handle) then output[#output+1]={type=record.type,model=record.model,name=record.name,position=SpectremDirector.Util.table(GetEntityCoords(record.handle)),heading=GetEntityHeading(record.handle)} end end; return output end
function Entities.restore(records) Entities.clear(); for _,record in ipairs(records or {}) do Entities.spawn(record.type,record) end end
AddEventHandler('onResourceStop',function(resource) if resource==GetCurrentResourceName() then Entities.clear() end end)
