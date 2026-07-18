--- User-local animation favourites are persisted through the project API database service.
SpectremDirector.Favorites = { animation = {} }
function SpectremDirector.Favorites.has(key) return SpectremDirector.Favorites.animation[key] == true end
function SpectremDirector.Favorites.toggle(key)
    local enabled = not SpectremDirector.Favorites.has(key)
    SpectremDirector.Favorites.animation[key] = enabled
    local ok, result = SpectremDirector.Rpc.await('favorites:set', { type = 'animation', key = key, enabled = enabled })
    if not ok then SpectremDirector.Favorites.animation[key] = not enabled; return false, result end
    return true, enabled
end
