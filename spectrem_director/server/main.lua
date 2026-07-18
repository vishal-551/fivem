local Repository = SpectremDirector.Repository
local function requireDirector(source) if not SpectremDirector.Permissions.has(source, 'director') then error('Director role required') end end
SpectremDirector.Rpc.register('project:save', function(source, data)
    requireDirector(source); assert(type(data.payload) == 'table', 'Invalid project payload')
    local id, reason = Repository.save(Repository.identifier(source), tonumber(data.id), SpectremDirector.Util.name(data.name, 'Untitled'), data.payload)
    if not id then SpectremDirector.Log.error('Project save failed', { source=source, error=reason }); error('Project could not be saved') end
    return tonumber(data.id) or id
end)
SpectremDirector.Rpc.register('project:list', function(source) return Repository.list(Repository.identifier(source)) end)
SpectremDirector.Rpc.register('project:load', function(source, data)
    local row = Repository.load(Repository.identifier(source), tonumber(data.id)); if not row then error('Project not found') end
    row.payload = json.decode(row.payload); return row
end)
SpectremDirector.Rpc.register('favorites:set', function(source, data)
    requireDirector(source); assert(data.type == 'animation' and type(data.key) == 'string', 'Invalid favourite')
    local result, reason = Repository.favorite(Repository.identifier(source), data.type, data.key:sub(1,128), data.enabled == true)
    if not result then error(reason or 'Favourite update failed') end; return true
end)
