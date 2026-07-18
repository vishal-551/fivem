--- Dictionary cache. Only loading requests wait; cleanup runs when the framework is used.
CineDirector.AnimationCache = { assets = {} }
local Cache=CineDirector.AnimationCache
function Cache.Acquire(dictionary)
    local asset=Cache.assets[dictionary]; if asset and HasAnimDictLoaded(dictionary) then asset.users=asset.users+1;asset.lastUsed=GetGameTimer();return true end
    RequestAnimDict(dictionary);local deadline=GetGameTimer()+5000
    while not HasAnimDictLoaded(dictionary) and GetGameTimer()<deadline do Wait(0) end
    if not HasAnimDictLoaded(dictionary) then return false,'Animation dictionary timed out' end
    Cache.assets[dictionary]={users=1,lastUsed=GetGameTimer()}; Cache.Trim(); return true
end
function Cache.Release(dictionary) local asset=Cache.assets[dictionary];if asset then asset.users=math.max(0,asset.users-1);asset.lastUsed=GetGameTimer() end end
function Cache.Trim()
    local total=0;for _ in pairs(Cache.assets) do total=total+1 end
    if total <= Config.Animation.cacheSize then return end
    local oldest,stamp=nil,math.huge;for dictionary,asset in pairs(Cache.assets) do if asset.users==0 and asset.lastUsed<stamp then oldest,stamp=dictionary,asset.lastUsed end end
    if oldest then RemoveAnimDict(oldest);Cache.assets[oldest]=nil end
end
function Cache.Prune()
    local expiry=(Config.Animation.unusedAssetSeconds or 90)*1000;local now=GetGameTimer()
    for dictionary,asset in pairs(Cache.assets) do if asset.users==0 and now-asset.lastUsed>=expiry then RemoveAnimDict(dictionary);Cache.assets[dictionary]=nil end end
end
