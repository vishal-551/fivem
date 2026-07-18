--- Client favourite state backed by server callbacks; no database calls occur client-side.
CineDirector.AnimationFavorites = { values = {}, loaded = false }
local Favorites=CineDirector.AnimationFavorites
function Favorites.Load()
    local ok,rows=CineDirector.Callbacks.awaitServer('GetFavorites',{});if not ok then return false,rows end
    Favorites.values={};for _,row in ipairs(rows) do Favorites.values[row.dictionary..':'..row.animation]=true end;Favorites.loaded=true;return true
end
function Favorites.Add(key)
    local entry=CineDirector.AnimationRegistry.Get(key);if not entry then return false,'Unknown animation' end
    local ok,result=CineDirector.Callbacks.awaitServer('SaveFavorite',{dictionary=entry.dictionary,animation=entry.clip});if ok then Favorites.values[key]=true end;return ok,result
end
function Favorites.Remove(key)
    local entry=CineDirector.AnimationRegistry.Get(key);if not entry then return false,'Unknown animation' end
    local ok,result=CineDirector.Callbacks.awaitServer('DeleteFavorite',{dictionary=entry.dictionary,animation=entry.clip});if ok then Favorites.values[key]=nil end;return ok,result
end
exports('AddFavoriteAnimation',Favorites.Add)
exports('RemoveFavoriteAnimation',Favorites.Remove)
