local Repository = {}
function Repository.identifier(source)
    local core = SpectremDirector.Features.core and exports['qb-core']:GetCoreObject()
    local player = core and core.Functions.GetPlayer(source)
    return player and player.PlayerData.citizenid or ('license:' .. (GetPlayerIdentifierByType(source, 'license') or tostring(source)))
end
function Repository.list(owner) return SpectremDirector.Database.all('spectrem_director_projects', { owner_identifier = owner }) end
function Repository.load(owner, id) return SpectremDirector.Database.find('spectrem_director_projects', { id = id, owner_identifier = owner }) end
function Repository.save(owner, id, name, payload)
    if id then return SpectremDirector.Database.update('spectrem_director_projects', { name = name, payload = json.encode(payload) }, { id = id, owner_identifier = owner }) end
    return SpectremDirector.Database.create('spectrem_director_projects', { owner_identifier = owner, name = name, payload = json.encode(payload) })
end
function Repository.favorite(owner, favoriteType, key, enabled)
    if enabled then return SpectremDirector.Database.create('spectrem_director_favorites', { owner_identifier=owner, favorite_type=favoriteType, favorite_key=key }) end
    return SpectremDirector.Database.delete('spectrem_director_favorites', { owner_identifier=owner, favorite_type=favoriteType, favorite_key=key })
end
SpectremDirector.Repository = Repository
