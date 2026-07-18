--- Owner-scoped animation favourite callbacks backed by oxmysql.
local QBCore=exports['qb-core']:GetCoreObject()
local function identifier(source) local player=QBCore.Functions.GetPlayer(source);return player and player.PlayerData.citizenid or nil end
local function valid(payload) return type(payload)=='table' and type(payload.dictionary)=='string' and #payload.dictionary<=128 and type(payload.animation)=='string' and #payload.animation<=128 end
CineDirector.Callbacks.registerServer('GetFavorites',function(source)
    local id=identifier(source);if not id then return {} end
    return MySQL.query.await('SELECT dictionary, animation FROM director_animation_favorites WHERE identifier = ? ORDER BY updated_at DESC',{id})
end)
CineDirector.Callbacks.registerServer('SaveFavorite',function(source,payload)
    if not valid(payload) then error('Invalid animation favorite') end;local id=identifier(source);if not id then error('Player unavailable') end
    local count=MySQL.scalar.await('SELECT COUNT(*) FROM director_animation_favorites WHERE identifier = ?',{id});if count>=Config.Animation.favoriteLimit then error('Favorite limit reached') end
    return MySQL.insert.await('INSERT IGNORE INTO director_animation_favorites (identifier, dictionary, animation) VALUES (?, ?, ?)',{id,payload.dictionary,payload.animation})
end)
CineDirector.Callbacks.registerServer('DeleteFavorite',function(source,payload)
    if not valid(payload) then error('Invalid animation favorite') end;local id=identifier(source);if not id then error('Player unavailable') end
    return MySQL.update.await('DELETE FROM director_animation_favorites WHERE identifier = ? AND dictionary = ? AND animation = ?',{id,payload.dictionary,payload.animation})
end)
CineDirector.EventManager.register('cinedirector:animation:history',function(dictionary,animation)
    local source=source; if type(dictionary)~='string' or #dictionary>128 or type(animation)~='string' or #animation>128 then return end
    local id=identifier(source);if id then MySQL.insert.await('INSERT INTO director_animation_history (identifier, dictionary, animation) VALUES (?, ?, ?)',{id,dictionary,animation}) end
end,true)
